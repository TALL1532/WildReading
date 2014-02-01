//
//  FluencyViewController.h
//  ReadingWild
//
//  Created by Thomas Deegan on 1/31/14.
//  Copyright (c) 2014 Thomas Deegan. All rights reserved.
//

#import "WildReadingTaskPlayerViewController.h"
#import <RubyCocoaString/NSString+RubyCocoaString.h>
#import <AVFoundation/AVFoundation.h>
#import "AdminViewController.h"

@interface FluencyViewController : WildReadingTaskPlayerViewController <AVAudioRecorderDelegate>{
    NSInteger _currentCategory;
    NSArray * _categories;
    
    AVAudioRecorder * _recorder;
}

- (NSString *)getCategory:(NSInteger)index;

@property (weak, nonatomic) IBOutlet UIImageView *recordingImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@end
