//
//  TaskCell.m
//  ReadingWild
//
//  Created by Thomas Deegan on 12/4/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

@synthesize timeTextField, lengthSegmentedControl, delegate;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]){
        [self.timeTextField addTarget:self action:@selector(timeLimitChanged:) forControlEvents:UIControlEventValueChanged];
        [self.lengthSegmentedControl addTarget:self action:@selector(lengthSegmentedControl:) forControlEvents:UIControlEventValueChanged];
        [self.logNameTextField addTarget:self action:@selector(logNameChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void) taskTypeChanged:(UISegmentedControl*)sender {
    if(sender.selectedSegmentIndex==0){
        //single
        __taskModel.isInfinite = [NSNumber numberWithBool:NO];
    }else{
        //infinite
        __taskModel.isInfinite = [NSNumber numberWithBool:YES];
    }
}

- (void) timeLimitChanged:(UITextField*)sender {
    
}

- (void) logNameChanged:(UITextField*)sender {
    __taskModel.taskLoggingName = sender.text;
    
}

- (IBAction)deletePressed:(id)sender{
    NSLog(@"Delete Pressed");
}
- (IBAction)timeChanged:(id)sender{
    UITextView * timeTextView = sender;
    NSInteger seconds = [timeTextView.text integerValue];
    NSLog(@"changing time to: %d", seconds);
    __taskModel.taskDurationSeconds = [NSNumber numberWithInt:seconds];
}
- (IBAction)nameChanged:(id)sender{
    UITextView * nameTextView = sender;
    __taskModel.taskLoggingName = nameTextView.text;
}
- (IBAction)segmentChanged:(id)sender{
    UISegmentedControl * segment = sender;
    BOOL isInfinite = [segment selectedSegmentIndex] == 1;
    NSLog(@"%d",isInfinite);
    __taskModel.isInfinite = [NSNumber numberWithBool:isInfinite];
}

- (void) setTaskModel: (Task *)task {
    __taskModel = task;
}


@end
