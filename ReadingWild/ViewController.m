//
//  ViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 11/3/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "ViewController.h"
#import "AnagramViewController.h"
#import "WordSearchViewController.h"


#define BUTTON_WIDTH 200.0
#define BUTTON_HEIGHT 60.0
#define SPACING 100.0
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    fluencyButton = [[FUIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-BUTTON_WIDTH)/2,SPACING,BUTTON_WIDTH,BUTTON_HEIGHT)];
    fluencyButton.buttonColor = [UIColor turquoiseColor];
    fluencyButton.shadowColor = [UIColor greenSeaColor];
    fluencyButton.shadowHeight = 3.0f;
    fluencyButton.cornerRadius = 6.0f;
    fluencyButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [fluencyButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [fluencyButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [fluencyButton setTitle:@"Fluency Task" forState:UIControlStateNormal];
    [fluencyButton addTarget:self action:@selector(startAnagram:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fluencyButton];
    
    anagramButton = [[FUIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-BUTTON_WIDTH)/2,2*SPACING + BUTTON_HEIGHT,BUTTON_WIDTH,BUTTON_HEIGHT)];
    anagramButton.buttonColor = [UIColor peterRiverColor];
    anagramButton.shadowColor = [UIColor belizeHoleColor];
    anagramButton.shadowHeight = 3.0f;
    anagramButton.cornerRadius = 6.0f;
    anagramButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [anagramButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [anagramButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [anagramButton setTitle:@"Anagram Task" forState:UIControlStateNormal];
    [anagramButton addTarget:self action:@selector(startAnagram:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:anagramButton];
    
    wordSearchButton = [[FUIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-BUTTON_WIDTH)/2,3*SPACING + 2*BUTTON_HEIGHT,BUTTON_WIDTH,BUTTON_HEIGHT)];
    wordSearchButton.buttonColor = [UIColor alizarinColor];
    wordSearchButton.shadowColor = [UIColor pomegranateColor];
    wordSearchButton.shadowHeight = 3.0f;
    wordSearchButton.cornerRadius = 6.0f;
    wordSearchButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [wordSearchButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [wordSearchButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [wordSearchButton setTitle:@"Word Search Task" forState:UIControlStateNormal];
    [wordSearchButton addTarget:self action:@selector(startWordSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wordSearchButton];
}

- (void)startAnagram:(id)sender{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AnagramViewController * tempViewController = [sb instantiateViewControllerWithIdentifier:@"Anagram"];
    [self.navigationController pushViewController:tempViewController animated:YES];
}

- (void)startWordSearch:(id)sender{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    WordSearchViewController * tempViewController = [sb instantiateViewControllerWithIdentifier:@"WordSearch"];
    [self.navigationController pushViewController:tempViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
