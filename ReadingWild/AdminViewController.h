//
//  AdminViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 12/4/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray * _word_search_tasks;
}

@property (weak, nonatomic) IBOutlet UITableView *wordSearchTaskTable;
@property (weak, nonatomic) IBOutlet UIButton *_wordSearchButton;

@end
