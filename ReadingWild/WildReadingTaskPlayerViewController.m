//
//  WildReadingTaskPlayerViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 1/31/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import "WildReadingTaskPlayerViewController.h"

@implementation WildReadingTaskPlayerViewController


- (void)setup{
    _currentSeries = 0;
    Task * task = [_tasks objectAtIndex:_currentSeries];
    BOOL isInfinite = [task.isInfinite boolValue];
    _series_time = [task.taskDurationSeconds integerValue];
    _seriesIsInfinte = isInfinite;
    [self startSeries];
    [self showInstructions:[self getInstructionsForTask:task]];
    NSLog(@"time: %d %d", _series_time, isInfinite);
    return;
}

- (void)setNextButtonVisibile:(BOOL)visible{
    _nextButton.hidden = !visible;
}

- (void) switchPuzzle:(id)sender{
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
    contentTextView.font = [UIFont systemFontOfSize:20];
    [instructions.view addSubview:contentTextView];
    contentTextView.text = content;
    [accept addTarget:self action:@selector(instructionsClosed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)instructionsClosed:(id)sender {
    NSLog(@"instructons closed");
    [[self presentedViewController]  dismissViewControllerAnimated:YES completion:^{
        [self beginTesting];
    }];
}

-(void)beginTesting{
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

- (void)endSeries {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (NSString*)getInstructionsForTask:(Task*)task {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return @"Need to subclass";
}

#pragma mark - Logging

- (void)pushRecordToLog:(NSString*)word{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
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
    [self endSeries];
    NSLog(@"Next series");
    _currentSeries ++;
    if(_currentSeries > [_tasks count]-1){
        NSLog(@"done!");
        [[self navigationController] popViewControllerAnimated:YES];
        return;
    }
    Task * task = [_tasks objectAtIndex:_currentSeries];
    _series_time = [task.taskDurationSeconds integerValue];
    _seriesIsInfinte = [task.isInfinite boolValue];
    [self startSeries];
    [self showInstructions:[self getInstructionsForTask:task]];
}

#pragma mark - Controller Delegate Methods


// initialize subviews
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    FUIButton * tempButton = [[FUIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - NEXT_BUTTON_WIDTH)/2, self.view.frame.size.height - 2*NEXT_BUTTON_WIDTH, NEXT_BUTTON_WIDTH, NEXT_BUTTON_WIDTH)];
    tempButton.buttonColor = [UIColor turquoiseColor];
    tempButton.shadowColor = [UIColor greenSeaColor];
    tempButton.shadowHeight = 3.0f;
    tempButton.cornerRadius = 20.0f;
    tempButton.titleLabel.font = [UIFont boldFlatFontOfSize:30];
    [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [tempButton setTitle:@"Next" forState:UIControlStateNormal];
    [tempButton addTarget:self action:@selector(switchPuzzle:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton = tempButton;
    
    [self.view addSubview:tempButton];
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
