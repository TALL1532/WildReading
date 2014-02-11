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

// Puzzle Window delgate
-(void)puzzleWindowWordFound:(NSString*)word{
    _numberWordsFoundInSeries ++;
    [self pushRecordToLog:word];
    _wordsFound.text = [NSString stringWithFormat:@"Score: %d",_numberWordsFoundInSeries];
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

- (void)pushRecordToLog:(NSString*)word{
    NSString * username = [AdminViewController getParticipantName];
    NSString * time = @"1.00";//placeholder
    NSString * puzzleNumber = @"111";
    NSString * wordPressed = word;
    NSString * record = [NSString stringWithFormat:@"WORDS_SEARCH,%@,%@,%@,%@\n",username, time, puzzleNumber,wordPressed];
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
