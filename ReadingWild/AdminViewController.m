//
//  AdminViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 12/4/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "AdminViewController.h"
#import "SettingsManager.h"
#import "Task.h"
#import "TaskCell.h"

@implementation AdminViewController

-(void)viewDidLoad {
    _word_search_tasks = (NSMutableArray*)[SettingsManager getObjectWithKey:WORD_SEARCH_TASKS_ARRAY];
    if(_word_search_tasks == nil){
        _word_search_tasks = [[NSMutableArray alloc] init];
    }
    [self._wordSearchButton addTarget:self action:@selector(addWordSearchTask:) forControlEvents:UIControlEventTouchUpInside];
    _wordSearchTaskTable.dataSource = self;
    _wordSearchTaskTable.delegate = self;
    [super viewDidLoad];
}

//table view delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"num rows: %d", [_word_search_tasks count]);
    return [_word_search_tasks count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellid = @"WordSearchTaskCell";
    TaskCell * taskCell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSLog(@"celllll");
    if(taskCell == nil){
        taskCell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    taskCell.timeTextField.text = [NSString stringWithFormat:@"%d", indexPath.row];
    taskCell.backgroundColor = [UIColor redColor];
    return taskCell;
}

-(void)addWordSearchTask:(id)sender {
    NSLog(@"add task");
    Task * temp = [[Task alloc] init];
    temp.task_duration_seconds = 30;
    temp.task_type = WORD_SEARCH_TASK;
    
    [_word_search_tasks addObject:temp];
    //[SettingsManager setObject:_word_search_tasks withKey:WORD_SEARCH_TASKS_ARRAY];
    [self refreshTable];
}

-(void)refreshTable {
    [self.wordSearchTaskTable reloadData];
}

@end
