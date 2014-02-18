//
//  PuzzleWindow.h
//  WordSearch
//
//  Created by Andrew Battles on 7/25/11. Modified by Thomas Deegan 11/06/13
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PuzzleWindowDelegate
- (void)puzzleWindowWordFound:(NSString*)word correct:(BOOL)correct;
- (void)puzzleWindowLetterPressed:(NSString*)letter;
- (void)puzzleWindowLetterDragged:(NSString*)letter;
@end

@interface PuzzleWindow : UIView {

		
	NSDictionary *attributes;
	
	NSString *letterGrid;
	NSArray *letterGridArray;
	NSArray *xGridPositions;
	NSArray *yGridPositions;
	NSArray *letterArray;
		
	CGPoint touchPt;

	int x1;
	int y1;
	
	int x2;
	int y2;
	
	int letterX;
	int letterY;
	
	NSMutableArray *x1positions;
	NSMutableArray *y1positions;
	NSMutableArray *rectLengths;
	NSMutableArray *rectAngles;
	
	int rectLength;
		  
    CGFloat _width;
    CGFloat _height;
    
    NSInteger _numCol;
    NSInteger _numRow;
    
    CGFloat _colWidth;
    NSArray * _words;
}

@property (retain)  id <PuzzleWindowDelegate> delegate;

@property (nonatomic, retain) NSString * title;

- (id)initWithFrame:(CGRect)frame puzzleName:(NSString*)filename answerName:(NSString *)answerfilename;
- (float)getHypotenuse;
- (float)getAngle:(float)hypo;
- (BOOL)getAngleColoring:(float)angle;

- (void)addRectangle:(int)xOrigin yOrigin:(int)yOrigin length:(float)length angle:(float)angle;

- (BOOL)isAnswer:(NSString *)word;

@end
