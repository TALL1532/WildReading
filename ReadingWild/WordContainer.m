//
//  WordContainer.m
//  ReadingWild
//
//  Created by Thomas Deegan on 2/25/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import "WordContainer.h"

@implementation WordContainer

@synthesize word = _word, identifier = _id, puzzleId = _puzzleId;

- (id)init: (NSString*)word identifier:(NSInteger)identifier andPuzzleId:(NSInteger)puzzleId
{
    self = [super init];
    if (self)
    {
        _word = word;
        _id = identifier;
        _puzzleId = puzzleId;
    }
    return self;
}



@end
