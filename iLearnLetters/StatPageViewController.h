//
//  Purpose: Interface for class StatPageViewController
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


#import <UIKit/UIKit.h>

@interface StatPageViewController : UIViewController

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *graphInfoLabel;

@end
