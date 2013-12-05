//
//  Task.h
//  ReadingWild
//
//  Created by Thomas Deegan on 12/5/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WORD_SEARCH_TASK @"k_word_search_task"
#define ANAGRAM_TASK @"k_anagram_task"
#define FLUENCY_TASK @"k_fluency_task"

@interface Task : NSObject

@property (weak, nonatomic) NSString * task_type;
@property (nonatomic) NSInteger task_duration_seconds;
@property (nonatomic) BOOL isInfinite;

@end
