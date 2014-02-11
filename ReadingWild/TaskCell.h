//
//  TaskCell.h
//  ReadingWild
//
//  Created by Thomas Deegan on 12/4/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
@class TaskCell;
@protocol TaskCellDelegate
- (void)taskCellChanged:(TaskCell*)taskCell;
@end


@interface TaskCell : UITableViewCell {
    Task * __taskModel;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *lengthSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *logNameTextField;


@property (retain, nonatomic) id <TaskCellDelegate> delegate;


- (IBAction)deletePressed:(id)sender;
- (IBAction)timeChanged:(id)sender;
- (IBAction)nameChanged:(id)sender;
- (IBAction)segmentChanged:(id)sender;
- (void)setTaskModel:(Task*)task;

@end
