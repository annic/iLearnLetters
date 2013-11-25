//
//  GameViewController.h
//  iLearnLetters
//
//  Created by Zheng Wang on 2013-11-19.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController{
    UILabel *startLable;
    UILabel *nextLable;
    UIButton *nextButton;
}

@property (strong, nonatomic) NSString *levelSelected;
@property (nonatomic, retain) IBOutlet UILabel *startLable;
@property (nonatomic, retain) IBOutlet UILabel *nextLable;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;

@end
