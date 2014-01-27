//
//  Task.h
//  
//
//  Created by Thomas Deegan on 1/26/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "AppDelegate.h"

#define ANAGRAM_TASK @"ANAGRAM_TASK_CONST"
#define WORDSEARCH_TASK @"WORDSEARCH_TASK_CONST"
#define FLUENCY_TASK @"FLUENCY_TASK_CONST"


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * taskLoggingName;
@property (nonatomic, retain) NSString * taskType;
@property (nonatomic, retain) NSNumber * taskDurationSeconds;
@property (nonatomic, retain) NSNumber * taskPosition;
@property (nonatomic, retain) NSNumber * isInfinite;

+ (NSArray*)getTasks:(NSString*)type;

@end
