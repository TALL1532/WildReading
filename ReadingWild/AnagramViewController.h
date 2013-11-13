//
//  AnagramViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 11/6/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnagramViewController : UIViewController {
    IBOutlet UILabel * _mainWordlabel;
    IBOutlet UITextField * _entryField;
    
    NSString * _currentWord;
}

//@property (nonatomic, retain) UILabel * mainWordLabel;
//@property (nonatomic, retain) UITextField * entryField;

@end

