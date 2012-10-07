//
//  CalculatorGraphView.m
//  Calculator
//
//  Created by Anton Bogushevsky on 03.10.12.
//
//

#import "CalculatorGraphView.h"

@implementation CalculatorGraphView

@synthesize scale = _scale;

#define DEFAULT_SCALE 0.90

-(CGFloat) scale
{
    if(!_scale)
    {
        return DEFAULT_SCALE;
    }
    else
    {
        return _scale;
    }
}

-(void) setScale:(CGFloat)scale
{
    if(scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES); // 360 degree (0 to 2pi) arc
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

-(void) drawRect:(CGRect)rect
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint; // center of our bounds in our coordinate system
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:self.scale];
    
    /*CGFloat size = self.bounds.size.width / 2;
    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
    size *= self.scale; // scale is percentage of full view size
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context]; // head*/
}

@end
