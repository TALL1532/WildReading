//
//  WordSearchViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 11/6/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "WordSearchViewController.h"

@interface WordSearchViewController ()

@end

@implementation WordSearchViewController

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
	_puzzleView = [[PuzzleWindow alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 500)/2, self.view.frame.size.height - 500 - 20, 500, 500) puzzleName:@"wordGrid1" answerName:@"wordList1"];
    [self.view addSubview:_puzzleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
