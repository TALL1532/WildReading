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
    NSInteger time = [(NSNumber*)[(NSDictionary*)[_word_search_tasks objectAtIndex:indexPath.row] objectForKey:TASK_NUM_SECONDS_KEY] integerValue];
    taskCell.timeTextField.text = [NSString stringWithFormat:@"%d", time];
    taskCell.tag = indexPath.row;
    return taskCell;
}

-(void)addWordSearchTask:(id)sender {
    NSLog(@"add task");
    
    NSMutableDictionary * temp_task = [[NSMutableDictionary alloc] init];
    NSNumber * task_duration = [NSNumber numberWithInt:30];
    NSNumber * infinite = [NSNumber numberWithBool:NO];
    
    [temp_task setValue:task_duration forKey:TASK_NUM_SECONDS_KEY];
    [temp_task setValue:infinite forKey:TASK_INFINITE_KEY];
    
    [_word_search_tasks addObject:temp_task];
    [SettingsManager setObject:_word_search_tasks withKey:WORD_SEARCH_TASKS_ARRAY];
    [self refreshTable];
}

-(void)refreshTable {
    [self.wordSearchTaskTable reloadData];
}

@end
