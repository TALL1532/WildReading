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
    
    NSString * _currentWord;
    
}

@property (nonatomic, retain) NSString * currentWord;
//@property (nonatomic, retain) UITextField * entryField;

@end

