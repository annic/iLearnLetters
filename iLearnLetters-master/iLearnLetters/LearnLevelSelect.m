//
//  LearnLevelSelect.m
//
//  Purpose: The definition of class LearnLevelSelect
//
//  Application: iLearnLetters
//
//  Team: Flying Moose - Group 1
//
//  Revision history:
//
//  Date            Author                      Description
//  ---------------------------------------------------------------------------
//  2013-10-12      R. Roshanravan              Original definition
//  2013-10-19      R. Roshanravan              Major UI improvements
//  2013-10-27      Anni Cao                    Added file headers and comments
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//


#import "LearnLevelSelect.h"
#import "UIView+Animation.h"

@implementation LearnLevelSelect

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


+ (id)levelSelect{
    LearnLevelSelect *levelSelect = [[[NSBundle mainBundle] loadNibNamed:@"LevelLearnSelect" owner:nil options:nil] lastObject];
    
    return levelSelect;
}
- (IBAction)closeView:(id)sender {
    [self removeWithZoomOutAnimation:1.0];
}

@end
