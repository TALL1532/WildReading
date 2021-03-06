//
//  AnagramViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 11/6/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "AnagramViewController.h"
#import "LogRow.h"
#import <RubyCocoaString/NSString+RubyCocoaString.h>

#define BUTTON_WIDTH 70.0
#define SUBMIT_BUTTON_WIDTH 130.0
#define FINAL_INDEX -1
@interface AnagramViewController ()

@end

@implementation AnagramViewController

@synthesize currentWord = _currentWord;

-(void) setCurrentWord:(NSString*) newWord {
    _currentWord = newWord;
    _mainWordlabel.text = _currentWord;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)generateButtonsFromWord:(NSString*)word{
    NSMutableArray * buttons = [[NSMutableArray alloc] init];
    for(int i = 0; i < word.length; i++){
        FUIButton * tempButton = [[FUIButton alloc] initWithFrame:CGRectMake(0,0,BUTTON_WIDTH,BUTTON_WIDTH)];
        tempButton.buttonColor = [UIColor turquoiseColor];
        tempButton.shadowColor = [UIColor greenSeaColor];
        tempButton.shadowHeight = 3.0f;
        tempButton.cornerRadius = 6.0f;
        tempButton.titleLabel.font = [UIFont boldFlatFontOfSize:40];
        [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        
        [tempButton setTitle:[NSString stringWithFormat:@"%c",[word characterAtIndex:i]] forState:UIControlStateNormal];
        tempButton.tag = [word characterAtIndex:i];
        [buttons addObject:tempButton];
    }
    FUIButton * finalButton = [[FUIButton alloc] initWithFrame:CGRectMake(0,0,SUBMIT_BUTTON_WIDTH,SUBMIT_BUTTON_WIDTH)];
    finalButton.buttonColor = [UIColor wisteriaColor];
    finalButton.shadowColor = [UIColor purpleColor];
    finalButton.shadowHeight = 8.0f;
    finalButton.cornerRadius = (SUBMIT_BUTTON_WIDTH)/2;
    finalButton.titleLabel.font = [UIFont boldFlatFontOfSize:SUBMIT_BUTTON_WIDTH*3/4];
    [finalButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [finalButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

    char checkmark[] = "\u2713";
    NSString * title = [NSString stringWithUTF8String:checkmark];
    [finalButton setTitle:title forState:UIControlStateNormal];
    finalButton.tag = FINAL_INDEX;
    [buttons addObject:finalButton];
    
    return buttons;
}

- (void)setup{
    [self loadFile:@"anagram_words.csv"];
    _currentCategoryIndex = 0;
    _buttons = nil;
    _tasks = [Task getTasks:ANAGRAM_TASK];
    [super setup];
}

- (void) buttonPressed:(id)caller{
    if([(FUIButton*)caller tag] != -1){
        NSString * new_character =[NSString stringWithFormat:@"%c", [(FUIButton*)caller tag]];
        _constructedWord = [_constructedWord concat:new_character];
        BOOL first_letter = ([_constructedWord length] == 1);
        NSString * action = (first_letter ? @"first_letter" : @"letter_enter");

        LogRow * row = [[LogRow alloc] init];
        row.action = action;
        row.first_character = first_letter;
        row.round_name = _series_name;
        row.letter = new_character;
        row.puzzle_id = [NSString stringWithFormat:@"%d",_currentCategoryIndex];

        [self disableButton:caller];
        _mainWordlabel.text = _constructedWord;
        
        if(first_letter){
            _answerStarted = [NSDate date];
        }
        
        [[LoggingSingleton sharedSingleton] pushRecord:[row toString]];
    }
}


- (void) submitWord:(id)caller {
    BOOL correct = NO;
    NSInteger realWordIndex = 999;
    BOOL alreadyFound = NO;
    for(NSString * found in _answeredWords){
        if ([found caseInsensitiveCompare:_constructedWord] == NSOrderedSame) {
            alreadyFound = YES;
        }
    }
    if (!alreadyFound) {
        for(int i = 0; i < [_realWords count]; i++){
            NSString * word = [_realWords objectAtIndex:i];
            if( [_constructedWord caseInsensitiveCompare:word] == NSOrderedSame){
                //used for word id logging
                realWordIndex = i+1;
                //set the answer to correct
                correct = YES;
                //set the time of the last correct answer being found so that we can log duration until the next button is pressed
                _answerEnded = [NSDate date];
                //increase the score
                _numberWordsFoundInSeries ++;
                [self updateScore];
                //make sure we cant select the same word wtice
                [_answeredWords addObject:word];
                break;
            }
        }
    }
    _mainWordlabel.text = self.currentWord;
    
    //push log stuff
    NSString * wordId = [NSString stringWithFormat:@"%d",realWordIndex];
    
    LogRow * row = [[LogRow alloc] init];
    row.action = @"submit";
    row.correct = correct;
    row.selected_word = _constructedWord;
    row.selected_word_id = wordId;
    row.puzzle_id = [NSString stringWithFormat:@"%d",_currentCategoryIndex];
    
    if(_answerStarted != nil && correct){
        NSInteger miliSecondsSinceAnswerStartedToPreviousAnswer = [_answerStarted timeIntervalSinceDate:_previousCorrectAnswerSarted]*1000;
        NSInteger milisecondsSinceStartSwipe = -[_answerStarted timeIntervalSinceNow]*1000;
        NSInteger milisecondsSincePreviousAnswerEnded = [_answerStarted timeIntervalSinceDate:_previousCorrectAnswerEnded]*1000;
        row.period_time = miliSecondsSinceAnswerStartedToPreviousAnswer;
        row.swipe_time = milisecondsSinceStartSwipe;
        row.series_time = [LoggingSingleton getSeriesRunningTime] - milisecondsSinceStartSwipe;
        row.search_time = milisecondsSincePreviousAnswerEnded;
        _previousCorrectAnswerSarted = _answerStarted;
        _previousCorrectAnswerEnded = [NSDate date];
        _answerStarted = nil; //want to reset answer started
    }
    
    if(correct){
        [_feedbackView showPositiveFeedback];
    }
    else{
        [_feedbackView showNegativeFeedback];
    }

    
    [[LoggingSingleton sharedSingleton] pushRecord:[row toString]];
    
    //reset stuff
    _constructedWord = @"";
    for(int i = 0; i< _buttons.count-1; i++){
        FUIButton * b = [_buttons objectAtIndex:i];
        [b setEnabled:YES];
        b.buttonColor = [UIColor turquoiseColor];
        b.shadowColor = [UIColor greenSeaColor];
    }
    
}

#pragma mark implement abstract methods
- (void)startSeries{
    //nothing to do
}

UIView * cover;
- (void) disableTask{
    cover = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 400)];
    [cover setAlpha:.8];
    [cover setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:cover];
}

- (void)enableTask {
    [cover removeFromSuperview];
}

- (void)endSeries {
    [self updateScore];
}

- (NSString*)getInstructionsForTask:(Task*)task {
    if (![task.isInfinite boolValue]){
        return [InstructionsHelper instructionsContentWithFile:ANAGRAM_SINGLE];
    }
    return [InstructionsHelper instructionsContentWithFile:ANAGRAM_MULTIPLE];
}

- (void)pushBufferToLog {
    [[LoggingSingleton sharedSingleton] writeBufferToFile:@"anagram"];
}

- (void) switchPuzzle:(id)sender{
    _answeredWords = [[NSMutableArray alloc] init];
    if (_buttons != nil) {
        for (FUIButton * button in _buttons){
            [button removeFromSuperview];
        }
    }
    NSMutableArray * categoryContent = [_categories objectAtIndex:_currentCategoryIndex];
    [self setCurrentWord:[categoryContent objectAtIndex:0]];
    _realWords = [NSMutableArray arrayWithArray:[categoryContent subarrayWithRange:NSMakeRange(1, [categoryContent count]-1)]];
    _currentCategoryIndex = (_currentCategoryIndex + 1) % [_categories count]; //just loop when we run out
    
    NSMutableArray * buttons = [self generateButtonsFromWord:_currentWord];
    CGFloat spacing = (self.view.frame.size.width - (buttons.count-1)*BUTTON_WIDTH)/(buttons.count);
    for( int i=0; i < buttons.count-1; i++){
        FUIButton * button = [buttons objectAtIndex:i];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(spacing + (spacing + BUTTON_WIDTH)*i, 300, button.frame.size.width, button.frame.size.height);
        [self.view addSubview:button];
    }
    FUIButton * submit = [buttons lastObject];
    [submit addTarget:self action:@selector(submitWord:) forControlEvents:UIControlEventTouchUpInside];
    submit.frame = CGRectMake((self.view.frame.size.width - submit.frame.size.width)/2, 400 , submit.frame.size.width, submit.frame.size.width);
    [self.view addSubview:submit];
    _constructedWord = @"";
    _buttons = buttons;
}

- (void)updateScore {
    [self.scoreDisplay setText:[NSString stringWithFormat:@"Score: %d", _numberWordsFoundInSeries]];
}

- (void) disableButton:(FUIButton*)button {
    button.enabled = NO;
    button.buttonColor = [UIColor cloudsColor];
    button.shadowColor = [UIColor grayColor];
}

- (void) loadFile:(NSString*)filename {
    if( _categories != nil) return;//no need to load the file again if we already did it
    _categories = [[NSMutableArray alloc] init];
    NSString * fullPath = [[NSBundle mainBundle] pathForResource:filename ofType:@""];
    
    NSString * contents = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    NSArray * rows = [contents componentsSeparatedByString:@"\n"];
    for(int i = 1; i < [rows count]; i++){
        NSString * row = [rows objectAtIndex:i];
        NSArray * values = [row componentsSeparatedByString:@","];
        NSString * categoryName = [values objectAtIndex:1];
        
        NSMutableArray * categoryArray = [[NSMutableArray alloc] init];
        [categoryArray addObject:categoryName];
        
        NSArray * realWords = [values subarrayWithRange:NSMakeRange(4, [values count]-4)];
        for(NSString * word in realWords){
            if (![word isBlank]){
                [categoryArray addObject:word];
            }
        }
        // category array contains: <CATEGORY SUBJECT, VALID ANAGRAM, VALID ANAGRAM, VALID ANAGRAM, ... >
        [_categories addObject:categoryArray];
    }
}


@end
