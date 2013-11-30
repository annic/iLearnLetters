//
//  Purpose: Interface for class PhonicsViewController
//
//  Application: iLearnLetters
//
//  Team: Flying Moose - Group 1
//
//  Revision history:
//
//  Date            Author                      Description
//  ---------------------------------------------------------------------------
//  2013-11-29      Anni Cao                    Original definition
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Anni Cao. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol PhonicsDelegate <NSObject>
@required
-(void)selectedPhonics:(NSString *)phonicsName;
@end

@interface PhonicsViewController : UITableViewController

@property (nonatomic, weak) NSArray *phonicsNames;
@property (nonatomic, weak) id<PhonicsDelegate> delegate;

-(id)initWithStyle:(UITableViewStyle)style data:(NSArray*)phonics;
@end
