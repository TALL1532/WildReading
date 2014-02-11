//
//  WildReadingTaskPlayerViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 1/31/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WildReadingTimerView.h"
#import "Task.h"
#import "LoggingSingleton.h"
#import "AdminViewController.h"

#define NEXT_BUTTON_WIDTH 100.0
#define INFINITE -1

#define padding 5.0

@interface WildReadingTaskPlayerViewController : UIViewController <WildReadingTimerViewDelegate> {
    UIButton * _nextButton;
    
    NSInteger _currentSeries;
    NSInteger _currentPuzzle;
    NSInteger _numberPuzzlesInSeries;
    NSInteger _numberWordsFoundInSeries;
    WildReadingTimerView * _timer;
    NSArray * _tasks;
    NSInteger _series_time;
    BOOL _seriesIsInfinte;
}

- (void)setup;

- (void)switchPuzzle:(id)sender;

- (void)beginTesting;
- (void)startSeries;

- (void)showInstructions:(NSString*)content;
- (void)instructionsClosed:(id)sender;

- (void)pushRecordToLog:(NSString*)word;

- (void)wildReadingTimerViewTimeUp;

@end
