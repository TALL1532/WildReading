//
//  WordSearchViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 11/6/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleWindow.h"

@interface WordSearchViewController : UIViewController {
    IBOutlet UILabel * category;
    PuzzleWindow * _currentPuzzleView;
    NSMutableArray * _puzzleViews;
    NSMutableArray * _buttons;
}

- (void)setup:(NSInteger)numPuzzles;

@end
