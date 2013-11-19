//
//  pieChartView.m
//  pchart
//
//  Created by Rouzbeh Roshanravan on 2013-06-29.
//  Copyright (c) 2013 Rouzbeh. All rights reserved.
//

#import "pieChartView.h"

@implementation pieChartView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setVal1:(float)val1{
    _val1 = val1;
    [self setNeedsDisplay];
}

-(void)setVal2:(float)val2{
    _val2 = val2;
    [self setNeedsDisplay];
}

-(void)setVal3:(float)val3{
    _val3 = val3;
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/

- (void)drawRect:(CGRect)rect
{
    float sum = self.val1 + self.val2 + self.val3 + self.val4;
    float mult = (360/sum);
    
    float startDeg = 0;
    float endDeg = 0;
    
    int x = 350;
    int y = 200;
    int r = 200;
    

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(ctx, 2.0);
    
    startDeg = 0;
    endDeg = (self.val1 * mult);
    
        if(startDeg != endDeg){
        CGContextSetRGBFillColor(ctx, 1.0, 20.0, 0.0, 1.0);
        CGContextMoveToPoint(ctx, x, y);
        CGContextAddArc(ctx, x, y, r, (startDeg)*M_PI/180, (endDeg)*M_PI/180, 0);
        
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);        
    }
    
    startDeg = endDeg;
    endDeg = endDeg + (self.val2 * mult);
    
    if(startDeg != endDeg){
        CGContextSetRGBFillColor(ctx, 0.0, 0.0, 30.0, 1.0);
        CGContextMoveToPoint(ctx, x, y);
        CGContextAddArc(ctx, x, y, r, (startDeg)*M_PI/180, (endDeg)*M_PI/180, 0);
        
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
    }
    
    startDeg = endDeg;
    endDeg = endDeg + (self.val3 * mult);
    
    if(startDeg != endDeg){
        CGContextSetRGBFillColor(ctx, 10.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(ctx, x, y);
        CGContextAddArc(ctx, x, y, r, (startDeg)*M_PI/180, (endDeg)*M_PI/180, 0);
        
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
    }

    startDeg = endDeg;
    endDeg = endDeg + (self.val4 * mult);
    
    if(startDeg != endDeg){
        CGContextSetRGBFillColor(ctx, 10.0, 10.0, 10.0, 1.0);
        CGContextMoveToPoint(ctx, x, y);
        CGContextAddArc(ctx, x, y, r, (startDeg)*M_PI/180, (endDeg)*M_PI/180, 0);
        
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
    }
}

@end
