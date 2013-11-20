//
//  LoginViewController.m
//
//  Purpose: The definition of class LoginViewController
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
//  2013-11-19      David Shiach                Updated password entry for secure
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//


#import "LoginViewController.h"
#import "Reachability.h"
#import <Parse/Parse.h>


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextBox;
@property (strong, nonatomic) Reachability *internetReachable;

@end

@implementation LoginViewController

@synthesize internetReachable;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide the navigation bar on login page
    [self navigationController].navigationBarHidden = YES;
    
    // Password entry secure
    [self passwordTextBox].secureTextEntry = YES;
    
	// Check and see if the user is already online
    // If so directly send user to the main page
    if ([[PFUser currentUser] isAuthenticated]) {
        [self performSegueWithIdentifier:@"mainPage" sender:self];
        NSLog(@"User is allready logged in");
    
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    //If page appears again hide the navigation bar
    //This method is called once the user logs out
    [self navigationController].navigationBarHidden = YES;
}

- (IBAction)loginPressed:(id)sender {
    
    // Check for internet connection
    [self testInternetConnection];
}

// This method logs in the user using PFUser object
-(void)logInUser{

    [PFUser logInWithUsernameInBackground:self.userNameTextBox.text password:self.passwordTextBox.text block:^(PFUser *user, NSError *error) {
        if(user){
            //If password matches user will be directed to the main page
            //Go to the main page
            [self performSegueWithIdentifier:@"mainPage" sender:self];
        }else{
            NSString *errorString =[[error userInfo] objectForKey:@"error"];
            
            if([errorString rangeOfString:@"Internet"].location != NSNotFound){
                errorString = @"The Internet connection appears to be offline.";
            }
            
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [errorAlertView show];
        }
    }];
}

- (IBAction)signUpPressed:(id)sender {
    
    //If user clicks on signup button
    //Transfer to signup page
    [self performSegueWithIdentifier:@"signup" sender:self];

}

// Checks if we have an internet connection or not
- (void)testInternetConnection
{
    internetReachable = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachable.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have internet connection!");
            
        });
    };
    
    // Internet is not reachable
    internetReachable.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
            
        });
    };
    
    if (internetReachable.isReachable == 1) {
        [self logInUser];
    }else{
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Internet Connection Failed" message:@"Please Check Your Internet Connection And Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [errorAlertView show];
    }
    
    [internetReachable startNotifier];
}
@end
