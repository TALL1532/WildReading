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
#import "AppDelegate.h"


@implementation AdminViewController

-(void)viewDidLoad {
    [self.wordSearchButton addTarget:self action:@selector(addWordSearchTask:) forControlEvents:UIControlEventTouchUpInside];
    self.wordSearchTaskTable.dataSource = self;
    self.wordSearchTaskTable.delegate = self;
    
    [self.anagramAddButton addTarget:self action:@selector(addAnagramTask:) forControlEvents:UIControlEventTouchUpInside];
    self.anagramTaskTable.dataSource = self;
    self.anagramTaskTable.delegate = self;
    
    [self.fluencyAddButton addTarget:self action:@selector(addFluencyTask:) forControlEvents:UIControlEventTouchUpInside];
    self.fluencyTaskTable.dataSource = self;
    self.fluencyTaskTable.delegate = self;
    
    
    self.participantNameTextView.text = [[NSUserDefaults standardUserDefaults] valueForKey:PARTICIPANT_NAME];
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveTasks];
}

//table view delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * currentTask;
    if (tableView == self.wordSearchTaskTable){
        currentTask = WORDSEARCH_TASK;
    }else if (tableView == self.anagramTaskTable) {
        currentTask = ANAGRAM_TASK;
    }
    else if (tableView == self.fluencyTaskTable) { //TODO
        currentTask = FLUENCY_TASK;
    }
    return [[Task getTasks:currentTask] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellid = @"TaskCell";
    NSString * currentTask;
    if (tableView == self.wordSearchTaskTable){
        currentTask = WORDSEARCH_TASK;
    }else if (tableView == self.anagramTaskTable) {
        currentTask = ANAGRAM_TASK;
    }
    else if (tableView == self.fluencyTaskTable) { //TODO
        currentTask = FLUENCY_TASK;
    }
    NSArray * tasks = [Task getTasks:currentTask];
    
    Task * task = [tasks objectAtIndex:indexPath.row];
    
    TaskCell * taskCell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(taskCell == nil){
        taskCell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    NSInteger time = [task.taskDurationSeconds integerValue];
    taskCell.timeTextField.text = [NSString stringWithFormat:@"%d", time];
    taskCell.lengthSegmentedControl.selectedSegmentIndex = [task.isInfinite boolValue] ? 1 : 0;
    taskCell.delegate = self;
    [taskCell setTaskModel:task];
    return taskCell;
}


-(void)addWordSearchTask:(id)sender {
    NSLog(@"add task");
    
    NSArray * tasks = [Task getTasks:WORDSEARCH_TASK];
    
    AppDelegate * mainApp = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = mainApp.managedObjectContext;
    
    Task * newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
    newTask.taskType = WORDSEARCH_TASK;
    newTask.taskLoggingName = @"Something";
    newTask.taskDurationSeconds = [NSNumber numberWithInt:30];
    newTask.isInfinite = [NSNumber numberWithBool:YES];
    //set the next position to be the latest position +1
    
    if([tasks count] <= 0){
        newTask.taskPosition = 0;
    }
    else{
        newTask.taskPosition = [NSNumber numberWithInt:[[((Task*)[tasks lastObject]) taskPosition] integerValue]+1];
    }
    
    NSError * error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self.wordSearchTaskTable reloadData];
}

-(void)addAnagramTask:(id)sender {
    NSLog(@"add task");
    
    NSArray * tasks = [Task getTasks:ANAGRAM_TASK];
    
    AppDelegate * mainApp = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = mainApp.managedObjectContext;
    
    Task * newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
    newTask.taskType = ANAGRAM_TASK;
    newTask.taskLoggingName = @"new task";
    newTask.taskDurationSeconds = [NSNumber numberWithInt:50];
    newTask.isInfinite = [NSNumber numberWithBool:YES];
    //set the next position to be the latest position +1
    
    if([tasks count] <= 0)
    {
        newTask.taskPosition = 0;
    }
    else
    {
        newTask.taskPosition = [NSNumber numberWithInt:[[((Task*)[tasks lastObject]) taskPosition] integerValue]+1];
    }
    
    NSError * error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self.anagramTaskTable reloadData];
}


-(void)addFluencyTask:(id)sender {
    NSLog(@"add task");
    
    NSArray * tasks = [Task getTasks:FLUENCY_TASK];
    
    AppDelegate * mainApp = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = mainApp.managedObjectContext;
    
    Task * newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
    newTask.taskType = FLUENCY_TASK;
    newTask.taskLoggingName = @"new task";
    newTask.taskDurationSeconds = [NSNumber numberWithInt:50];
    newTask.isInfinite = [NSNumber numberWithBool:YES];
    //set the next position to be the latest position +1
    
    if([tasks count] <= 0)
    {
        newTask.taskPosition = 0;
    }
    else
    {
        newTask.taskPosition = [NSNumber numberWithInt:[[((Task*)[tasks lastObject]) taskPosition] integerValue]+1];
    }
    
    NSError * error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self.fluencyTaskTable reloadData];
}




-(void)refreshTable {
    [self.wordSearchTaskTable reloadData];
}

- (void) saveTasks {
    AppDelegate * mainApp = [[UIApplication sharedApplication] delegate];
    [mainApp saveContext];
}

- (IBAction)nameChanged:(id)sender {
    NSString * name = ((UITextField*)sender).text;
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:PARTICIPANT_NAME];
}

+ (NSString*)getParticipantName {
    return [[NSUserDefaults standardUserDefaults] valueForKey:PARTICIPANT_NAME];
}

@end
