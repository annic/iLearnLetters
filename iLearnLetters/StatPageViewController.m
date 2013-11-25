//
//  StatPageViewController.m
//  iLearnLetters
//
//  Created by Rouzbeh Roshanravan on 2013-11-11.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import "StatPageViewController.h"
#import "pieChartView.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface StatPageViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet pieChartView *pieView;
@property (strong, nonatomic) IBOutlet UIScrollView *wallScroll;
@end

@implementation StatPageViewController

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
    [self drawGraph];
}

-(void)drawGraph{
    
    self.pieView.val1 = 0.8;
    self.pieView.val2 = 0.2;
        
}
- (IBAction)emailResults:(id)sender {
    [self.wallScroll setBackgroundColor:[UIColor clearColor]];
    
    [self.wallScroll setBackgroundColor:[UIColor clearColor]];
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Progress Report"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"", nil];
        [mailer setToRecipients:toRecipients];
        
       
        UIGraphicsBeginImageContextWithOptions(self.pieView.bounds.size, self.pieView.opaque, 0.0);
        
        
        [self.pieView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        
        NSData *imageData = UIImagePNGRepresentation(img);
        
        UIGraphicsEndImageContext();

        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"moleImage"];
        NSString *emailBody = @"The following is the progress report of your child";
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

@end
