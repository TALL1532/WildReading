//
//  AnagramViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 11/6/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "AnagramViewController.h"
#import <RubyCocoaString/NSString+RubyCocoaString.h>
#define BUTTON_WIDTH 65.0
#define FINAL_INDEX -1
@interface AnagramViewController ()

@end

@implementation AnagramViewController

@synthesize currentWord = _currentWord;

-(void) setCurrentWord:(NSString*) newWord {
    _currentWord = newWord;
    _mainWordlabel.text = _currentWord;
}

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
        FUIButton * tempButton = [[FUIButton alloc] initWithFrame:CGRectMake(0,0,BUTTON_WIDTH,BUTTON_WIDTH)];
        tempButton.buttonColor = [UIColor turquoiseColor];
        tempButton.shadowColor = [UIColor greenSeaColor];
        tempButton.shadowHeight = 3.0f;
        tempButton.cornerRadius = 6.0f;
        tempButton.titleLabel.font = [UIFont boldFlatFontOfSize:26];
        [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        
        [tempButton setTitle:[NSString stringWithFormat:@"%c",[word characterAtIndex:i]] forState:UIControlStateNormal];
        tempButton.tag = [word characterAtIndex:i];
        [buttons addObject:tempButton];
    }
    FUIButton * finalButton = [[FUIButton alloc] initWithFrame:CGRectMake(0,0,BUTTON_WIDTH,BUTTON_WIDTH)];
    finalButton.buttonColor = [UIColor wisteriaColor];
    finalButton.shadowColor = [UIColor purpleColor];
    finalButton.shadowHeight = 3.0f;
    finalButton.cornerRadius = 6.0f;
    finalButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [finalButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [finalButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [finalButton setTitle:@">" forState:UIControlStateNormal];
    finalButton.tag = FINAL_INDEX;
    [buttons addObject:finalButton];
    
    return buttons;
}

- (void)setup:(NSString*)word{
    NSMutableArray * buttons = [self generateButtonsFromWord:word];
    CGFloat spacing = (self.view.frame.size.width - (buttons.count)*BUTTON_WIDTH)/(buttons.count+1);
    for( int i=0; i < buttons.count; i++){
        FUIButton * button = [buttons objectAtIndex:i];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(spacing + (spacing + BUTTON_WIDTH)*i, 200, button.frame.size.width, button.frame.size.height);
        [self.view addSubview:button];
    }
    _constructedWord = @"";
    _buttons = buttons;
}

- (void) buttonPressed:(id)caller{
    if([(FUIButton*)caller tag] != -1){
        NSLog(@"yo %@", [NSString stringWithFormat:@"%c", [(FUIButton*)caller tag]]);
        _constructedWord = [_constructedWord concat:[NSString stringWithFormat:@"%c", [(FUIButton*)caller tag]]];
        [self disableButton:caller];
        _mainWordlabel.text = _constructedWord;
        NSLog(@"asd %@",_constructedWord);
    }
    else{
        _mainWordlabel.text = self.currentWord;
        _constructedWord = @"";
        for(int i = 0; i< _buttons.count-1; i++){
            FUIButton * b = [_buttons objectAtIndex:i];
            [b setEnabled:YES];
            b.buttonColor = [UIColor turquoiseColor];
            b.shadowColor = [UIColor greenSeaColor];
        }
    }
}

- (void) disableButton:(FUIButton*)button {
    button.enabled = NO;
    button.buttonColor = [UIColor cloudsColor];
    button.shadowColor = [UIColor grayColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [_mainWordlabel setFont:[UIFont flatFontOfSize:40]];
	[self setup:@"magical"];
    
    self.currentWord = @"magical";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
