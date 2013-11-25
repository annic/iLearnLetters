//
//  UIView+Animation.h
//
//  Purpose: The interface of class UIView (Animation)
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


#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs;
- (void) removeWithZoomOutAnimation:(float)secs;

@end
