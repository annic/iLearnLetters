//
//  LineChartView.m
//  iLearnLetters
//
//  Created by Anni Cao on 2013-11-26.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import "LineChartView.h"

@implementation LineChartView

- (NSMutableArray*)data0
{
    if (!_data0)
    {
        _data0 = [NSMutableArray new];
    }
    return _data0;
}

- (NSMutableArray*)data1
{
    if (!_data1)
    {
        _data1 = [NSMutableArray new];
    }
    return _data1;
}

- (NSMutableArray*)data2
{
    if (!_data2)
    {
        _data2 = [NSMutableArray new];
    }
    return _data2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat minx = 10.0;
    CGFloat miny = 10.0;
    CGFloat maxx = 650.0;
    CGFloat maxy = 410.0;
    CGFloat width = maxx - minx;
    CGFloat height = maxy - miny;
    
    NSUInteger numYIntervals = 10; // total 10 intervals on the y axis
    CGFloat topYOffset = 50.0;
    CGFloat spacingY = (height - topYOffset) / numYIntervals;
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    
    // Draw the x, y axis
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // X axis with an arrow
    CGContextMoveToPoint(context, minx-2, maxy); // origin
    CGContextAddLineToPoint(context, maxx, maxy);
    
    CGContextMoveToPoint(context, maxx-15, maxy-5);
    CGContextAddLineToPoint(context, maxx, maxy);
    CGContextMoveToPoint(context, maxx-15, maxy+5);
    CGContextAddLineToPoint(context, maxx, maxy);
    
    // Y axis with an arrow
    CGContextMoveToPoint(context, minx, maxy+2); // origin
    CGContextAddLineToPoint(context, minx, miny);
    
    CGContextMoveToPoint(context, minx-5, miny+15);
    CGContextAddLineToPoint(context, minx, miny);
    CGContextMoveToPoint(context, minx+5, miny+15);
    CGContextAddLineToPoint(context, minx, miny);
    
    CGContextStrokePath(context);
    
    // Now draw the actual data!
    NSUInteger count0 = self.data0.count;
    NSUInteger count1 = self.data1.count;
    NSUInteger count2 = self.data2.count;
    
    // Get the max count of elements in three arrays
    NSUInteger maxCount = MAX(MAX(count0, count1), count2);
    if (!maxCount)
        return;
    
    // The number of intervals is the max count + 1
    NSUInteger numXIntervals = maxCount + 1;
    CGFloat spacingX = width / numXIntervals;
    
    // Line width for data
    CGContextSetLineWidth(context, 3.0);
    
    // Draw line 0
    CGContextSetStrokeColorWithColor(context, self.color0.CGColor);
    CGContextMoveToPoint(context, minx, maxy);
    for (NSUInteger i = 0; i < count0; i++)
    {
        CGFloat x = (i + 1) * spacingX;
        CGFloat value = [[self.data0 objectAtIndex:i] floatValue];
        CGFloat y = (1.0 - value) * numYIntervals * spacingY + miny + topYOffset;
        CGContextAddLineToPoint(context, x, y);
    }
    CGContextStrokePath(context);

    // Draw line 1
    CGContextSetStrokeColorWithColor(context, self.color1.CGColor);
    CGContextMoveToPoint(context, minx, maxy);
    for (NSUInteger i = 0; i < count1; i++)
    {
        CGFloat x = (i + 1) * spacingX;
        CGFloat value = [[self.data1 objectAtIndex:i] floatValue];
        CGFloat y = (1.0 - value) * numYIntervals * spacingY + miny + topYOffset;
        CGContextAddLineToPoint(context, x, y);
    }
    CGContextStrokePath(context);

    // Draw line 2
    CGContextSetStrokeColorWithColor(context, self.color2.CGColor);
    CGContextMoveToPoint(context, minx, maxy);
    for (NSUInteger i = 0; i < count2; i++)
    {
        CGFloat x = (i + 1) * spacingX;
        CGFloat value = [[self.data2 objectAtIndex:i] floatValue];
        CGFloat y = (1.0 - value) * numYIntervals * spacingY + miny + topYOffset;
        CGContextAddLineToPoint(context, x, y);
    }
    CGContextStrokePath(context);
}

@end
