//
//  PuzzleWindow.m
//  WordSearch
//
//  Created by Andrew Battles on 7/25/1. modified by Thomas Deegan
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PuzzleWindow.h"
#import <RubyCocoaString/NSString+RubyCocoaString.h>

#define FONT_SIZE 30.0f
#define PADDING 5.0f

@implementation PuzzleWindow

@synthesize delegate;												//---comm

- (id)init {
    self = [super init];
    return self;
}


- (id)initWithFrame:(CGRect)frame puzzleFileContents:(NSString*)gridContents andAnswerList:(NSArray *)answers {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        
        
        _width = frame.size.width;
        _height = frame.size.height;
		      
        _words = answers;
        _foundWords = [[NSMutableArray alloc] init];

        //legacy shit
		letterGridArray = [gridContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		letterArray = [gridContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //------------------------
        
        _grid = [[NSMutableArray alloc] init];
        NSArray * rows = [gridContents componentsSeparatedByString:@"\r\n"];
        if ([rows count] < 2){
            rows = [gridContents componentsSeparatedByString:@"\n"];

        }
        for (NSString * row in rows){
            if([row isEmpty]) continue;
            NSString * cleanRow = [row rstrip];
            NSArray * letterSet = [cleanRow componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [_grid addObject:letterSet];
        }
        
        
       
        
        _numRow = _grid.count;
        _numCol = [[_grid objectAtIndex:0] count];
        
         _colWidth = ( _width ) / (float)_numCol;
        
        NSLog(@"%f",_colWidth);
        
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
    
	for (int i=0; i<_numRow; i++){
        for (int j=0; j<_numCol; j++){
            //set text to be drawn
            NSString * character = [[_grid objectAtIndex:(i)] objectAtIndex:j];
            CGFloat font_offset = (_colWidth - FONT_SIZE)/2;
            CGRect rect = CGRectMake(j*(_colWidth) + font_offset, (i)*(_colWidth) + font_offset, _colWidth, _colWidth);
            [character drawInRect:rect withFont:[UIFont systemFontOfSize:FONT_SIZE] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
            
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
    NSString * letter = [self letterAtX:x2 Y:y2];
    NSLog(@"%@",letter);
    [delegate puzzleWindowLetterPressed:letter];
	[self setNeedsDisplay];
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)ev {
    NSLog(@"DRAGGED!");
	touchPt = [[touches anyObject] locationInView:self];
    int tempx = ((int)((touchPt.x)/_colWidth));
	int tempy = ((int)((touchPt.y)/_colWidth));
    if( tempx != x2 || tempy != y2){
        x2 = tempx;
        y2 = tempy;
        NSString * letter = [self letterAtX:x2 Y:y2];
        NSLog(@"%@",letter);
        [delegate puzzleWindowLetterDragged:letter];
    }
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
			WordContainer * word = [self isAnswer:wordHighlighted];
			if(word) {
				[self addRectangle:x1*_colWidth + _colWidth/2 yOrigin:y1*_colWidth+ _colWidth/2 length:hypotenuse angle:angle];
			}
            [delegate puzzleWindowWordFound:wordHighlighted matchingWord:word];

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
- (NSString *)letterAtX:(int)x Y:(int)y{
    NSInteger size = [_grid count]-1;
    if(x < 0) x = 0;
    if(y < 0) y = 0;
    if(x > size) x = size;
    if(y > size) y = size;
    NSArray * row = [_grid objectAtIndex:y];
    NSString * character = [row objectAtIndex:x];
    return character;
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
			[theWord appendString:[self letterAtX:itx Y:ity]];
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

- (WordContainer *)isAnswer:(NSString*) word{
    for(NSString * found in _foundWords){
        if([word isEqual:found]){
            return nil;
        }
    }
    for(int i = 0; i < _words.count; i++){
        [_foundWords addObject:word];
        WordContainer * temp = [_words objectAtIndex:i];
        if( [temp.word caseInsensitiveCompare:word] == NSOrderedSame ){
            return temp;
        }
    }
    return nil;
}

@end
