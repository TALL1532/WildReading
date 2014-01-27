//
//  SettingsManager.m
//  ReadingWild
//
//  Created by Thomas Deegan on 12/5/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "SettingsManager.h"

@implementation SettingsManager

+ (NSObject*) getObjectWithKey:(NSString*)key{
    NSObject *presentValue = (NSObject*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    return presentValue;
}

+ (void) setObject:(NSObject*)value withKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

+ (void)setInteger:(NSInteger)value withKey:(NSString*)key{
    NSNumber* number = [NSNumber numberWithInt:value];
    [SettingsManager setObject:number withKey:key];
}

+ (NSInteger)getIntegerWithKey:(NSString*)key{
    NSNumber* number = (NSNumber*)[SettingsManager getObjectWithKey:key];
    if(number ==  nil)
    {
        [NSException raise:@"NO USER DEFAULT VALUE" format:@"NO USER DEFAULT VALUE"];
    }
    return [number integerValue];
}

+ (void)setFloat:(CGFloat)value withKey:(NSString*)key{
    NSNumber* number = [NSNumber numberWithFloat:value];
    [SettingsManager setObject:number withKey:key];
}
+ (CGFloat)getFloatWithKey:(NSString*)key{
    NSNumber* number = (NSNumber*)[SettingsManager getObjectWithKey:key];
    if(number ==  nil)
    {
        [NSException raise:@"NO USER DEFAULT VALUE" format:@"NO USER DEFAULT VALUE"];
    }
    return [number floatValue];
}


+ (void)setString:(NSString*)value withKey:(NSString*)key{
    [SettingsManager setObject:value withKey:key];
}

+ (NSString*)getStringWithKey:(NSString*)key{
    NSString * string = (NSString*)[SettingsManager getObjectWithKey:key];
    if(string == nil) string = @"";
    return string;
}

+ (void) syncronize{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
