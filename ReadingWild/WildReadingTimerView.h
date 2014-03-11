//
//  WildReadingTimerView.h
//  ReadingWild
//
//  Created by Thomas Deegan on 11/30/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit.h>


@protocol WildReadingTimerViewDelegate
- (void)wildReadingTimerViewTimeUp;
@end


@interface WildReadingTimerView : UIView {
    UIView * bar;
    UILabel * timerDisplay;
    
    NSTimeInterval _timeLeft;
    
    CGFloat _barWidth;
}

- (void) start:(NSTimeInterval)time;
- (void) pause;

@property (nonatomic) id <WildReadingTimerViewDelegate> delegate;

@end