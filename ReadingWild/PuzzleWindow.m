//
//  PuzzleWindow.m
//  WordSearch
//
//  Created by Andrew Battles on 7/25/1. modified by Thomas Deegan
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PuzzleWindow.h"


#define FONT_SIZE 30.0f
#define PADDING 5.0f
@implementation PuzzleWindow

@synthesize delegate;												//---comm

- (id)init {
    self = [super init];
    return self;
}


- (id)initWithFrame:(CGRect)frame puzzleName:(NSString*)filename{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        _width = frame.size.width;
        _height = frame.size.height;
		
		NSString *wordlistPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"txt"];
        
		NSString *wordlistContent = [NSString stringWithContentsOfFile:wordlistPath
															  encoding:NSUTF8StringEncoding
																 error:nil];	

		letterGridArray = [wordlistContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		letterArray = [wordlistContent componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
        _colWidth = ( _width-((letterGridArray.count+1)*PADDING) ) / [letterGridArray count];
        
		x1 = -50.0;
		y1 = -50.0;
		x2 = -50.0;
		y2 = -50.0;
		
		x1positions = [[NSMutableArray alloc] init];
		y1positions = [[NSMutableArray alloc] init];
		rectLengths = [[NSMutableArray alloc] init];
		rectAngles = [[NSMutableArray alloc] init];
	}

    return self;
}

//////////////////// DRAWING ////////////////////////////////////////////

- (void)drawRect:(CGRect)rect {
    
	// Draw letters into view to create puzzle grid
	
    CGContextRef ctx = UIGraphicsGetCurrentContext();	//set context, must do every time
	
	CGContextSetFillColorWithColor(ctx, [[UIColor greenColor] CGColor]);	//set background white
	CGContextFillRect(ctx,rect);	//actually fill the background
	
	//set up font parameters
	CGContextSelectFont(ctx, "Courier New Bold", _colWidth, kCGEncodingMacRoman);	//set font,size
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
	
	CGAffineTransform xform = CGAffineTransformMake(1.0,  0.0,	//if we dont set this transform,
													0.0, -1.0,	//text is drawn upside-down
													0.0,  0.0);
    CGContextSetTextMatrix(ctx, xform);
	
	//for loop to draw all lines of text
    
	int i;
	for (i=0; i<letterGridArray.count; i++){
	
        //set text to be drawn
        NSArray * text = [[letterGridArray objectAtIndex:(i)] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        for(int j = 0; j < text.count; j++){
            const char * c = [[text objectAtIndex:(j)] UTF8String];
            CGContextShowTextAtPoint(ctx, PADDING + j*(_colWidth+PADDING), PADDING + (i+1)*(_colWidth+PADDING), c, 1);
        }
	}
	//draw any already selected words, if they exist
	int j;
	int xpos;
	int ypos;
	float hyp;
	float ang;
	for (j=0; j < x1positions.count; j++) {
		
		xpos = [[x1positions objectAtIndex:j] intValue];
		ypos = [[y1positions objectAtIndex:j] intValue];
		hyp = [[rectLengths objectAtIndex:j] floatValue];
		ang = [[rectAngles objectAtIndex:j] floatValue];
		
		//rotate around the center point
		CGContextTranslateCTM (ctx, xpos, ypos);
		CGContextRotateCTM(ctx,ang);
		//make green
		CGContextSetRGBFillColor(ctx, 0, 255 ,0, 0.3);
		//draw rectangle
		CGContextFillRect(ctx, CGRectMake(-20, -20,hyp+40, 40));
		
		//reset context translation
		CGContextRotateCTM(ctx,-ang);
		CGContextTranslateCTM(ctx,-xpos,-ypos);
	}
	
	
	//get length of line to draw
	float lineLength = [self getHypotenuse];
						//NSLog(@"Length: %f",lineLength);
	
	//get angle from SOH
	float angle = [self getAngle:lineLength];
	
	//rotate coordinate system so we can have diagonal lines
	CGContextTranslateCTM (ctx, x1, y1);
	CGContextRotateCTM(ctx,angle);
	
	//set the color of the swipe, based on angle
	BOOL colored = [self getAngleColoring:angle];
	
	if(colored) { //blue
		CGContextSetRGBFillColor(ctx, 0, 0, 255, 0.5);	//last number is opacity %
    }
	else {	//gray
		CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5);
	}
	
	//check to make sure swipe is inside bounds
	if((touchPt.x > -10) && (touchPt.x < 710) && (touchPt.y > -10) && (touchPt.y < 610)) {
		//draw line swipe
		CGContextFillRect(ctx, CGRectMake(-25, -25,lineLength+50, 50));
	}
	else {
		//NSLog(@"Swiped out of bounds");
	}
	
	
}

//////////////////// TOUCHES ////////////////////////////////////////////

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)ev {
		
	touchPt = [[touches anyObject] locationInView:self];
	x1 = touchPt.x;
	y1 = touchPt.y;
	x2 = x1;
	y2 = y1;
	
	//get the grid of letter positions
	int xArray[] = {24,82,142,200,262,318,376,436,496,554,614,672};
	int yArray[] = {32,84,132,182,232,280,330,382,432,482,530,582};
	
	//make the touch point equal the nearest letter
	x1 = xArray[x1/60];
	y1 = yArray[y1/50];
	
	x2 = x1;
	y2 = y1;
	
	//[self getLetters];
	[self setNeedsDisplay];
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)ev {
	touchPt = [[touches anyObject] locationInView:self];
	x2 = touchPt.x;
	y2 = touchPt.y;

	//get the grid of letter positions
	int xArray[] = {24,82,142,200,262,318,376,436,496,554,614,672};
	int yArray[] = {32,84,132,182,232,280,330,382,432,482,530,582};
	
	//make the touch point equal the nearest letter
	x2 = xArray[x2/60];
	y2 = yArray[y2/50];
	
	//[self getLetters];
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)ev {
	
	touchPt = [[touches anyObject] locationInView:self];
	
	//make sure we've swiped in bounds
	if((touchPt.x > -10) && (touchPt.x < 710) && (touchPt.y > -10) && (touchPt.y < 610)) {
	
		float hypotenuse = [self getHypotenuse];
		float angle = [self getAngle:hypotenuse];
		int angleOrient = [self getAngleOrientation:angle];
		//NSLog(@"Angle Orientation: %d",angleOrient);
		//NSLog(@"Hypotenuse: %f",hypotenuse);
		
		if(angleOrient != -1) { //if the angle is valid (0,45,90,135,180,225,270,315)
			
			NSString *wordHighlighted = [self getLetters:angleOrient hypo:hypotenuse];
			BOOL save = [[self delegate] compareWords:wordHighlighted];
			
			if(save) {
				[self addRectangle:x1 yOrigin:y1 length:hypotenuse angle:angle];
			}
			
		}
		else {
			//[[self delegate] logIt:@"----- Invalid selection"];
		}
	}		
	
	else {
		//[[self delegate] logIt:@"----- User swiped out of bounds"];
	}
	
	//move the points back out of bounds so nothing is highlighted
	x1 = -50.0;
	y1 = -50.0;
	x2 = -50.0;
	y2 = -50.0;
	
	[self setNeedsDisplay];	
}

/////////////////// HANDLING HIGHLIGHT ///////////////////////////////////

- (float)getHypotenuse {
	
	float xDistSquared = (x2-x1)*(x2-x1);
	float yDistSquared = (y2-y1)*(y2-y1);
	float length = sqrt(xDistSquared + yDistSquared);
	
	//NSLog(@"Length: %f",length);
	return length;
}

- (float)getAngle:(float)hypo {
	
	//find angle
	float angle = asin((y2-y1)/hypo);
	
	//sin only covers positive-quadrant angles.  IF case includes negative angles
	if((x2-x1)<0) {
		angle = -angle + 3.14;
	}
	
	if(isnan(angle)) {
		angle = 0;
	}
					//NSLog(@"Angle: %f",angle);
	return angle;
	
}

- (BOOL)getAngleColoring:(float)angle {
	
	//NSLog(@"Angle: %f",angle);
	BOOL colored;
	
	if ((angle == 0) || ((angle > 3.13) && (angle < 3.15)) ||								//horizontal
		((angle > 1.56) && (angle < 1.58)) || ((angle > -1.58) && (angle < -1.56)) ||		//vertical
		((angle > 0.64) && (angle < 0.75)) || ((angle > -0.76) && (angle < -0.65)) ||		//45 degree diagonals
		((angle > 3.80) && (angle < 3.88)) || ((angle > 2.39) && (angle < 2.484)))    		//45 degree diagonals	
	{				
		colored = YES;
	}
	else {
		colored = NO;
	}

	return colored;
}

- (int)getAngleOrientation:(float)angle {
	
	int orientAngle;
	
	if(angle == 0) {
		orientAngle = 0;
	}
	else {if((angle > 3.13) && (angle < 3.15)) {
		orientAngle = 180;
	}
	else {if((angle > 1.56) && (angle < 1.58)) {
		orientAngle = 90;
	}
	else {if((angle > -1.58) && (angle < -1.56)) {
		orientAngle = 270;
	}
	else { if((angle > 0.64) && (angle < 0.75)) {
		orientAngle = 45;
	}
	else { if((angle > 2.39) && (angle < 2.484)) {
		orientAngle = 135;
	}
	else { if((angle > 3.80) && (angle < 3.88)) {
		orientAngle = 225;
	}
	else { if((angle > -0.76) && (angle < -0.65)) {
		orientAngle = 315;
	}
		//else, its not an acceptable angle
	else {
		orientAngle = -1;
	}}}}}}}}
	
	return orientAngle;
}

/////////////////// HANDLING WORD SELECTION //////////////////////////////

- (NSMutableString *)getLetters:(int)angle hypo:(float)hypotenuse {
	//first, initialize the string for the word to be input
	NSMutableString *theWord = [[NSMutableString alloc] initWithString:@""];
	
	//use the angle and hypotenuse to find the length of the word in letters
	int wordLength;

	if((angle == 0) || (angle == 180)) { //horizontal line
		wordLength = hypotenuse/56+1;
	}
	else {if((angle == 90) || (angle == 270)) { //vertical line
		wordLength = hypotenuse/48+1;
	}
	else { //diagonal line
		wordLength = hypotenuse/73.5+1;
	}}
	//NSLog(@"Word Length: %d",wordLength);
		
	letterX = x1/60; //set up the first position
	letterY = y1/50;
	
	//run a for-loop to collect all the letters
	int i;
	for (i=1; i<(wordLength+1); i++) {

		if((letterY*12+letterX) < 144) { //make sure we're asking for a valid index so the program doesnt crash
			[theWord appendString:[letterArray objectAtIndex:(letterY*12+letterX)]]; //get the current letter, append to word string
		}
		
		//set up the position of the next letter to be added, depending on angle
		if(angle == 0) {
			letterX++;
		}
		else {if(angle == 180) {
			letterX--;
		}
		else {if(angle == 90) {
			letterY++;
		}
		else {if(angle == 270) {
			letterY--;
		}
		else {if(angle == 45) {
			letterX++;
			letterY++;
		}
		else {if(angle == 135) {
			letterX--;
			letterY++;
		}
		else {if(angle == 225) {
			letterX--;
			letterY--;
		}
		else {if(angle == 315) {
			letterX++;
			letterY--;
		}}}}}}}}
	
		
	}
	return theWord;
}

- (void)addRectangle:(int)xOrigin yOrigin:(int)yOrigin length:(float)length angle:(float)angle {
	
	//have to turn these into pointer-accessable values (NSNumbers instead of primitives) so we can store in NSMutableArray
	NSNumber *x = [NSNumber numberWithInteger:xOrigin];
	NSNumber *y = [NSNumber numberWithInteger:yOrigin];
	NSNumber *l = [NSNumber numberWithFloat:length];
	NSNumber *a = [NSNumber numberWithFloat:angle];
	
	[x1positions addObject:x];
	[y1positions addObject:y];
	[rectLengths addObject:l];
	[rectAngles addObject:a];
}


@end
