//
//  AnagramViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 11/6/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit.h>
#import <RubyCocoaString/NSString+RubyCocoaString.h>

#import "WildReadingTaskPlayerViewController.h"
#import "InstructionsHelper.h"
#import "WildReadingFeedbackView.h"

@interface AnagramViewController : WildReadingTaskPlayerViewController {
    IBOutlet UILabel * _mainWordlabel;
    
    NSInteger _currentCategoryIndex;
    NSString * _currentWord;
    NSMutableArray * _realWords;
    
    NSString * _constructedWord;
    
    NSMutableArray * _buttons;
    
    NSMutableArray * _categories;
    
    NSMutableArray * _answeredWords;
}

@property (nonatomic, retain) NSString * currentWord;
//@property (nonatomic, retain) UITextField * entryField;
@property (weak, nonatomic) IBOutlet UILabel *scoreDisplay;
@property (weak, nonatomic) IBOutlet WildReadingFeedbackView *feedbackView;

@end

