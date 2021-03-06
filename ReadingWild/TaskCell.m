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
        [self.logNameTextField addTarget:self action:@selector(logNameChanged:) forControlEvents:UIControlEventEditingDidEnd];

        
    }
    return self;
}


- (IBAction)deletePressed:(id)sender{
    AppDelegate * mainApp = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = mainApp.managedObjectContext;
    [context deleteObject:__taskModel];
    [context save:nil];

    [[self delegate] taskCellChanged:self];
}
- (IBAction)timeChanged:(id)sender{
    UITextView * timeTextView = sender;
    NSInteger seconds = [timeTextView.text integerValue];
    NSLog(@"changing time to: %d", seconds);
    __taskModel.taskDurationSeconds = [NSNumber numberWithInt:seconds];
    [self saveContext];
    
}
- (IBAction)nameChanged:(id)sender{
    UITextView * nameTextView = sender;
    __taskModel.taskLoggingName = nameTextView.text;
    [self saveContext];
}
- (IBAction)segmentChanged:(id)sender{
    UISegmentedControl * segment = sender;
    BOOL isInfinite = [segment selectedSegmentIndex] == 1;
    NSLog(@"%d",isInfinite);
    __taskModel.isInfinite = [NSNumber numberWithBool:isInfinite];
    [self saveContext];
}


- (void) setTaskModel: (Task *)task {
    __taskModel = task;
}

- (void) saveContext {
    AppDelegate * mainApp = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = mainApp.managedObjectContext;
    [context save:nil];
}


@end
