//
//  MainPageViewController.h
//
//  Purpose: The interface of class MainPageViewController
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
//  2013-11-19      Anni Cao                    Added segue for game page
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MainPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

-(NSString *)showUserName;

@end
