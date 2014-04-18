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
#import "WordContainer.h"
#import "WildReadingFeedbackView.h"
#import "InstructionsHelper.h"

@interface WordSearchViewController : WildReadingTaskPlayerViewController <PuzzleWindowDelegate> {
    IBOutlet UILabel * category;
    PuzzleWindow * _currentPuzzleView;
    NSMutableArray * _puzzleViews;
    NSMutableArray * _buttons;
    
    NSInteger _currentPuzzleIndex;
    NSInteger _currentPuzzleId;
    
    NSMutableArray * _words;
    NSMutableArray * _gridUrls;
    NSMutableDictionary * _categories;
    
    NSSet * _answeredWords;
}

- (void)setup;

@property (retain) IBOutlet UILabel * wordsFound;
@property (weak, nonatomic) IBOutlet WildReadingFeedbackView *feedbackView;

@end
