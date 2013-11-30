//
//  Purpose: Implementation for class StatPageViewController
//
//  Application: iLearnLetters
//
//  Team: Flying Moose - Group 1
//
//  Revision history:
//
//  Date            Author                      Description
//  ---------------------------------------------------------------------------
//  2013-11-26      Anni Cao                    Original definition
//  2013-11-28      Anni Cao                    Added dynamic graph info
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Anni Cao. All rights reserved.
//

#import "StatPageViewController.h"
#import "AppDelegate.h"
#import "GameRecord.h"
#import "LineChartView.h"
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface StatPageViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *wallScroll;
@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;
@property NSMutableArray* statsInfo;
@property NSString* user;

@end

@implementation StatPageViewController

@synthesize managedObjectContext = _managedObjectContext;

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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    self.graphInfoLabel.text = @"";
    
    [self loadStats];
    [self drawGraph];
}

- (void)loadStats
{
    // Create a fetch request to retrieve stats from core data
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"GameRecord"
                inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    PFUser* user = [PFUser currentUser];
    if (user)
    {
        self.user = user.username;
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"user == %@", self.user];
        [request setPredicate:predicate];
    }
    
    // Sort by the date in ascending order
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    // Run the fetch request
    NSError* error;
    NSArray* records = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (records)
    {
        self.statsInfo = [records mutableCopy];
    }
    else
    {
        NSLog(@"Failed to load stats from core data");
    }
}

- (void)drawGraph
{
    if (!self.statsInfo)
        return;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (GameRecord* record in self.statsInfo)
    {
        float score = (float)record.correct / record.total;
        NSNumber* data = [NSNumber numberWithFloat:score];
        NSString *formattedDateString = [dateFormatter stringFromDate:record.date];
        NSString* dataText = [NSString stringWithFormat:@"Level: %@\nScore: %d out of %d\nDate: %@", record.level, record.correct, record.total, formattedDateString];        
        
        if ([record.level isEqualToString:@"easy"])
        {
            [self.lineChartView.data0 addObject:data];
            [self.lineChartView.text0 addObject:dataText];
        }
        else if ([record.level isEqualToString:@"hard"])
        {
            [self.lineChartView.data1 addObject:data];
            [self.lineChartView.text1 addObject:dataText];
        }
        else
        {
            [self.lineChartView.data2 addObject:data];
            [self.lineChartView.text2 addObject:dataText];
        }
    }
    
    self.lineChartView.color0 = [UIColor greenColor];
    self.lineChartView.color1 = [UIColor redColor];
    self.lineChartView.color2 = [UIColor yellowColor];
    
    self.lineChartView.dataLabel = self.graphInfoLabel;
}

- (IBAction)emailResults:(id)sender {
    [self.wallScroll setBackgroundColor:[UIColor clearColor]];
    
    [self.wallScroll setBackgroundColor:[UIColor clearColor]];
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"iLearnLetters Progress Report"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"", nil];
        [mailer setToRecipients:toRecipients];
        
        UIGraphicsBeginImageContextWithOptions(self.lineChartView.bounds.size, self.lineChartView.opaque, 0.0);
        
        [self.lineChartView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        
        NSData *imageData = UIImagePNGRepresentation(img);
        
        UIGraphicsEndImageContext();

        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"LineChart.png"];
        
        NSString *emailHeader = @"The following is the progress report of your child: \n\n";
        
        NSMutableString* emailBody = [NSMutableString new];
        [emailBody appendString:emailHeader];
        
        float sum = 0;
        int count = self.lineChartView.data0.count;
        if (count > 0)
        {
            for (int i = 0; i < count; i++)
            {
                sum+= [[self.lineChartView.data0 objectAtIndex:i] floatValue];
            }
            [emailBody appendString:[NSString stringWithFormat:@"He/she has taken %d easy level games with an average score of: %.1f%% (green line).\n", count, sum*100/count]];
        }
        
        sum = 0;
        count = self.lineChartView.data1.count;
        if (count > 0)
        {
            for (int i = 0; i < count; i++)
            {
                sum+= [[self.lineChartView.data1 objectAtIndex:i] floatValue];
            }
            [emailBody appendString:[NSString stringWithFormat:@"He/she has taken %d hard level games with an average score of: %.1f%% (red line).\n", count, sum*100/count]];
        }
        
        sum = 0;
        count = self.lineChartView.data2.count;
        if (count > 0)
        {
            for (int i = 0; i < count; i++)
            {
                sum+= [[self.lineChartView.data2 objectAtIndex:i] floatValue];
            }
            [emailBody appendString:[NSString stringWithFormat:@"He/she has taken %d hard level games with an average score of: %.1f%% (yellow line).\n", count, sum*100/count]];
        }
        
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:^{
            NSLog(@"mailer displayed");
        }];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Mailer Dismissed");
    }];
}

- (IBAction)clearHistoryPressed:(id)sender {
    
    UIAlertView *clearAlert = [[UIAlertView alloc] initWithTitle:@"Clear History Records" message:@"Are you sure you want to clear all history records?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [clearAlert show];
    
}

//This is the delegate method for UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Yes"])
    {
        [self clearHistory:self.user atLevel:@"easy"];
        [self clearHistory:self.user atLevel:@"hard"];
        [self clearHistory:self.user atLevel:@"custom"];
    }
}

- (void)clearHistory:(NSString*)user atLevel:(NSString*)level
{
    // Create a fetch request to retrieve stats from core data
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"GameRecord"
                inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(user == %@) AND (level == %@)", user, level];
    [request setPredicate:predicate];
    
    // Run the fetch request
    NSError* error;
    NSArray* records = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (records)
    {
        for (GameRecord* record in records)
        {
            [self.managedObjectContext deleteObject:record];
        }
    }
    else
    {
        NSLog(@"Failed to load stats from core data");
    }
    
    //Save context to remove the records
    if(![self.managedObjectContext save:&error]){
        //Handle Error
        NSLog(@"Problem saving stats info to core data");
    }
}

@end
