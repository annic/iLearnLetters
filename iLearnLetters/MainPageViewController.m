//
//  MainPageViewController.m
//
//  Purpose: The definition of class MainPageViewController
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


#import "MainPageViewController.h"
#import <Parse/Parse.h>
#import "UIView+Animation.h"
// #import "LearnLevelSelect.h"
#import "levelSelectViewController.h"

@interface MainPageViewController () <UIAlertViewDelegate>
@property NSString* mode;
@end

@implementation MainPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    // Show the navigation bar on the main page
    [self navigationController].navigationBarHidden = NO;
    
    // Hide the back button
    self.navigationItem.hidesBackButton = YES;
    
    
    self.usernameLabel.text = [self showUserName];
    
}

-(NSString *)showUserName{
    PFUser *current = [PFUser currentUser];
    
    return [NSString stringWithFormat:@"%@!", current.username];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Show the navigation bar
    [self navigationController].navigationBarHidden = NO;
}

- (IBAction)parentsTeacherPressed:(id)sender {
    
    //Check for password parents
    self.mode = @"parentTeacher";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    
    
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alertView show];
}


- (IBAction)logoutPressed:(id)sender {

    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Log Out?" message:@"Are you sure you want to out of iLearnLetters?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [logoutAlert show];
    
}

//This is the delegate method for UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    // Check to see which button was clicked on 
	if([title isEqualToString:@"OK"])
	{
        
		UITextField *username = [alertView textFieldAtIndex:0];
		UITextField *password = [alertView textFieldAtIndex:1];
		
        [PFUser logInWithUsernameInBackground:username.text password:password.text block:^(PFUser *user, NSError *error) {
            if(user){
                //Go to the main page
                [self performSegueWithIdentifier:@"parentsTeacher" sender:self];
            }else{
                NSString *errorString =[[error userInfo] objectForKey:@"error"];
                
                if([errorString rangeOfString:@"Internet"].location != NSNotFound){
                    errorString = @"The Internet connection appears to be offline.";
                }
                
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [errorAlertView show];
            }
        }];

        
	}else{
        
      if (buttonIndex == 1) {
          
          [PFUser logOut];
          [self.navigationController popToRootViewControllerAnimated:YES];
      }
        
    }
}

- (IBAction)learnPressed:(id)sender
{
    
    //Create a new levelSelect UIView
//    LearnLevelSelect *levelSelect = [LearnLevelSelect levelSelect];
//    
//    //Set its location to the center of the page
//    levelSelect.center = self.view.center;
//    
//    //Add that view to main view 
//    [self.view addSubviewWithZoomInAnimation:levelSelect duration:1.0];
//    
//    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{} completion:nil];
    self.mode = @"learn";
}

- (IBAction)gamePressed:(id)sender
{
    self.mode = @"game";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![self.mode isEqualToString:@"parentTeacher"])
    {
        levelSelectViewController* destViewController = segue.destinationViewController;
        destViewController.mode = self.mode;
    }
}

@end
