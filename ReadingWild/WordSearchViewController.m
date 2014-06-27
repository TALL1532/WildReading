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
        [_feedbackView showPositiveFeedback];
    }
    else{
        [_feedbackView showNegativeFeedback];
    }
    [self logWordAnswered:word isCorrect:match != nil id:match.identifier];
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
    
    CGFloat windowSize = 650;
    PuzzleWindow * temp = [[PuzzleWindow alloc] initWithFrame:CGRectMake((self.view.frame.size.width - windowSize)/2, self.view.frame.size.height - windowSize - 1.5 * BUTTON_WIDTH - 10.0f, windowSize, windowSize) puzzleFileContents:gridContents andAnswerList:[answers copy] ];
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
    _wordsFound.text = [NSString stringWithFormat:@"Score: %d",_numberWordsFoundInSeries];
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
    LogRow * row = [[LogRow alloc] init];
    row.action = @"start_touch";
    row.first_character = YES;
    row.letter = letter;
    [[LoggingSingleton sharedSingleton] pushRecord:[row toString]];
}

- (void)logLetterDragged:(NSString*)letter {
    //do nothing for now
}
- (void)logWordAnswered:(NSString*)word isCorrect:(BOOL)correct id:(NSInteger)identifier{
    LogRow * row = [[LogRow alloc] init];
    row.action = @"release_touch";
    row.selected_word = word;
    row.selected_word_id = [NSString stringWithFormat:@"%ld",(long)identifier];
    row.correct = correct;
    if(_answerStarted != nil && correct){
        NSInteger miliSecondsSinceAnswerStartedToPreviousAnswer = [_answerStarted timeIntervalSinceDate:_previousCorrectAnswerSarted]*1000;
        NSInteger milisecondsSinceStartSwipe = -[_answerStarted timeIntervalSinceNow]*1000;
        NSInteger milisecondsSincePreviousAnswerEnded = [_answerStarted timeIntervalSinceDate:_previousCorrectAnswerEnded]*1000;
        row.period_time = miliSecondsSinceAnswerStartedToPreviousAnswer;
        row.swipe_time = milisecondsSinceStartSwipe;
        row.search_time = milisecondsSincePreviousAnswerEnded;
        row.series_time = [LoggingSingleton getSeriesRunningTime] - milisecondsSinceStartSwipe;

        _previousCorrectAnswerSarted = _answerStarted;
        _previousCorrectAnswerEnded = [NSDate date];
        _answerStarted = nil; //want to reset answer started
    }
    
    if(correct){
        row.puzzle_id = [row.selected_word_id substringToIndex:3];
    }
    
    [[LoggingSingleton sharedSingleton] pushRecord:[row toString]];
    [self pushBufferToLog];
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
