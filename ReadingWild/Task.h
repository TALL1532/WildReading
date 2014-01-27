//
//  Task.h
//  
//
//  Created by Thomas Deegan on 1/26/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * taskLoggingName;
@property (nonatomic, retain) NSString * taskType;
@property (nonatomic, retain) NSNumber * taskDurationSeconds;
@property (nonatomic, retain) NSNumber * isInfinite;

@end
