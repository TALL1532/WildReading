//
//  WordSearchViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 11/6/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "WordSearchViewController.h"
#import "AdminViewController.h"
#import "SettingsManager.h"
#import <FlatUIKit.h>
#define BUTTON_WIDTH 100.0
#define INFINITE -1

#define padding 5.0

@interface WordSearchViewController ()

@end

@implementation WordSearchViewController

#pragma mark Puzzle Window Delegate Mehods

-(void)puzzleWindowWordFound:(NSString*)word correct:(BOOL)correct{
    if(correct) _numberWordsFoundInSeries ++;
    [self logWordAnswered:word isCorrect:(correct ? @"YES" : @"NO")];
    _wordsFound.text = [NSString stringWithFormat:@"Score: %d",_numberWordsFoundInSeries];
}

- (void)puzzleWindowLetterDragged:(NSString *)letter {
    [self logLetterDragged:letter];
}

- (void)puzzleWindowLetterPressed:(NSString *)letter {
    [self logLetterPressed:letter];
}

-(void)wildReadingTimerViewTimeUp {
    [super wildReadingTimerViewTimeUp];
}

- (void)setup{
    _tasks = [Task getTasks:WORDSEARCH_TASK];
    _currentPuzzleIndex = 0;
    [super setup];
}

- (void) switchPuzzle:(id)sender{
    [_currentPuzzleView removeFromSuperview];
    NSDictionary * properties = [self getGridProperties:_currentPuzzleIndex];
    _currentPuzzleIndex ++;
    
    NSString *  gridfile = [properties objectForKey:@"gridfilename"];
    NSString *  listfile = [properties objectForKey:@"listfilename"];
    NSString * title = [properties objectForKey:@"Name"];
    
    PuzzleWindow * temp = [[PuzzleWindow alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 500)/2, self.view.frame.size.height - 500 - (3*BUTTON_WIDTH), 500, 500) puzzleName:gridfile answerName:listfile];
    temp.delegate = self;
    temp.title = title;
    [_puzzleViews addObject:temp];
        
    [self.view addSubview:temp];
    _currentPuzzleView = temp;
    category.text = temp.title;
}


//starts a series of puzzle tasks, num == -1 will result in an infinite set

#pragma mark abstract methods
- (void)startSeries{
    //do nothing
}

UIView * cover;
- (void) disableTask{
    cover = [[UIView alloc] initWithFrame:_currentPuzzleView.frame];
    [cover setAlpha:0.1f];
    [cover setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:cover];
    [_currentPuzzleView setAlpha:0.3f];
    
}

- (void)enableTask {
    [cover removeFromSuperview];
    [_currentPuzzleView setAlpha:1.0f];

}


- (void)endSeries {
    //do nothing for now
}

- (NSString*)getInstructionsForTask:(Task*)task {
    NSString * content = @"In this study, you are going to solve some word puzzles in 12 minutes. The goal is to find as many words as you can from multiple puzzles in 12 minutes. Different puzzles have words in different semantic categories (e.g., animal).  You will see one word puzzle at a time. Once you feel that you cannot find more words in the current puzzle or it is better to try a new puzzle, you can click on the button \"NEXT\" to go to the next puzzle. You will not be able to go back to the previously visited puzzles. Some puzzles are easier than others. However, the program will only present one puzzle at a time in a randomized order. Therefore, you can decide how long you want to spend on each puzzle. There will be a time delay when you visit a new puzzle. Please wait patiently after the next puzzle is loaded completely.   Remember, you are free to switch to a new puzzle anytime you want. The goal is to find as many words as you can in 12 minutes. If you are ready, please press NEXT.";
    return content;
}

- (NSDictionary *)getGridProperties:(NSInteger)i{
    NSArray * myArray = [NSArray arrayWithContentsOfFile:  [[NSBundle mainBundle] pathForResource:@"wordGrids" ofType:@"plist"]];
    NSInteger roundedIndex = i % [myArray count];
    return [myArray objectAtIndex:roundedIndex];
}

#pragma mark - Word Search Logging

- (void)logLetterPressed:(NSString*)letter {
    [self pushRecordToLog:letter firstLetter:@"YES" word:@"" action:@"start_touch" isCorrect:@"" nextButtonPressed:@""];
}
- (void)logLetterDragged:(NSString*)letter {
    [self pushRecordToLog:letter firstLetter:@"NO" word:@"" action:@"start_touch" isCorrect:@"" nextButtonPressed:@""];

}
- (void)logWordAnswered:(NSString*)word isCorrect:(NSString*)correct {
    [self pushRecordToLog:@"" firstLetter:@"" word:word action:@"drag" isCorrect:correct nextButtonPressed:@""];
}

- (void)pushRecordToLog:(NSString*)letter firstLetter:(NSString*)isStart word:(NSString*)word action:(NSString*)actionid isCorrect:(NSString*)correct nextButtonPressed:(NSString*)next {
    NSString * username = [AdminViewController getParticipantName];
    NSString * datemmddyyyy = [LoggingSingleton getCurrentDate];
    NSString * time = [LoggingSingleton getCurrentTime];
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    NSString * unixTime = [NSString stringWithFormat:@"%f",ti*1000];
    NSString * conditionId = @"1";
    NSString * puzzleId = @"111";
    NSString * wordId = @"###";
    
    NSString * record = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n"
                         ,username
                         ,datemmddyyyy
                         ,time
                         ,unixTime
                         ,conditionId
                         ,puzzleId
                         ,actionid
                         ,next
                         ,isStart
                         ,letter
                         ,word
                         ,wordId
                         ,correct];
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
