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

-(void)puzzleWindowWordFound:(NSString*)word matchingWord:(WordContainer *)match{
    if(match){
        _numberWordsFoundInSeries ++;
        _answerEnded = [NSDate date];
    }
    NSString * correct = [NSString stringWithFormat:@"%d",match != nil];
    [self logWordAnswered:word isCorrect:correct id:match.identifier];
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
    [self loadGrids];
    [self loadWordsAndCategories];
    [super setup];
}

- (void)loadWordsAndCategories{
    static int PUZZLE_ID = 0;
    static int WORD_ID = 1;
    static int CATEGORY = 2;
    static int WORD_CONTENT = 3;

    _words = [[NSMutableArray alloc] init];
    _categories = [[NSMutableDictionary alloc] init];
    NSString * fullPath = [[NSBundle mainBundle] pathForResource:@"wordSearchSolutions" ofType:@"csv"];
    NSString * contents = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    NSArray * rows = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for(int i = 0; i < [rows count]; i++){
        NSString * row = [rows objectAtIndex:i];
        NSArray * elements = [row componentsSeparatedByString:@","];
        NSString * contents = [elements objectAtIndex:WORD_CONTENT];
        NSString * stringPuzzleIdentifier = [elements objectAtIndex:PUZZLE_ID];
        NSInteger identifier = [[elements objectAtIndex:WORD_ID] integerValue];
        NSInteger puzzleId  = [stringPuzzleIdentifier integerValue];
        WordContainer * word = [[WordContainer alloc] init:contents identifier:identifier andPuzzleId:puzzleId];
        [_words addObject:word];
        
        NSString * cat = [elements objectAtIndex:CATEGORY];
        if ([_categories objectForKey:stringPuzzleIdentifier] == nil) {
            [_categories setObject:cat forKey:stringPuzzleIdentifier];
        }
    }
}

- (void)loadGrids{
    _gridUrls = [[NSMutableArray alloc] init];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath] error:NULL];
    for (NSString *fileName in files) {
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        if ([fileName includes:@"WORDGRID.txt"]){
            [_gridUrls addObject:url];
        }
    }
}

//returns an array of WordContainers
- (NSMutableArray *)getWordForPuzzleId:(NSInteger)identifier {
    NSMutableArray * matching = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_words count]; i++) {
        WordContainer * word = [_words objectAtIndex:i];
        if (word.puzzleId == identifier) {
            [matching addObject:word];
        }
    }
    return matching;
}

// 
- (NSString *)getCategoryForPuzzleId:(NSInteger)identifierString {
    NSString * identifier = [NSString stringWithFormat:@"%d",identifierString];
    return [_categories objectForKey:identifier];
}

- (NSString *)gridContentsForPuzzleId:(NSInteger)puzzleId{
    NSString * filename = [NSString stringWithFormat:@"%d WORDGRID.txt",puzzleId];
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    NSString * gridContents = [NSString stringWithContentsOfFile:path encoding:NSStringEncodingConversionExternalRepresentation error:nil];
    return gridContents;
}

-(NSString *)categoryForPuzzleId:(NSInteger)puzzleId {
    NSString * title = [self getCategoryForPuzzleId:puzzleId];
    return title;
}

-(NSInteger)puzzleIdForIndex:(NSInteger)index {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"word_search_order.txt" ofType:nil];
    NSString * orderFileContents = [NSString stringWithContentsOfFile:path encoding:NSStringEncodingConversionExternalRepresentation error:nil];
    NSArray * indicies = [orderFileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return [[indicies objectAtIndex:(index % [indicies count])] integerValue];
}

- (void) switchPuzzle:(id)sender{
    _answeredWords = [[NSSet alloc] init];
    [_currentPuzzleView removeFromSuperview];
    
    NSString * gridContents = nil;
    NSInteger puzzleId = -1;
    do {
        puzzleId = [self puzzleIdForIndex:_currentPuzzleIndex];
        gridContents = [self gridContentsForPuzzleId:puzzleId];
        _currentPuzzleIndex ++;
    }while (gridContents == nil);
    
    NSMutableArray * answers = [self getWordForPuzzleId:puzzleId];
    
    NSString * title = [self categoryForPuzzleId:puzzleId];
    
    PuzzleWindow * temp = [[PuzzleWindow alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 500)/2, self.view.frame.size.height - 500 - (3*BUTTON_WIDTH), 500, 500) puzzleFileContents:gridContents andAnswerList:[answers copy] ];
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
    if (![task.isInfinite boolValue]){
        return [InstructionsHelper instructionsContentWithFile:WORDSEARCH_SINGLE];
    }
    return [InstructionsHelper instructionsContentWithFile:WORDSEARCH_MULTIPLE];
}

- (NSDictionary *)getGridProperties:(NSInteger)i{
    NSArray * myArray = [NSArray arrayWithContentsOfFile:  [[NSBundle mainBundle] pathForResource:@"wordGrids" ofType:@"plist"]];
    NSInteger roundedIndex = i % [myArray count];
    return [myArray objectAtIndex:roundedIndex];
}

#pragma mark - Word Search Logging

- (void)logLetterPressed:(NSString*)letter {
    _answerStarted = [NSDate date];
    [self pushRecordToBuffer:letter firstLetter:@"1" word:@"" action:@"start_touch" isCorrect:@"" nextButtonPressed:@"" wordId:@""];
}
- (void)logLetterDragged:(NSString*)letter {
    //do nothing for now
}
- (void)logWordAnswered:(NSString*)word isCorrect:(NSString*)correct id:(NSInteger)identifier{
    [self pushRecordToBuffer:@"" firstLetter:@"" word:word action:@"release_touch" isCorrect:correct nextButtonPressed:@"" wordId:[NSString stringWithFormat:@"%d",identifier]];
    [self pushBufferToLog];
}

- (void)pushRecordToBuffer:(NSString*)letter firstLetter:(NSString*)isStart word:(NSString*)word action:(NSString*)actionid isCorrect:(NSString*)correct nextButtonPressed:(NSString*)next wordId:(NSString*)wordId{
    
    NSString * username = [AdminViewController getParticipantName];
    NSString * datemmddyyyy = [LoggingSingleton getCurrentDate];
    NSString * time = [LoggingSingleton getCurrentTime];
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    NSInteger secondsSinceEpoch = ti;
    NSString * unixTime = [NSString stringWithFormat:@"%d",secondsSinceEpoch];
    NSString * conditionId = @"1";
    NSString * puzzleId = [NSString stringWithFormat:@"%d",_currentPuzzleId];
    
    NSString * duration = @"";
    if(_answerStarted != nil && [correct isEqualToString:@"1"]){
        NSInteger miliSecondsSinceAnswerStartedToPreviousAnswer = [_answerStarted timeIntervalSinceDate:_previousCorrectAnswerSarted]*1000;
        duration = [NSString stringWithFormat:@"%d",miliSecondsSinceAnswerStartedToPreviousAnswer];
        _previousCorrectAnswerSarted = _answerStarted;
        _answerStarted = nil; //want to reset answer started
    }
    
    
    NSString * record = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n"
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
                         ,correct
                         ,duration];
    
    [[LoggingSingleton sharedSingleton] pushRecord:record];
}

- (void)pushBufferToLog {
    [[LoggingSingleton sharedSingleton] writeBufferToFile:@"wordsearch"];
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
