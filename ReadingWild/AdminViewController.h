//
//  AdminViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 12/4/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TASK_NUM_SECONDS_KEY @"k_task_num_seconds"
#define TASK_INFINITE_KEY @"k_task_infinite"

@interface AdminViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray * _word_search_tasks;
}

@property (weak, nonatomic) IBOutlet UITableView *wordSearchTaskTable;
@property (weak, nonatomic) IBOutlet UIButton *_wordSearchButton;

@property (weak, nonatomic) IBOutlet UITableView *anagramTaskTable;
@property (weak, nonatomic) IBOutlet UIButton *anagramAddButton;

@end
