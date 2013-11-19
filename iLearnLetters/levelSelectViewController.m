//
//  levelSelectViewController.m
//  iLearnLetters
//
//  Created by Rouzbeh Roshanravan on 2013-11-10.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import "levelSelectViewController.h"
#import "WordsViewController.h"

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
- (IBAction)easyPressed:(id)sender {
    [self performSegueWithIdentifier:@"learnPage" sender:self];
    
    levelSelected = @"easy";
}
- (IBAction)hardPressed:(id)sender {
    [self performSegueWithIdentifier:@"learnPage" sender:self];
    levelSelected = @"hard";
}
- (IBAction)customPressed:(id)sender {
    [self performSegueWithIdentifier:@"learnPage" sender:self];
    levelSelected = @"custom";
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    

        WordsViewController *destViewController = segue.destinationViewController;
        destViewController.levelSelected = self.levelSelected;
        
    
}
@end
