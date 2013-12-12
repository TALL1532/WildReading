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
-(void)puzzleWindowWordFound {
    _numberWordsFoundInSeries ++;
    _wordsFound.text = [NSString stringWithFormat:@"Score: %d",_numberWordsFoundInSeries];
}

-(void)wildReadingTimerViewTimeUp {
    NSInteger max_sets = 4;
    NSLog(@"Next series");
    _currentSeries ++;
    _tasks = (NSMutableArray*)[SettingsManager getObjectWithKey:WORD_SEARCH_TASKS_ARRAY];
    if(_currentSeries > [_tasks count]-1){
        NSLog(@"done!");
        [[self navigationController] popViewControllerAnimated:YES];
    }
    BOOL isInfinite = [(NSNumber *)[(NSMutableDictionary*)[_tasks objectAtIndex:_currentSeries] objectForKey:TASK_INFINITE_KEY] boolValue];
    _series_time = [(NSNumber *)[(NSMutableDictionary*)[_tasks objectAtIndex:_currentSeries] objectForKey:TASK_NUM_SECONDS_KEY] integerValue];
    if(isInfinite){
        [self startSeries:-1 withTime:_series_time];
    }else{
        [self startSeries:max_sets withTime:_series_time];
    }
}

- (void)setup{
    NSInteger max_sets = 4;
    _currentSeries = 0;
    _tasks = (NSMutableArray*)[SettingsManager getObjectWithKey:WORD_SEARCH_TASKS_ARRAY];
    BOOL isInfinite = [(NSNumber *)[(NSMutableDictionary*)[_tasks objectAtIndex:_currentSeries] objectForKey:TASK_INFINITE_KEY] boolValue];
    _series_time = [(NSNumber *)[(NSMutableDictionary*)[_tasks objectAtIndex:_currentSeries] objectForKey:TASK_NUM_SECONDS_KEY] integerValue];
    
    NSLog(@"time: %d", _series_time);
    if(isInfinite){
        [self startSeries:-1 withTime:_series_time];
    }else{
        [self startSeries:max_sets withTime:_series_time];
    }
    return;
    /*CGFloat spacing = (self.view.frame.size.width - (numPuzzles*BUTTON_WIDTH))/(numPuzzles+1);
    for( int i =0; i < numPuzzles; i++){
        NSDictionary * properties = [self getGridProperties:i];
        NSString *  gridfile = [properties objectForKey:@"gridfilename"];
        NSString *  listfile = [properties objectForKey:@"listfilename"];
        NSString * title = [properties objectForKey:@"Name"];
        PuzzleWindow * temp = [[PuzzleWindow alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 500)/2, self.view.frame.size.height - 500 - (spacing*2+BUTTON_WIDTH), 500, 500) puzzleName:gridfile answerName:listfile];
        temp.title = title;
        [_puzzleViews addObject:temp];
        FUIButton * tempButton = [[FUIButton alloc] initWithFrame:CGRectMake(spacing + i*(spacing+BUTTON_WIDTH), self.view.frame.size.height - BUTTON_WIDTH - spacing, BUTTON_WIDTH, BUTTON_WIDTH)];
        tempButton.buttonColor = [UIColor turquoiseColor];
        tempButton.shadowColor = [UIColor greenSeaColor];
        tempButton.shadowHeight = 3.0f;
        tempButton.cornerRadius = 6.0f;
        tempButton.titleLabel.font = [UIFont boldFlatFontOfSize:30];
        [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        
        [tempButton setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [tempButton addTarget:self action:@selector(switchPuzzle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tempButton];
        [_buttons addObject:tempButton];
        tempButton.tag = i;
    }*/
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
    content.text = @"These are the instructions for the task. You will have X amount of time to complete (a single/an infinite number of) task(s). Search for words in the given category. If you are stuck you may move on to the next puzzle to find more! Try and find as many as you can in the given time!";
    [accept addTarget:self action:@selector(instructionsClosed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)instructionsClosed:(id)sender {
    NSLog(@"instructons closed");
    [[self presentedViewController]  dismissViewControllerAnimated:YES completion:^{
        [self beginTesting];
    }];
}

-(void)beginTesting{
    if(!_timer){
        _timer = [[WildReadingTimerView alloc] initWithFrame:CGRectMake(0.0, 65.0, self.view.frame.size.width, 30)];
        [self.view addSubview:_timer];
        _timer.delegate = self;
    }

    [_timer start:_series_time];
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
    
    [self setup];//[self.view addSubview:_puzzleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
