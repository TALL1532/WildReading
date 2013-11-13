//
//  AnagramViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 11/6/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "AnagramViewController.h"
#define BUTTON_WIDTH 50.0
@interface AnagramViewController ()

@end

@implementation AnagramViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)generateButtonsFromWord:(NSString*)word{
    NSMutableArray * buttons = [[NSMutableArray alloc] init];
    for(int i = 0; i < word.length; i++){
        UIButton * tempButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,BUTTON_WIDTH,BUTTON_WIDTH)];
        tempButton.titleLabel.text = [NSString stringWithFormat:@"%c",[word characterAtIndex:i]];
        tempButton.tag = [word characterAtIndex:i];
        [buttons addObject:tempButton];
    }
    return buttons;
}

- (void)setup:(NSString*)word{
    NSMutableArray * buttons = [self generateButtonsFromWord:word];
    CGFloat spacing = (self.view.frame.size.width - (buttons.count + 1)*BUTTON_WIDTH)/buttons.count;
    for( int i=0; i < buttons.count; i++){
        UIButton * button = [buttons objectAtIndex:i];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(spacing + (spacing + BUTTON_WIDTH)*i, 60, button.frame.size.width, button.frame.size.height);
        button.titleLabel.text = @"asdf";
        button.backgroundColor = [UIColor grayColor];
        [self.view addSubview:button];
    }
}

- (void) buttonPressed:(id)caller{
    NSLog(@"%c", (char)[(UIButton*)caller tag]);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setup:@"HelloWorld"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
