//
//  WildReadingFeedbackView.m
//  ReadingWild
//
//  Created by Thomas on 4/18/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import "WildReadingFeedbackView.h"

@implementation WildReadingFeedbackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self intialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self intialize];
    }
    return self;
}

- (void)intialize {
    yesImage = [UIImage imageNamed:@"yes.png"];
    noImage = [UIImage imageNamed:@"no.png"];
    timer = nil;
    [self setHidden:YES];
}
- (void)showPositiveFeedback{
    [timer invalidate];
    timer = nil;
    [self setHidden:NO];
    [self setImage:yesImage];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeOut:) userInfo:nil repeats:NO];
    NSLog(@"showing");
}
- (void)showNegativeFeedback{
    [timer invalidate];
    timer = nil;
    [self setHidden:NO];
    [self setImage:noImage];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeOut:) userInfo:nil repeats:NO];
    NSLog(@"showing");

}

- (void)timeOut:(id)sender{
    NSLog(@"hidding");
    [self setHidden:YES];
}

@end
