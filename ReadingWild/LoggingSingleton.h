//
//  LoggingSingleton.h
//  Memory Training
//
//  Created by Thomas Deegan on 2/10/13 updated 2014
//
//

#import <Foundation/Foundation.h>
#import "AdminViewController.h"

@interface LoggingSingleton : NSObject
{}
@property (nonatomic, retain) NSString *recordsStringWriteBuffer;
@property (nonatomic, retain) NSString *loggingStringWriteBuffer;
@property (nonatomic, retain) NSString *currentCategory; //for storing current state
@property (nonatomic, retain) NSMutableArray *timeAverages;
@property (nonatomic, retain) NSNumber *correctTask;
@property (nonatomic, retain) NSNumber *correctMemory;
@property (nonatomic) NSInteger currentTrial;
+ (LoggingSingleton *)sharedSingleton;

- (void) pushRecord:(NSString*)record;

- (void)writeBufferToFile;


@end
