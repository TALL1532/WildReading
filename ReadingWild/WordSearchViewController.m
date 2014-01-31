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
    NSInteger max_sets = 4;
    NSLog(@"Next series");
    _currentSeries ++;
    if(_currentSeries > [_tasks count]-1){
        NSLog(@"done!");
        [[self navigationController] popViewControllerAnimated:YES];
        return;
    }
    Task * task = [_tasks objectAtIndex:_currentSeries];
    BOOL isInfinite = [task.isInfinite boolValue];
    _series_time = [task.taskDurationSeconds integerValue];
    if(isInfinite){
        NSLog(@"infinite");
        [self startSeries:max_sets withTime:_series_time];
    }else{
        NSLog(@"Single");
        [self startSeries:1 withTime:_series_time];
    }
}

- (void)setup{
    NSInteger max_sets = 4;
    _currentSeries = 0;
    _tasks = [Task getTasks:WORDSEARCH_TASK];
    Task * task = [_tasks objectAtIndex:_currentSeries];
    BOOL isInfinite = [task.isInfinite boolValue];
    _series_time = [task.taskDurationSeconds integerValue];
    NSLog(@"time: %d %d", _series_time, isInfinite);
    if(isInfinite){
        [self startSeries:max_sets withTime:_series_time];
    }else{
        [self startSeries:1 withTime:_series_time];
    }
    return;
}

- (void) switchPuzzle:(id)sender{
    [_currentPuzzleView removeFromSuperview];
    NSDictionary * properties = [self getGridProperties:_currentPuzzle];
    _currentPuzzle ++;
    
    NSString *  gridfile = [properties objectForKey:@"gridfilename"];
    NSString *  listfile = [properties objectForKey:@"listfilename"];
    NSString * title = [properties objectForKey:@"Name"];
    
    PuzzleWindow * temp = [[PuzzleWindow alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 500)/2, self.view.frame.size.height - 500 - (3*BUTTON_WIDTH), 500, 500) puzzleName:gridfile answerName:listfile];
    temp.delegate = self;
    temp.title = title;
    [_puzzleViews addObject:temp];
    
    if(_numberPuzzlesInSeries == 0){
        _nextButton.hidden = YES;
    }else{
        _nextButton.hidden = NO;
        _numberPuzzlesInSeries--;
    }

    [self.view addSubview:temp];
    _currentPuzzleView = temp;
    category.text = temp.title;
}

- (void)showInstructions {
    UIViewController * instructions = [[UIViewController alloc] init];
    instructions.modalPresentationStyle = UIModalPresentationFormSheet;
    instructions.view.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1.0];
    
    [self presentViewController:instructions animated:YES completion:nil];
    CGFloat button_height = 50.0;
    CGFloat button_width = 100.0;
    FUIButton * accept = [[FUIButton alloc] initWithFrame:CGRectMake((instructions.view.frame.size.width - button_width)/2, instructions.view.frame.size.height - button_height - padding, button_width, button_height)];
    [accept setTitle:@"Start!" forState:UIControlStateNormal];
    accept.buttonColor = [UIColor turquoiseColor];
    accept.shadowColor = [UIColor greenSeaColor];
    accept.shadowHeight = 3.0f;
    accept.cornerRadius = 6.0f;
    accept.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [accept setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [accept setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [instructions.view addSubview:accept];

    UITextView * content = [[UITextView alloc] init];
    content.frame = CGRectMake(padding, padding, instructions.view.frame.size.width - 2*padding, instructions.view.frame.size.height - 3*padding - button_height);
    content.font = [UIFont systemFontOfSize:20];
    [instructions.view addSubview:content];
    content.text = @"In this study, you are going to solve some word puzzles in 12 minutes. The goal is to find as many words as you can from multiple puzzles in 12 minutes. Different puzzles have words in different semantic categories (e.g., animal).  You will see one word puzzle at a time. Once you feel that you cannot find more words in the current puzzle or it is better to try a new puzzle, you can click on the button \"NEXT\" to go to the next puzzle. You will not be able to go back to the previously visited puzzles. Some puzzles are easier than others. However, the program will only present one puzzle at a time in a randomized order. Therefore, you can decide how long you want to spend on each puzzle. There will be a time delay when you visit a new puzzle. Please wait patiently after the next puzzle is loaded completely.   Remember, you are free to switch to a new puzzle anytime you want. The goal is to find as many words as you can in 12 minutes. If you are ready, please press NEXT.";
    [accept addTarget:self action:@selector(instructionsClosed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)instructionsClosed:(id)sender {
    NSLog(@"instructons closed");
    [[self presentedViewController]  dismissViewControllerAnimated:YES completion:^{
        [self beginTesting];
    }];
}

-(void)beginTesting{
    NSLog(@"Begin Testing");
    if(!_timer){
        _timer = [[WildReadingTimerView alloc] initWithFrame:CGRectMake(0.0, 65.0, self.view.frame.size.width, 30)];
        [self.view addSubview:_timer];
        _timer.delegate = self;
    }

    [_timer start:_series_time];
    
    [self switchPuzzle:nil];
}

//starts a series of puzzle tasks, num == -1 will result in an infinite set
- (void)startSeries:(NSInteger)num withTime:(NSInteger)time{
    [self showInstructions];
    _currentPuzzle = 0;
    _numberPuzzlesInSeries = num -1;
    _numberWordsFoundInSeries = 0;
    
}

- (NSDictionary *)getGridProperties:(NSInteger)i{
    NSArray * myArray = [NSArray arrayWithContentsOfFile:  [[NSBundle mainBundle] pathForResource:@"wordGrids" ofType:@"plist"]];
    return [myArray objectAtIndex:i];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _puzzleViews = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    //_currentPuzzleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .5, .5);
    FUIButton * tempButton = [[FUIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - BUTTON_WIDTH)/2, self.view.frame.size.height - 2*BUTTON_WIDTH, BUTTON_WIDTH, BUTTON_WIDTH)];
    tempButton.buttonColor = [UIColor turquoiseColor];
    tempButton.shadowColor = [UIColor greenSeaColor];
    tempButton.shadowHeight = 3.0f;
    tempButton.cornerRadius = 6.0f;
    tempButton.titleLabel.font = [UIFont boldFlatFontOfSize:30];
    [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [tempButton setTitle:@"Next" forState:UIControlStateNormal];
    [tempButton addTarget:self action:@selector(switchPuzzle:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton = tempButton;
    
    [self.view addSubview:tempButton];
    [self setup];//[self.view addSubview:_puzzleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
