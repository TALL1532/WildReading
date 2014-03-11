//
//  InstructionsHelper.m
//  ReadingWild
//
//  Created by Thomas Deegan on 2/25/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import "InstructionsHelper.h"

@implementation InstructionsHelper

+ (NSString*)instructionsContentWithFile:(NSString*)filename {
    NSURL * fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:@""];
    return [NSString stringWithContentsOfURL:fileURL usedEncoding:nil error:nil];
}

@end
