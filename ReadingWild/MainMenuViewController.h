//
//  ViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 11/3/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit.h>
#import "FUIButton+FUIButtonAdditions.h"

@interface MainMenuViewController : UIViewController {
    FUIButton * fluencyButton;
    FUIButton * anagramButton;
    FUIButton * wordSearchButton;
    
    NSInteger numPlayed;
}

@end
