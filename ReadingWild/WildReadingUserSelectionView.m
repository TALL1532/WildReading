//
//  WildReadingUserSelectionView.m
//  ReadingWild
//
//  Created by Thomas Deegan on 2/8/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import "WildReadingUserSelectionView.h"

#define topBarHeight 40.0f

@implementation WildReadingUserSelectionView

#pragma mark UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *username = [users objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIdentifier"];
    }
    cell.textLabel.text = username;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * username = [users objectAtIndex:indexPath.row];
    [self.delegate selectionView:self selectedUser:username];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSString * user =[users objectAtIndex:row];
    [users removeObjectAtIndex:row];
    [self.delegate selectionView:self deleteUser:user];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark UIViewController delegate methods

- (void)viewDidLoad {
    //[self.tableView setFrame:CGRectMake(0, topBarHeight, self.tableView.frame.size.width, self.tableView.frame.size.height - topBarHeight)];
    UIButton * editButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 50, topBarHeight)];
    editButton.titleLabel.text = @"Edit";
    [self.tableView addSubview:editButton];
    [editButton addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:editButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSMutableSet * temp = [[NSMutableSet alloc] init];
    NSString *directory = [self getDocumentsDirectory];
    NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
    
    for(NSString *file in files){
        NSInteger logLocation = [file rangeOfString:@"-log.csv"].location;
        if(logLocation != NSNotFound){
            NSString * name = [[file componentsSeparatedByString:@"-"] firstObject];
            [temp addObject:name];
        }
    }
    users =  [NSMutableArray arrayWithArray:[temp allObjects]];
}

- (void)editPressed:(id)sender {
    [self.tableView setEditing:YES animated:NO];
}

#pragma mark helper methods

- (NSString *)getDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}


@end
