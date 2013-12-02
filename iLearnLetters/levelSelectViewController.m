//
//  levelSelectViewController.m
//  iLearnLetters
//
//  Created by Rouzbeh Roshanravan on 2013-11-10.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import "levelSelectViewController.h"
#import "WordsViewController.h"
#import "GameViewController.h"

@interface levelSelectViewController ()

@property (nonatomic, strong) NSString *levelSelected;

@end

@implementation levelSelectViewController

@synthesize levelSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performSegue
{
    // Navigate to the proper page based on the current mode
    if ([self.mode isEqualToString:@"learn"])
    {
        [self performSegueWithIdentifier:@"learnPage" sender:self];
    }
    else if ([self.mode isEqualToString:@"game"])
    {
        [self performSegueWithIdentifier:@"gamePage" sender:self];
    }
}

- (IBAction)easyPressed:(id)sender
{
    levelSelected = @"easy";
    [self performSegue];
}
- (IBAction)hardPressed:(id)sender
{
    levelSelected = @"hard";
    [self performSegue];
}
- (IBAction)customPressed:(id)sender
{
    levelSelected = @"custom";
    [self performSegue];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([self.mode isEqualToString:@"learn"])
    {
        // Pass the selected level to the dest view controller
        WordsViewController *destViewController = segue.destinationViewController;
        destViewController.levelSelected = self.levelSelected;
    }
    else if ([self.mode isEqualToString:@"game"])
    {
        GameViewController *destViewController = segue.destinationViewController;
        destViewController.levelSelected = self.levelSelected;
    }

}
@end
