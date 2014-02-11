//
//  WildReadingUserSelectionView.m
//  ReadingWild
//
//  Created by Thomas Deegan on 2/8/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import "WildReadingUserSelectionView.h"

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

#pragma mark UIViewController delegate methods

- (void)viewDidLoad {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    users = [[NSMutableArray alloc] init];
    NSString *directory = [self getDocumentsDirectory];
    NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
    
    for(NSString *file in files){
        NSInteger logLocation = [file rangeOfString:@"-log.csv"].location;
        if(logLocation != NSNotFound){
            NSString * name = [file substringWithRange:NSMakeRange(0, logLocation)];
            [users addObject:name];
        }
    }
}

#pragma mark helper methods

- (NSString *)getDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}


@end
