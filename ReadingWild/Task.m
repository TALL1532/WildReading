//
//  Task.m
//  
//
//  Created by Thomas Deegan on 1/26/14.
//
//

#import "Task.h"


@implementation Task

@dynamic taskLoggingName;
@dynamic taskType;
@dynamic taskDurationSeconds;
@dynamic taskPosition;
@dynamic isInfinite;


+ (NSArray*)getTasks:(NSString*)type {
    AppDelegate * mainApp = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = mainApp.managedObjectContext;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskType = %@", type];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];

    NSError * error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSArray *sortedArray;
    sortedArray = [fetchedObjects sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [(Task*)a taskPosition];
        NSNumber *second = [(Task*)b taskPosition];
        return [first compare:second];
    }];
    return sortedArray;
}


@end
