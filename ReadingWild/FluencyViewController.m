//
//  FluencyViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 1/31/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import "FluencyViewController.h"

@implementation FluencyViewController

@synthesize categoryLabel = _categoryLabel;

- (NSString *)getDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

- (void)setup{
    _tasks = [Task getTasks:FLUENCY_TASK];
    _currentCategory = 0;
    [super setup];
}

- (AVAudioRecorder*) startRecording:(NSString*)fileDump {
    NSString * path = [NSString stringWithFormat:@"%@/%@",[self getDocumentsDirectory],fileDump];
    NSURL * url = [[NSURL alloc] initFileURLWithPath:path];
    //set up recording session
	NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
	//--audio format
	[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC]
					 forKey:AVFormatIDKey];
    
	//--sampling rate
	[recordSetting setValue:[NSNumber numberWithFloat:16000.0]
					 forKey:AVSampleRateKey];
    
	//--stereo sound (2 channel)
	[recordSetting setValue:[NSNumber numberWithInt:2]
					 forKey:AVNumberOfChannelsKey];
    
    AVAudioRecorder * recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
    
    recorder.delegate = self;
    [recorder record];
    self.recordingImage.hidden = NO;
    return recorder;
}

- (void) switchPuzzle:(id)sender{
    
    NSString * category = [self getCategory:_currentCategory];
    [_categoryLabel setText:category];
    _currentCategory ++;
    
    category = [category stringByReplacingOccurrencesOfString:@"/" withString:@""];
    category = [category stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString * user = [AdminViewController getParticipantName];
    NSString * filename = [NSString stringWithFormat:@"fluency_%@_%@.caf",user,category];
    
    _recorder = [self startRecording:filename];

}


//starts a series of puzzle tasks, num == -1 will result in an infinite set
- (void)startSeries{
    //nothing to do
}

- (void) disableTask{
    [_recorder pause];
    [self.recordingImage setAlpha:0.2f];
}

- (void)enableTask {
    [self.recordingImage setAlpha:1.0f];
}

- (void)endSeries {
    [_recorder stop];
    self.recordingImage.hidden = YES;
    NSLog(@"recorder stopped!");
}

- (NSString*)getInstructionsForTask:(Task*)task {
    if (![task.isInfinite boolValue]){
        return [InstructionsHelper instructionsContentWithFile:FLUENCY_SINGLE];
    }
    return [InstructionsHelper instructionsContentWithFile:FLUENCY_MULTIPLE];
}

- (NSString*)getCategory:(NSInteger)index {
    if(!_categories){
        NSString * fullPath = [[NSBundle mainBundle] pathForResource:@"fluencycategories.txt" ofType:@""];
        NSString * contents = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
        NSArray * split = [contents componentsSeparatedByString:@"\n"];
        _categories = split;
    }
    NSInteger i = index % [_categories count];
    return [_categories objectAtIndex:i];
}
#pragma mark - AVAudioRecorderDelegate Methods
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"Done recording~");
}

#pragma mark - Fluency Logging

- (void)pushBufferToLog {
    [[LoggingSingleton sharedSingleton] writeBufferToFile:@"fluency"];
}

//Override the WildReadingTaskPlayer
//We need less fields for this task
- (void)logNextButtonPressed{
    LogRow * row = [[LogRow alloc] init];
    row.action = @"next_button_pressed";
    row.round_name = _series_name;
    row.next_pressed = YES;
    row.puzzle_id = [self getCategory:_currentCategory];
    
    if(_previousCorrectAnswerEnded != nil){
        NSInteger miliSecondsSinceAnswer = [[NSDate date] timeIntervalSinceDate:_previousCorrectAnswerEnded]*1000;
        row.period_time = miliSecondsSinceAnswer;
        _previousCorrectAnswerEnded = nil;
    }
    
    [[LoggingSingleton sharedSingleton] pushRecord:[row toString]];
    [self pushBufferToLog];
}

#pragma mark - Controller Delegate Methods


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


@end
