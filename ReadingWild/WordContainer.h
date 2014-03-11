//
//  WordContainer.h
//  ReadingWild
//
//  Created by Thomas Deegan on 2/25/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordContainer : NSObject {
    NSString * _word;
    NSInteger _id;
    NSInteger _puzzleId;
    NSString * _category;
}

@property (nonatomic) NSString * word;
@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSInteger puzzleId;
@property (nonatomic) NSString * category;

- (id)init: (NSString*)word identifier:(NSInteger)identifier andPuzzleId:(NSInteger)puzzleId;

@end
