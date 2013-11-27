//
//  GameViewController.h
//  iLearnLetters
//
//  Created by Anni Cao on 2013-11-19.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString *levelSelected;

@end
