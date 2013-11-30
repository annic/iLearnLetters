//
//  Purpose: Interface for class GameViewController
//
//  Application: iLearnLetters
//
//  Team: Flying Moose - Group 1
//
//  Revision history:
//
//  Date            Author                      Description
//  ---------------------------------------------------------------------------
//  2013-11-19      Anni Cao                    Original definition
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Anni Cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString *levelSelected;

@end
