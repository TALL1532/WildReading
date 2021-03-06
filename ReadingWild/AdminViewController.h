//
//  AdminViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 12/4/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <RubyCocoaString/NSString+RubyCocoaString.h>

#import "TaskCell.h"
#import "WildReadingUserSelectionView.h"

#define PARTICIPANT_NAME @"Username"
#define NEXT_DELAY @"NextDelay"


@interface AdminViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TaskCellDelegate, UserSelectionViewDelegate, MFMailComposeViewControllerDelegate> {
    NSMutableArray * _word_search_tasks;
    NSMutableArray * _anagram_tasks;
    NSMutableArray * _fluency_tasks;

}

@property (weak, nonatomic) IBOutlet UISwitch *backbuttonSwitch;

@property (weak, nonatomic) IBOutlet UITextField * participantNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *nextDelayTextView;

@property (weak, nonatomic) IBOutlet UITableView *wordSearchTaskTable;
@property (weak, nonatomic) IBOutlet UIButton *wordSearchButton;

@property (weak, nonatomic) IBOutlet UITableView *anagramTaskTable;
@property (weak, nonatomic) IBOutlet UIButton *anagramAddButton;

@property (weak, nonatomic) IBOutlet UITableView *fluencyTaskTable;
@property (weak, nonatomic) IBOutlet UIButton *fluencyAddButton;

- (IBAction)nameChanged:(id)sender;
- (IBAction)delayChanged:(id)sender;
- (IBAction)emailPressed:(id)sender;
- (IBAction)deletePressed:(id)sender;
- (IBAction)switchPressed:(UISwitch *)sender;

+ (NSString*)getParticipantName;

@end
