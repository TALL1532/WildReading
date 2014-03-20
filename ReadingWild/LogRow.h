//
//  LogRow.h
//  ReadingWild
//
//  Created by Thomas Deegan on 3/20/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WildReadingTaskPlayerViewController.h"

#define k_header @"Subject, Date, Time, UNIX Time, Round Name, Puzzle ID, Action, Next Pressed, First Letter, Letter, Selected Word, Selected Word ID, Correct, Period Time(ms), Swipe Time(ms), Search Time(ms), Round Score\n"

@interface LogRow : NSObject

@property (nonatomic, retain) NSString * subject_name;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, assign) NSInteger unix_time;
@property (nonatomic, retain) NSString * round_name;
@property (nonatomic, retain) NSString * puzzle_id;
@property (nonatomic, retain) NSString * action;
@property (nonatomic, assign) BOOL next_pressed;
@property (nonatomic, assign) BOOL first_character;
@property (nonatomic, retain) NSString * letter;
@property (nonatomic, retain) NSString * selected_word;
@property (nonatomic, retain) NSString * selected_word_id;
@property (nonatomic, assign) BOOL correct;
@property (nonatomic, assign) NSInteger period_time;
@property (nonatomic, assign) NSInteger swipe_time;
@property (nonatomic, assign) NSInteger search_time;
@property (nonatomic, assign) NSInteger round_score;

- (NSString*)toString;

@end
