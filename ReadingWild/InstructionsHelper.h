//
//  InstructionsHelper.h
//  ReadingWild
//
//  Created by Thomas Deegan on 2/25/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ANAGRAM_SINGLE @"anagram_single_instructions.txt"
#define ANAGRAM_MULTIPLE @"anagram_multiple_instructions.txt"
#define WORDSEARCH_SINGLE @"wordsearch_single_instructions.txt"
#define WORDSEARCH_MULTIPLE @"wordsearch_multiple_instructions.txt"
#define FLUENCY_SINGLE @"fluency_single_instructions.txt"
#define FLUENCY_MULTIPLE @"fluency_multiple_instructions.txt"

@interface InstructionsHelper : NSObject

+ (NSString*)instructionsContentWithFile:(NSString*)filename;
@end
