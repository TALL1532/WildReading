//
//  WildReadingUserSelectionView.h
//  ReadingWild
//
//  Created by Thomas Deegan on 2/8/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//
@class WildReadingUserSelectionView;
@protocol UserSelectionViewDelegate <NSObject>
- (void)selectionView:(WildReadingUserSelectionView*)selectionView selectedUser:(NSString *)user;
@end

#import <UIKit/UIKit.h>

@interface WildReadingUserSelectionView : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray * users;
}

@property (nonatomic, retain) id <UserSelectionViewDelegate> delegate;

@end
