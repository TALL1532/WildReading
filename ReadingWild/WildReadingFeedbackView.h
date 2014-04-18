//
//  WildReadingFeedbackView.h
//  ReadingWild
//
//  Created by Thomas on 4/18/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WildReadingFeedbackView : UIImageView {
    UIImage * yesImage;
    UIImage * noImage;
    NSTimer * timer;
}
- (void)showPositiveFeedback;
- (void)showNegativeFeedback;
@end
