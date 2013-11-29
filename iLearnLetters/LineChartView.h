//
//  Purpose: Interface for class LineChartView
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
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Anni Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineChartView : UIView

@property (nonatomic) NSMutableArray* data0;
@property (nonatomic) NSMutableArray* data1;
@property (nonatomic) NSMutableArray* data2;

@property (nonatomic) NSMutableArray* text0;
@property (nonatomic) NSMutableArray* text1;
@property (nonatomic) NSMutableArray* text2;

@property (weak) UIColor* color0;
@property (weak) UIColor* color1;
@property (weak) UIColor* color2;

@property (weak) UILabel* dataLabel;

@end
