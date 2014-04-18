//
//  LoggingSingleton.h
//  Memory Training
//
//  Created by Thomas Deegan on 2/10/13 updated 2014
//
//

#import <Foundation/Foundation.h>
#import "AdminViewController.h"

@interface LoggingSingleton : NSObject {
    NSDate*  series_start_time;
}
@property (nonatomic, retain) NSString *recordsStringWriteBuffer;
@property (nonatomic, retain) NSString *loggingStringWriteBuffer;
@property (nonatomic, retain) NSString *currentCategory; //for storing current state
@property (nonatomic, retain) NSMutableArray *timeAverages;
@property (nonatomic, retain) NSNumber *correctTask;
@property (nonatomic, retain) NSNumber *correctMemory;
@property (nonatomic) NSInteger currentTrial;
@property NSString * currentTaskName;

+ (LoggingSingleton *)sharedSingleton;

- (void) pushRecord:(NSString*)record;

- (void)writeBufferToFile:(NSString*)filename;

- (NSDate*)getSeriesStartDate;
- (void)setSeriesStartTime;

+ (NSString*)getCurrentDate;
+ (NSString*)getCurrentTime;
+ (NSInteger)getUnixTime;
+ (NSInteger)getSeriesRunningTime;

+ (NSString*)getLogStandardTimeColumns;
@end
