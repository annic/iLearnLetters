//
//  LineChartView.h
//  iLearnLetters
//
//  Created by Anni Cao on 2013-11-26.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineChartView : UIView

@property (nonatomic) NSMutableArray* data0;
@property (nonatomic) NSMutableArray* data1;
@property (nonatomic) NSMutableArray* data2;

@property (weak) UIColor* color0;
@property (weak) UIColor* color1;
@property (weak) UIColor* color2;

@end
