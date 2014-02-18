//
//  LoggingSingleton.m
//  Memory Training
//
//  Created by Thomas Deegan on 2/10/13.
//
// This class will be used a way of tracking subject testing as well as outputing the correct data files.


#import "LoggingSingleton.h"

@implementation LoggingSingleton

+(LoggingSingleton *)sharedSingleton {
    static dispatch_once_t pred;
    static LoggingSingleton *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[LoggingSingleton alloc] init];
    });
    return sharedInstance;
}

- (void)pushRecord:(NSString *)record {
    //might have to make sure there is a new line?
    if (!self.recordsStringWriteBuffer) self.recordsStringWriteBuffer = @"";
    self.recordsStringWriteBuffer = [self.recordsStringWriteBuffer stringByAppendingString:record];
}
- (void)storeTrialDataWithName:(NSString*)name task:(NSString*)task sessionNumber:(NSInteger)sessionNum date:(NSString*)date trial:(NSInteger)trialNum taskAccuracy:(CGFloat)taskAccuracy averageReactionTime:(NSInteger)reactionTime memoryAccuracy:(CGFloat)memoryAccuracy andSpanLevel:(NSInteger)spanLevel{
    if(taskAccuracy == 0){
        taskAccuracy = 0;
    }
    if(reactionTime ==0){
        double rt = 0;
        for(int i =0; i< [self.timeAverages count];i++){
            rt += [[self.timeAverages objectAtIndex:i] doubleValue];
        }
        reactionTime = rt / [self.timeAverages count] * -1000;
    }
    if(memoryAccuracy ==0){
        memoryAccuracy = 0;
    }
    if(spanLevel ==0){
        spanLevel = 0;
    }
    
    NSString* nextLine = [NSString stringWithFormat:@"%@,%@,%d,%@,%d,%f,%d,%f,%d \n",name,task,sessionNum, date,trialNum, taskAccuracy,reactionTime,memoryAccuracy, spanLevel];
    NSLog(@"%@",nextLine);
    self.recordsStringWriteBuffer = [self.recordsStringWriteBuffer stringByAppendingString:nextLine];
}
- (void)storeControlDataWithName:(NSString*)name
                          task:(NSString*)task
                 sessionNumber:(NSInteger)sessionNum
                          date:(NSString*)date
                         trial:(NSInteger)trialNum
                         block:(NSInteger)block
                 itemPresented:(NSString*)itemPresented
                           cat:(NSString*)currentCategory
                    inCategory:(BOOL)isInCat
                    wasCorrect:(int)acc
                  reactionTime:(NSInteger)reactionTime
                  andSpanLevel:(NSInteger)spanLevel{
    NSString* category;
    if([currentCategory isEqualToString:@""]){
        category = task;
    }else{
        category = currentCategory;
    }
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@",."];
    NSString * s = [[itemPresented componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    NSString * acc_content;
    if(acc == 0){
        acc_content = @"True";
    }else if(acc == 1){
        acc_content = @"False";
    }else{
        acc_content = @"N/A";
    }

    NSString* nextLine = [NSString stringWithFormat:@"%@,%@,%d,%@,%d,%d,%@,%@,%@,%d,%d,%@ \n",name, task, sessionNum, date, trialNum, block, s,  (isInCat ? @"YES" : @"NO") ,category, reactionTime ,spanLevel,acc_content];
    NSLog(@"%@",nextLine);
    self.loggingStringWriteBuffer = [self.loggingStringWriteBuffer stringByAppendingString:nextLine];
}

-(void)writeBufferToFile{
    //NSLog(@"writing buffer to file: %@ \n",self.recordsStringWriteBuffer);
    NSString * username = [AdminViewController getParticipantName];
    NSString * filename = [username concat:@"-log.csv"];
    [self writeToEndOfFile:self.recordsStringWriteBuffer withFilename:filename];
    self.recordsStringWriteBuffer = @"";
    
}

- (void)writeToEndOfFile:(NSString*)string withFilename:(NSString*)filename{
    if(string == nil || [string length] == 0) return;
    // NSFileHandle won't create the file for us, so we need to check to make sure it exists
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* path = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],filename];
    NSLog(@"%@",path);
    if (![fileManager fileExistsAtPath:path]) {
        
        // the file doesn't exist yet, so we can just write out the text using the
        // NSString convenience method
        
        NSError *error = nil;
        if([filename isEqualToString:@"control_logs.csv"]){
            string = [NSString stringWithFormat:@"%@%@",@"something?\n",string];
        }
        BOOL success = [string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (!success) {
            // handle the error
            NSLog(@"%@", error);
        }
    }
    else {
        
        // the file already exists, so we should append the text to the end
        
        // get a handle to the file
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        
        // move to the end of the file
        [fileHandle seekToEndOfFile];
        
        // convert the string to an NSData object
        NSData *textData = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        // write the data to the end of the file
        [fileHandle writeData:textData];
        
        // clean up
        [fileHandle closeFile];
    }
}
+ (NSString*)getCurrentDate {
    NSDate *date = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];// here set format which you want...
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
    
    return convertedString;
}

+ (NSString*)getCurrentTime {
    NSDate *date = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:SSSS"];// here set format which you want...
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
    
    return convertedString;
}

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
@end
