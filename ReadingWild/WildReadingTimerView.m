//
//  WildReadingTimerView.m
//  ReadingWild
//
//  Created by Thomas Deegan on 11/30/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "WildReadingTimerView.h"


@implementation WildReadingTimerView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        _barWidth = frame.size.width;
        bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bar.backgroundColor = [UIColor peterRiverColor];
        [self addSubview:bar];
        
        timerDisplay = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        timerDisplay.font = [UIFont systemFontOfSize:20];
        timerDisplay.text = @"";
        timerDisplay.textColor = [UIColor whiteColor];
        [self addSubview:timerDisplay];
        self.backgroundColor = [UIColor silverColor];
    }
    return self;
}

- (NSString*)formatTime:(NSTimeInterval)time{
    NSInteger mins = floor(time / 60);
    NSInteger seconds = floor(time - mins * 60);
    return [NSString stringWithFormat:@"%d:%02d",mins,seconds];
}

- (void) updateTimerDisplay {
    timerDisplay.text = [self formatTime:_timeLeft];
}

- (void)tick:(NSTimer*)timer {
    _timeLeft --;
    if (_timeLeft <= 0) {
        [timer invalidate];
        [delegate wildReadingTimerViewTimeUp];

    }
    [self updateTimerDisplay];
}

- (void)start:(NSTimeInterval)time {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    _timeLeft = time;
    [bar setFrame:CGRectMake(0,0,_barWidth, bar.frame.size.height)];
    
    [UIView animateWithDuration:time delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^
     {
         bar.frame = CGRectMake(0, 0, 0, bar.frame.size.height);
     } completion:^(BOOL finished)
     {
         [self pause];
     }];
}

- (void)pause {
    //[delegate WildReadingTimerDidComplete];
}

@end
