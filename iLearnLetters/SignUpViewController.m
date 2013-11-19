//
//  SignUpViewController.m
//
//  Purpose: The definition of class SignUpViewController
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


#import "SignUpViewController.h"
#import "Reachability.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextBox;
@property (weak, nonatomic) IBOutlet UITextField *emailTextBox;
@property (strong, nonatomic) Reachability *internetReachableFoo;

@end

@implementation SignUpViewController

@synthesize internetReachableFoo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Show the navigation bar on signup page
    [self navigationController].navigationBarHidden = NO;
	
}

-(void)viewWillAppear:(BOOL)animated{
    
    // Show the navigation bar on signup page
    [self navigationController].navigationBarHidden = NO;
}


- (IBAction)registerPressed:(id)sender {
    [self testInternetConnection];
}

// This method adds a new user using PFUser object
-(void)signNewUserUp{
    
    //First we will create a PFUser Object
    PFUser *user = [PFUser user];
    
    //Now we set the username, password, and email for user object
    user.username = self.usernameTextBox.text;
    user.password = self.passwordTextBox.text;
    user.email = self.emailTextBox.text;
    
    
    //Now we push this to the background to sign the user up
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The user signup was successful
            
            NSLog(@"New user successfully created and added to the database");
            
            //Go to the main page
            
            [self performSegueWithIdentifier:@"mainPage" sender:self];
            
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            
            
            UIAlertView *errorAlertMsg = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [errorAlertMsg show];
            NSLog(@"%@", errorString);
        }
    }];
}


// Checks if we have an internet connection or not
- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
            
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
            
        });
    };
    
    if (internetReachableFoo.isReachable == 1) {
        [self signNewUserUp];
    }else{
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Internet Connection Failed" message:@"Please Check Your Internet Connection And Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [errorAlertView show];
    }
    
    [internetReachableFoo startNotifier];
}


@end
