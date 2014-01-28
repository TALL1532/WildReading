//
//  AdminViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 12/4/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCell.h"

#define PARTICIPANT_NAME @"Username"

@interface AdminViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TaskCellDelegate> {
    NSMutableArray * _word_search_tasks;
    NSMutableArray * _anagram_tasks;
    NSMutableArray * _fluency_tasks;

}

@property (weak, nonatomic) IBOutlet UITextField * participantNameTextView;

@property (weak, nonatomic) IBOutlet UITableView *wordSearchTaskTable;
@property (weak, nonatomic) IBOutlet UIButton *wordSearchButton;

@property (weak, nonatomic) IBOutlet UITableView *anagramTaskTable;
@property (weak, nonatomic) IBOutlet UIButton *anagramAddButton;

- (IBAction)nameChanged:(id)sender;

+ (NSString*)getParticipantName;

@end
