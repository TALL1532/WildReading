//
//  LogRow.m
//  ReadingWild
//
//  Created by Thomas Deegan on 3/20/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import "LogRow.h"
#import "LoggingSingleton.h"
#import "AdminViewController.h"

static NSString * standardHeader = @"Subject, Date, Time, UNIX Time, Task Running Time, Round Name, Puzzle ID, Action, Next Pressed, First Letter, Letter, Selected Word, Selected Word ID, Correct, Period Time(ms), Swipe Time(ms), Search Time(ms), Round Score\n";
@implementation LogRow


NSInteger * swipe_time;
NSInteger * search_time;
-(id)init{
    if(self = [super init]){
        //set defaults
        self.subject_name = [AdminViewController getParticipantName];
        self.date = [LoggingSingleton getCurrentDate];
        self.time = [LoggingSingleton getCurrentTime];
        self.unix_time = [LoggingSingleton getUnixTime];
        self.round_name = [LoggingSingleton sharedSingleton].currentTaskName;
        self.puzzle_id = @"";
        self.action = @"";
        self.next_pressed = NO;
        self.first_character = NO;
        self.letter = @"";
        self.selected_word = @"";
        self.selected_word_id = @"";
        self.correct = NO;
        self.period_time = 0;
        self.swipe_time = 0;
        self.search_time = 0;
        self.series_time = 0;
        self.round_score = 0;
        
        NSLog(@"series time 2: %d", self.series_time);
    }
    return self;
}

- (NSString*)toString {
    NSString * next_pressed = self.next_pressed ? @"1" : @"";
    NSString * first_character = self.first_character ? @"1" : @"";
    NSString * correct = self.correct ? @"1" : @"";
    NSLog(@"series time: %d", _series_time);
    NSString * series_time = _series_time > 0 ? [NSString stringWithFormat:@"%d", _series_time] : @"";
    return [NSString stringWithFormat:@"%@,%@,%@,%ld,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
            self.subject_name,
            self.date,
            self.time,
            (long)self.unix_time,
            series_time,
            self.round_name,
            self.puzzle_id,
            self.action,
            next_pressed,
            first_character,
            self.letter,
            self.selected_word,
            self.selected_word_id,
            correct,
            (_period_time == 0 ? @"" : [NSString stringWithFormat:@"%d",_period_time]),
            (_swipe_time == 0 ? @"" : [NSString stringWithFormat:@"%d",_swipe_time]),
            (_search_time == 0 ? @"" : [NSString stringWithFormat:@"%d",_search_time]),
            (_round_score == 0 ? @"" : [NSString stringWithFormat:@"%d",_round_score])];
}


@end
