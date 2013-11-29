//
//  Purpose: Implementation for class LineChartView
//
//  Application: iLearnLetters
//
//  Team: Flying Moose - Group 1
//
//  Revision history:
//
//  Date            Author                      Description
//  ---------------------------------------------------------------------------
//  2013-11-26      Anni Cao                    Original definition
//  2013-11-28      Anni Cao                    Added dynamic graph info
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Anni Cao. All rights reserved.
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

- (NSMutableArray*)text0
{
    if (!_text0)
    {
        _text0 = [NSMutableArray new];
    }
    return _text0;
}

- (NSMutableArray*)text1
{
    if (!_text1)
    {
        _text1 = [NSMutableArray new];
    }
    return _text1;
}

- (NSMutableArray*)text2
{
    if (!_text2)
    {
        _text2 = [NSMutableArray new];
    }
    return _text2;
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
    CGFloat maxx = rect.size.width - 10.0; // 650.0;
    CGFloat maxy = rect.size.height - 10.0; // 410.0;

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
    
    // Draw rulers on Y axis
    for (int i = 1; i <= numYIntervals; i++)
    {
        float value = (float)i / numYIntervals;
        CGFloat y = (1.0 - value) * numYIntervals * spacingY + miny + topYOffset;
        CGContextMoveToPoint(context, minx, y);
        CGContextAddLineToPoint(context, minx + 10, y);
    }
    
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
    
    // Draw ruler on X axis
    for (int i = 1; i < numXIntervals; i++)
    {
        CGFloat x = i * spacingX;
        CGContextMoveToPoint(context, x, maxy);
        CGContextAddLineToPoint(context, x, maxy - 10);
    }
    CGContextStrokePath(context);
    
    // X and Y axis labels
    UILabel* xLabel = [UILabel new];
    xLabel.frame = CGRectMake(maxx - 40, maxy - 30, 50, 20);
    xLabel.text = @"Time";
    xLabel.textColor = [UIColor whiteColor];
    xLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:xLabel];
    
    UILabel* yLabel = [UILabel new];
    yLabel.frame = CGRectMake(minx + 20, miny + 10, 50, 20);
    yLabel.text = @"Score";
    yLabel.textColor = [UIColor whiteColor];
    yLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:yLabel];
    
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
        
        UIButton *buttonToAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonToAdd setBackgroundColor:self.color0];
        
        buttonToAdd.tag = i;
        buttonToAdd.frame = CGRectMake(x - 7.5, y - 7.5, 15.0f, 15.0f);
        [buttonToAdd addTarget:self action:@selector(showDataText:)
              forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        
        [self addSubview:buttonToAdd];
        
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
        
        UIButton *buttonToAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonToAdd setBackgroundColor:self.color1];
        
        buttonToAdd.tag = 256 + i;
        buttonToAdd.frame = CGRectMake(x - 7.5, y - 7.5, 15.0f, 15.0f);
        [buttonToAdd addTarget:self action:@selector(showDataText:)
              forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        
        [self addSubview:buttonToAdd];

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
        
        UIButton *buttonToAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonToAdd setBackgroundColor:self.color2];
        
        buttonToAdd.tag = 512 + i;
        buttonToAdd.frame = CGRectMake(x - 7.5, y - 7.5, 15.0f, 15.0f);
        [buttonToAdd addTarget:self action:@selector(showDataText:)
              forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        
        [self addSubview:buttonToAdd];

    }
    CGContextStrokePath(context);
}

- (IBAction)showDataText:(id)sender
{
    UIButton* button = sender;
    int tag = button.tag;
    int arrayIndex = tag / 256;
    int textIndex = tag - (256 * arrayIndex);
    NSString* dataText = nil;
    switch (arrayIndex)
    {
        case 0:
            dataText = [self.text0 objectAtIndex:textIndex];
            break;
        
        case 1:
            dataText = [self.text1 objectAtIndex:textIndex];
            break;
            
        default:
            dataText = [self.text2 objectAtIndex:textIndex];
            break;
    }
    self.dataLabel.text = dataText;
}

@end
