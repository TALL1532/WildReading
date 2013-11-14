//
//  WordSearchViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 11/6/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "WordSearchViewController.h"
#import <FlatUIKit.h>
#define BUTTON_WIDTH 50.0

@interface WordSearchViewController ()

@end

@implementation WordSearchViewController

- (void)setup:(NSInteger)numPuzzles{
    CGFloat spacing = (self.view.frame.size.width - (numPuzzles*BUTTON_WIDTH))/(numPuzzles+1);
    for( int i =0; i < numPuzzles; i++){
        NSDictionary * properties = [self getGridProperties:i];
        NSString *  gridfile = [properties objectForKey:@"gridfilename"];
        NSString *  listfile = [properties objectForKey:@"listfilename"];
        NSString * title = [properties objectForKey:@"Name"];
        PuzzleWindow * temp = [[PuzzleWindow alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 500)/2, self.view.frame.size.height - 500 - (spacing*2+BUTTON_WIDTH), 500, 500) puzzleName:gridfile answerName:listfile];
        temp.title = title;
        [_puzzleViews addObject:temp];
        FUIButton * tempButton = [[FUIButton alloc] initWithFrame:CGRectMake(spacing + i*(spacing+BUTTON_WIDTH), self.view.frame.size.height - BUTTON_WIDTH - spacing, BUTTON_WIDTH, BUTTON_WIDTH)];
        tempButton.buttonColor = [UIColor turquoiseColor];
        tempButton.shadowColor = [UIColor greenSeaColor];
        tempButton.shadowHeight = 3.0f;
        tempButton.cornerRadius = 6.0f;
        tempButton.titleLabel.font = [UIFont boldFlatFontOfSize:30];
        [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        
        [tempButton setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [tempButton addTarget:self action:@selector(switchPuzzle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tempButton];
        [_buttons addObject:tempButton];
        tempButton.tag = i;
    }
    
}

- (void) switchPuzzle:(id)sender{
    FUIButton * button = (FUIButton*)sender;
    NSInteger num = button.tag;
    [_currentPuzzleView removeFromSuperview];
    PuzzleWindow * nextPuzzle = [_puzzleViews objectAtIndex:num];
    [self.view addSubview:nextPuzzle];
    _currentPuzzleView = nextPuzzle;
    category.text = nextPuzzle.title;
}

- (NSDictionary *)getGridProperties:(NSInteger)i{
    NSArray * myArray = [NSArray arrayWithContentsOfFile:  [[NSBundle mainBundle] pathForResource:@"wordGrids" ofType:@"plist"]];
    return [myArray objectAtIndex:i];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _puzzleViews = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    //_currentPuzzleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .5, .5);
    [self setup:4];//[self.view addSubview:_puzzleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
