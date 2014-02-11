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
#import "WildReadingTaskPlayerViewController.h"

@interface WordSearchViewController : WildReadingTaskPlayerViewController <PuzzleWindowDelegate> {
    IBOutlet UILabel * category;
    PuzzleWindow * _currentPuzzleView;
    NSMutableArray * _puzzleViews;
    NSMutableArray * _buttons;
    
    NSInteger _currentPuzzleIndex;
}

- (void)setup;

@property (retain) IBOutlet UILabel * wordsFound;

@end
