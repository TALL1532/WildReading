//
//  ViewController.m
//  ReadingWild
//
//  Created by Thomas Deegan on 11/3/13.
//  Copyright (c) 2013 Thomas Deegan. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AnagramViewController.h"
#import "WordSearchViewController.h"
#import "FluencyViewController.h"

#define BUTTON_WIDTH 300.0
#define BUTTON_HEIGHT 120.0
#define SPACING 100.0
#define BUTTON_FONT_SIZE 26.0

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    NSLog(@"%f",ti);
    numPlayed = -1;
    
    [super viewDidLoad];
    
    wordSearchButton = [[FUIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-BUTTON_WIDTH)/2,SPACING,BUTTON_WIDTH,BUTTON_HEIGHT)];
    wordSearchButton.buttonColor = [UIColor alizarinColor];
    wordSearchButton.shadowColor = [UIColor pomegranateColor];
    wordSearchButton.shadowHeight = 3.0f;
    wordSearchButton.cornerRadius = 6.0f;
    wordSearchButton.titleLabel.font = [UIFont boldFlatFontOfSize:BUTTON_FONT_SIZE];
    

    [wordSearchButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [wordSearchButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [wordSearchButton setTitle:@"Word Search Puzzle" forState:UIControlStateNormal];
    [wordSearchButton addTarget:self action:@selector(startWordSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wordSearchButton];
    
    anagramButton = [[FUIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-BUTTON_WIDTH)/2,2*SPACING + BUTTON_HEIGHT,BUTTON_WIDTH,BUTTON_HEIGHT)];
    anagramButton.buttonColor = [UIColor peterRiverColor];
    anagramButton.shadowColor = [UIColor belizeHoleColor];
    anagramButton.shadowHeight = 3.0f;
    anagramButton.cornerRadius = 6.0f;
    anagramButton.titleLabel.font = [UIFont boldFlatFontOfSize:BUTTON_FONT_SIZE];
    [anagramButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [anagramButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [anagramButton setTitle:@"Anagram Puzzle" forState:UIControlStateNormal];
    [anagramButton addTarget:self action:@selector(startAnagram:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:anagramButton];
    
    
    fluencyButton = [[FUIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-BUTTON_WIDTH)/2,3*SPACING + 2*BUTTON_HEIGHT,BUTTON_WIDTH,BUTTON_HEIGHT)];
    fluencyButton.buttonColor = [UIColor turquoiseColor];
    fluencyButton.shadowColor = [UIColor greenSeaColor];
    fluencyButton.shadowHeight = 3.0f;
    fluencyButton.cornerRadius = 6.0f;
    fluencyButton.titleLabel.font = [UIFont boldFlatFontOfSize:BUTTON_FONT_SIZE];
    [fluencyButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [fluencyButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [fluencyButton setTitle:@"Category Puzzle" forState:UIControlStateNormal];
    [fluencyButton addTarget:self action:@selector(startFluency:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fluencyButton];
    
    [self nextTask];
}

- (void)disableButtons{
    [fluencyButton setEnabled:NO];
    [wordSearchButton setEnabled:NO];
    [anagramButton setEnabled:NO];
    if(numPlayed == 0) [wordSearchButton  setEnabled:YES];
    if(numPlayed == 1) [anagramButton  setEnabled:YES];
    if(numPlayed == 2) [fluencyButton  setEnabled:YES];
}

- (void)nextTask{
    numPlayed = (numPlayed + 1)%3;
    [self disableButtons];
}

- (void)startFluency:(id)sender{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FluencyViewController * tempViewController = [sb instantiateViewControllerWithIdentifier:@"Fluency"];
    [self.navigationController pushViewController:tempViewController animated:YES];
    [self nextTask];
    
}

- (void)startAnagram:(id)sender{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AnagramViewController * tempViewController = [sb instantiateViewControllerWithIdentifier:@"Anagram"];
    [self.navigationController pushViewController:tempViewController animated:YES];
    [self nextTask];
}

- (void)startWordSearch:(id)sender{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    WordSearchViewController * tempViewController = [sb instantiateViewControllerWithIdentifier:@"WordSearch"];
    [self.navigationController pushViewController:tempViewController animated:YES];
    [self nextTask];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
