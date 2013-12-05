//
//  SettingsManager.h
//  ReadingWild
//
//  Created by Thomas Deegan on 12/5/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WORD_SEARCH_TASKS_ARRAY @"k_word_search_task_array"

@interface SettingsManager : NSObject {
    
}

+ (NSObject*) getObjectWithKey:(NSString*)key;
+ (void) setObject:(NSObject*)value withKey:(NSString*)key;

+ (void)setInteger:(NSInteger)value withKey:(NSString*)key;
+ (NSInteger)getIntegerWithKey:(NSString*)key;

+ (void)setFloat:(CGFloat)value withKey:(NSString*)key;
+ (CGFloat)getFloatWithKey:(NSString*)key;

+ (void)setString:(NSString*)value withKey:(NSString*)key;
+ (NSString*)getStringWithKey:(NSString*)key;

+ (void) syncronize;

@end
