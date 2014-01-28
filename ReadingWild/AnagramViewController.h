//
//  AnagramViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 11/6/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit.h>

@interface AnagramViewController : UIViewController {
    IBOutlet UILabel * _mainWordlabel;
    
    UIButton * _nextButton;

    
    NSString * _currentWord;
    NSString * _constructedWord;
    NSMutableArray * _buttons;
    
    NSMutableSet * _realWords;
    
    
    NSInteger _score;
}

@property (nonatomic, retain) NSString * currentWord;
//@property (nonatomic, retain) UITextField * entryField;
@property (weak, nonatomic) IBOutlet UILabel *scoreDisplay;

@end

