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


- (id)initWithFrame:(CGRect)frame puzzleName:(NSString*)filename answerName:(NSString *)answerfilename{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        
        self.title = filename;
        
        _width = frame.size.width;
        _height = frame.size.height;
		
		NSString * gridPath = [[NSBundle mainBundle] pathForResource:filename ofType:@""];
        
		NSString * gridContents = [NSString stringWithContentsOfFile:gridPath
															  encoding:NSUTF8StringEncoding
																 error:nil];	

        NSString *wordlistPath = [[NSBundle mainBundle] pathForResource:answerfilename ofType:@""];
        
		NSString *wordlistContent = [NSString stringWithContentsOfFile:wordlistPath
															  encoding:NSUTF8StringEncoding
																 error:nil];
        _words = [wordlistContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

		letterGridArray = [gridContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		letterArray = [gridContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
        _colWidth = ( _width ) / [letterGridArray count];
        
        _numRow = letterGridArray.count;
        _numCol = [[letterGridArray objectAtIndex:0] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].count;
        
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
	
	CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);	//set background white
	CGContextFillRect(ctx,rect);	//actually fill the background
	
	//set up font parameters
    
	CGContextSelectFont(ctx, "Courier New Bold", FONT_SIZE, kCGEncodingMacRoman);	//set font,size
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
            
            CGRect rect = CGRectMake(j*(_colWidth), (i)*(_colWidth), _colWidth, _colWidth);
            [[NSString stringWithFormat:@"%c",*c] drawInRect:rect withFont:[UIFont systemFontOfSize:24.0] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
            
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
	CGContextTranslateCTM (ctx, x1*_colWidth + _colWidth/2, y1*_colWidth + _colWidth/2);
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
		CGContextFillRect(ctx, CGRectMake(-_colWidth/2, -_colWidth/2 + PADDING,lineLength+_colWidth, _colWidth-PADDING));
	}
	else {
		//NSLog(@"Swiped out of bounds");
	}
}

//////////////////// TOUCHES ////////////////////////////////////////////

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)ev {
		
	touchPt = [[touches anyObject] locationInView:self];
	
	//make the touch point equal the nearest letter
	x1 = ((int)((touchPt.x)/_colWidth));
	y1 = ((int)((touchPt.y)/_colWidth));
	x2 = x1;
	y2 = y1;
    NSLog(@"%d, %d", x1, y1);
	[self setNeedsDisplay];
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)ev {
	touchPt = [[touches anyObject] locationInView:self];
    x2 = ((int)((touchPt.x)/_colWidth));
	y2 = ((int)((touchPt.y)/_colWidth));
    NSLog(@"%d, %d", x2, y2);

	//[self getLetters];
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)ev {
	
	touchPt = [[touches anyObject] locationInView:self];
	
	//make sure we've swiped in bounds
	if((touchPt.x > -10) && (touchPt.x < 710) && (touchPt.y > -10) && (touchPt.y < 610)) {
	
		float hypotenuse = [self getHypotenuse];
		float angle = [self getAngle:hypotenuse];
		int angleOrient = [self getHighlightOrient];
		
		if(angleOrient != -1) {
			NSString *wordHighlighted = [self getHighlightContent];
            NSLog(@"%@", wordHighlighted);
			BOOL save = [self isAnswer:wordHighlighted];
			if(save) {
                [delegate puzzleWindowWordFound:wordHighlighted];
				[self addRectangle:x1*_colWidth + _colWidth/2 yOrigin:y1*_colWidth+ _colWidth/2 length:hypotenuse angle:angle];
			}
		}
		else {
		}
	}		
	
	else {
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
    float xdist =abs(x2-x1)*_colWidth;
    float ydist =abs(y2-y1)*_colWidth;
	float xDistSquared = xdist*xdist;
	float yDistSquared = ydist*ydist;
	float length = sqrt(xDistSquared + yDistSquared);
	
	//NSLog(@"Length: %f",length);
	return length;
}

- (float)getAngle:(float)hypo {
	
	//find angle
	float angle = asin((y2-y1)/(hypo/_colWidth));
	
	//sin only covers positive-quadrant angles.  IF case includes negative angles
	if((x2-x1)<0) {
		angle = -angle + 3.14;
	}
	
	if(isnan(angle)) {
		angle = 0;
	}
	return angle;
	
}

- (BOOL)getAngleColoring:(float)angle {
	NSInteger orient = [self getHighlightOrient];
    if(orient == -1) return false;
    return true;
}


/* Returns an integer between [-1 , 7] that corrsesponds to the orientation of the current selection
 * -1 - Bad Orientation
 * 0 - N
 * 1 - NE
 * 2 - E
 * 3 - SE
 * 4 - S
 * 5 - SW
 * 6 - W
 * 7 - NW
 */
- (int)getHighlightOrient{
	if(x1 == x2){
        if(y2 == y1) return -1;
        else if (y2 > y1) return 4;
        else return 0;
    }
    else if(y2 == y1){
        if(x1 == x2) return -1;
        else if(x2 > x1) return 2;
        else return 6;
    }
    else if ( abs(y2 - y1) - abs(x2 - x1) == 0 ){
        if(y2-y1 > 0){
            if( x2 > x1 ) return 3;
            else return 5;
        }else{
            if( x2 > x1 ) return 1;
            else return 7;
        }
    }
	return -1;
}
- (int)getHighlightLength{
    return MAX(abs(y2-y1), abs(x2-x1))+1;
}

/////////////////// HANDLING WORD SELECTION //////////////////////////////
- (const char *)letterAt:(int)i :(int)j{
    NSArray * text = [[letterGridArray objectAtIndex:(i)] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    const char * c = [[text objectAtIndex:(j)] UTF8String];
    return c;
}
- (NSMutableString *)getHighlightContent{
	//first, initialize the string for the word to be input
	NSMutableString *theWord = [[NSMutableString alloc] initWithString:@""];
	
	int orientation = [self getHighlightOrient];
    if (orientation == -1) {
        return theWord;
    }
    int length = [self getHighlightLength];
    
    int itx = x1;
    int ity = y1;
    for(int i = 0; i < length; i++){
        if((itx*12+ity) < _numCol * _numRow) {
			[theWord appendString:[letterArray objectAtIndex:(ity*_numCol+itx)]];
		}
        switch (orientation) {
            case 0:
                ity --;
                break;
            case 1:
                ity --;
                itx ++;
                break;
            case 2:
                itx ++;
                break;
            case 3:
                ity ++;
                itx ++;
                break;
            case 4: //SOUTH
                ity ++;
                break;
            case 5:
                ity ++;
                itx --;
                break;
            case 6:
                itx --;
                break;
            case 7:
                ity --;
                itx --;
                break;
            default:
                break;
        }
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

-(BOOL)isAnswer:(NSString*) word{
    for(int i = 0; i < _words.count; i++){
        NSString * temp = (NSString*)[_words objectAtIndex:i];
        if( [temp isEqualToString:word] ){
            return true;
        }
    }
    return false;
}

@end
