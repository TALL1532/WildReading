//
//  WildReadingTaskPlayerViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 1/31/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import "WildReadingTaskPlayerViewController.h"
#import "LoggingSingleton.h"

@implementation WildReadingTaskPlayerViewController


- (void)setup{
    _currentSeries = 0;
    if ([_tasks count] < 1){
        return;
    }
    Task * task = [_tasks objectAtIndex:_currentSeries];
    BOOL isInfinite = [task.isInfinite boolValue];
    _series_time = [task.taskDurationSeconds integerValue];
    _seriesIsInfinte = isInfinite;
    _series_name = task.taskLoggingName;
    [LoggingSingleton sharedSingleton].currentTaskName = _series_name;
    [self startSeries];
    [self showInstructions:[self getInstructionsForTask:task]];
    NSLog(@"time: %d %d", _series_time, isInfinite);
    return;
}

- (void)setNextButtonVisibile:(BOOL)visible{
    _nextButton.hidden = !visible;
}

- (void)nextPressed:(id)sender {
    
    NSNumber * delay = [[NSUserDefaults standardUserDefaults] objectForKey:NEXT_DELAY];
    double d = [delay floatValue];

    _spinner = [[UIActivityIndicatorView alloc] initWithFrame:_nextButton.frame];
    [_spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_spinner setColor:[UIColor turquoiseColor]];
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    [_nextButton setHidden:YES];
    
    [self disableTask];
    
    _shouldCancelNext = NO;
    [self logNextButtonPressed];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, d * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (_shouldCancelNext) return;
        [self stopSpinner];
        [self switchPuzzle:nil];
    });
}

/**
 * Shoud be used to stop the next button spinner and return the game to its normal state faster than the timeout does
 */
- (void)stopSpinner {
    _shouldCancelNext = YES;
    [self enableTask];
    [_nextButton setHidden:NO];
    [_spinner removeFromSuperview];
    
    //reset the search timers
    _previousCorrectAnswerSarted = [NSDate date];
    _previousCorrectAnswerEnded = [NSDate date];
    
    [[LoggingSingleton sharedSingleton] setSeriesStartTime];

}

- (void) switchPuzzle:(id)sender {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)showInstructions:(NSString*)content {
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
    
    UITextView * contentTextView = [[UITextView alloc] init];
    contentTextView.frame = CGRectMake(padding, padding, instructions.view.frame.size.width - 2*padding, instructions.view.frame.size.height - 3*padding - button_height);
    contentTextView.font = [UIFont systemFontOfSize:25];
    [instructions.view addSubview:contentTextView];
    contentTextView.text = content;
    [contentTextView setEditable:NO];
    //[contentTextView setUserInteractionEnabled:NO];
    
    [accept addTarget:self action:@selector(instructionsClosed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)instructionsClosed:(id)sender {
    NSLog(@"instructons closed");
    [[self presentedViewController]  dismissViewControllerAnimated:YES completion:^{
        [self beginTesting];
    }];
}

-(void)beginTesting{
    _previousCorrectAnswerSarted = [NSDate date]; // Used to caluculate the time to find a correct answer so we need to initialize it.
    _previousCorrectAnswerEnded = [NSDate date];
    
    [[LoggingSingleton sharedSingleton] setSeriesStartTime];
    LogRow * instructionsClosedEventRow = [[LogRow alloc] init];
    instructionsClosedEventRow.action = @"instruction closed";
    [[LoggingSingleton sharedSingleton] pushRecord:[instructionsClosedEventRow toString]];
    
    _currentPuzzle = 0;
    NSLog(@"Begin Testing");
    if(!_timer){
        _timer = [[WildReadingTimerView alloc] initWithFrame:CGRectMake(0.0, 65.0, self.view.frame.size.width, 30)];
        [self.view addSubview:_timer];
        _timer.delegate = self;
    }
    
    [_timer start:_series_time];
    [self setNextButtonVisibile:_seriesIsInfinte];
    [self switchPuzzle:nil];
}

#pragma mark abstract methods

- (void)startSeries{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

/**
 * This method should be overwritten by each subclass to disable the puzzle while the spinner is moving.
 */
- (void) disableTask{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

/**
 * This method should be overwritten by each subclass to re-enable the puzzle when the spinner stops.
 */
- (void)enableTask {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)endSeries {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (NSString*)getInstructionsForTask:(Task*)task {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return @"Need to subclass";
}

#pragma mark - Logging

- (void)pushBufferToLog {
    //send the log to write to a specific file
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)logNextButtonPressed{
    LogRow * row = [[LogRow alloc] init];
    row.action = @"next_button_pressed";
    row.round_name = _series_name;
    row.next_pressed = YES;
    row.series_time = [LoggingSingleton getSeriesRunningTime];
    if(_previousCorrectAnswerEnded != nil){
        NSInteger miliSecondsSinceAnswer = [[NSDate date] timeIntervalSinceDate:_previousCorrectAnswerSarted]*1000;
        row.period_time = miliSecondsSinceAnswer;
        _previousCorrectAnswerEnded = nil;
    }
   
    [[LoggingSingleton sharedSingleton] pushRecord:[row toString]];
    
    [self pushBufferToLog];
}

- (void)logSeriesScore:(NSInteger)score {
    LogRow * row = [[LogRow alloc] init];
    row.action = @"series_end";
    row.round_name = _series_name;
    row.round_score = score;
    row.series_time = [LoggingSingleton getSeriesRunningTime];
    
    if(_answerEnded != nil){
        NSInteger miliSecondsSinceAnswer = [[NSDate date] timeIntervalSinceDate:_previousCorrectAnswerSarted]*1000;
        row.period_time = miliSecondsSinceAnswer;
        _answerEnded = nil;
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

#pragma mark timer view delegate methods
-(void)wildReadingTimerViewTimeUp {
    [self logSeriesScore:_numberWordsFoundInSeries];
    [self pushBufferToLog];
    _numberWordsFoundInSeries = 0;

    [self endSeries];
    
    //load next set
    _currentSeries ++;
    if(_currentSeries > [_tasks count]-1){
        NSLog(@"done!");
        [[self navigationController] popViewControllerAnimated:YES];
        return;
    }
    Task * task = [_tasks objectAtIndex:_currentSeries];
    _series_time = [task.taskDurationSeconds integerValue];
    _seriesIsInfinte = [task.isInfinite boolValue];
    _series_name = task.taskLoggingName;
    [LoggingSingleton sharedSingleton].currentTaskName = _series_name;
    //reset score
    NSLog(@"RESET SCORE");
    [self startSeries];
    [self showInstructions:[self getInstructionsForTask:task]];
    
    [self stopSpinner];
}

#pragma mark - Controller Delegate Methods


// initialize subviews
- (void)viewDidLoad
{
    _answerStarted = nil;
    _answerEnded = nil;
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    FUIButton * tempButton = [[FUIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - NEXT_BUTTON_WIDTH)/2, self.view.frame.size.height - 1.5*NEXT_BUTTON_WIDTH, NEXT_BUTTON_WIDTH, NEXT_BUTTON_WIDTH)];
    tempButton.buttonColor = [UIColor turquoiseColor];
    tempButton.shadowColor = [UIColor greenSeaColor];
    tempButton.shadowHeight = 3.0f;
    tempButton.cornerRadius = 10.0f;
    tempButton.titleLabel.font = [UIFont boldFlatFontOfSize:50];
    [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    char arrow[] = "\u21D2";
    NSString * title = [NSString stringWithUTF8String:arrow];
    [tempButton setTitle:title forState:UIControlStateNormal];
    
    [tempButton addTarget:self action:@selector(nextPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tempButton setHidden:YES];
    _nextButton = tempButton;
    
    [self.view addSubview:tempButton];
    [self setup];
    
    _shouldCancelNext = YES;
    _numberWordsFoundInSeries = 0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
