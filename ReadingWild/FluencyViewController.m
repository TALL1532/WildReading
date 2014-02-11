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
    
    NSString * user = [AdminViewController getParticipantName];
    NSString * filename = [NSString stringWithFormat:@"fluency_%@_%@.caf",user,category];
        
    _recorder = [self startRecording:filename];
    
    
    if(_numberPuzzlesInSeries == 0){
        _nextButton.hidden = YES;
    }else{
        _nextButton.hidden = NO;
        _numberPuzzlesInSeries--;
    }

}


//starts a series of puzzle tasks, num == -1 will result in an infinite set
- (void)startSeries{
    //nothing to do
}

- (void)endSeries {
    [_recorder stop];
    self.recordingImage.hidden = YES;
    NSLog(@"recorder stopped!");
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

- (void)pushRecordToLog:(NSString*)word{
    NSString * username = [AdminViewController getParticipantName];
    NSString * time = @"1.00";//placeholder
    NSString * puzzleNumber = @"111";
    NSString * wordPressed = word;
    NSString * record = [NSString stringWithFormat:@"FLUENCY,%@,%@,%@,%@\n",username, time, puzzleNumber,wordPressed];
    [[LoggingSingleton sharedSingleton] pushRecord:record];
    [[LoggingSingleton sharedSingleton] writeBufferToFile];
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
