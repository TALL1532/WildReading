//
//  WordSearchViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 11/6/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleWindow.h"
#import "WildReadingTimerView.h"
#import "LoggingSingleton.h"

@interface WordSearchViewController : UIViewController <PuzzleWindowDelegate, WildReadingTimerViewDelegate> {
    IBOutlet UILabel * category;
    PuzzleWindow * _currentPuzzleView;
    NSMutableArray * _puzzleViews;
    NSMutableArray * _buttons;
    UIButton * _nextButton;
    
    NSInteger _currentSeries;
    NSInteger _currentPuzzle;
    NSInteger _numberPuzzlesInSeries;
    NSInteger _numberWordsFoundInSeries;
    WildReadingTimerView * _timer;
    NSArray * _tasks;
    NSInteger _series_time;
}

- (void)setup;

@property (retain) IBOutlet UILabel * wordsFound;

@end
