//
//  WordsViewController.h
//
//  Purpose: The interface of class WordsViewController
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
#import "PhonicsViewController.h"

@interface WordsViewController : UIViewController<PhonicsDelegate, UIActionSheetDelegate>
{    
    CGPoint lastPoint;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSString *levelSelected;

@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;


- (IBAction)reset:(id)sender;

@end
