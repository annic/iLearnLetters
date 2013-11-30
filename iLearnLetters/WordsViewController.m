//
//  WordsViewController.m
//
//  Purpose: The definition of class WordViewController
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
//  2013-11-16      David Shiach                Added words being removed when new
//                                              words generated.
//  2013-11-19      David Shiach                Added Phonics popup.
//  2013-11-19      Anni Cao                    Merged with David's fix and re-applied
//                                              the fix for word counting.
//  2013-11-26      David Shiach                Added Phonics for all letters.
//  2013-11-28      Anni Cao                    Use word loader from WordLoaderHelper
//                                              for all levels
//  2013-11-28      Anni Cao                    Moved the phonics dictionary creation
//                                              to the WordLoaderHelper class
//  2013-11-29      Anni Cao                    Changed phonics to popover table view
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.


#import "WordsViewController.h"
#import "Google_TTS_BySham.h"
#import <stdlib.h>
#import "AppDelegate.h"
#import "List.h"
#import "Word.h"
#import "WordsLoaderHelper.h"

@interface WordsViewController ()

@property (nonatomic) int countOfCustomWords;
@property (nonatomic, strong) NSMutableArray *arrayOfWords;
@property NSMutableArray *wordButtons;
@property NSMutableArray *phonicsView;
@property NSDictionary *phonemesToGraphemes;

@property NSString* currentWord;
@property int wordArrayIndex;
@property (nonatomic, strong) PhonicsViewController *phonicsViewController;
@property (nonatomic, strong) UIPopoverController *phonicsPopover;
@property (weak, nonatomic) IBOutlet UIButton *wordButton;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;

@property (nonatomic,strong)Google_TTS_BySham *google_TTS_BySham;

@end

@implementation WordsViewController

@synthesize levelSelected;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize tempDrawImage, mainImage;


-(NSMutableArray *)arrayOfWords{
    if(!_arrayOfWords){
        _arrayOfWords = [[NSMutableArray alloc] init];
    }
    
    return _arrayOfWords;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    _managedObjectContext = [appDelegate managedObjectContext];
    
    _wordButtons = [NSMutableArray array];
    _phonicsView = [NSMutableArray array];
    
    _phonemesToGraphemes = [WordsLoaderHelper createPhonicsDictionary];
    
    _wordArrayIndex = 0;
    
    // Load the words from the dictionary of selected level
    [WordsLoaderHelper extractWordsFromFile:self.levelSelected
                                       data:self.arrayOfWords];
    
    if (self.arrayOfWords.count == 0)
    {
        self.wordButton.enabled = NO;
        self.repeatButton.enabled = NO;
        NSString* message = [NSString stringWithFormat:@"Please add words to the dictionary of level '%@' first!", self.levelSelected];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
    
    // Shuffle the words
    [self.arrayOfWords shuffle];
    
    self.google_TTS_BySham = [[Google_TTS_BySham alloc] init];
}

- (IBAction)randomlyPickWord:(id)sender
{
    int r = self.wordArrayIndex++ % [self.arrayOfWords count];
    self.currentWord = [self.arrayOfWords objectAtIndex:r];
    
    for (UIButton *button in _wordButtons) {
        [button removeFromSuperview];
    }
    [_wordButtons removeAllObjects];
    
    for (int i = 0; i < [self.currentWord length]; i++)
    {
        [self createButtonFront:i :[self.currentWord substringWithRange:NSMakeRange(i, 1)]];
    }
    
    // Read the word
    [self.google_TTS_BySham speak:self.currentWord];
}

- (IBAction)readTheWord:(id)sender
{
    [self.google_TTS_BySham speak:self.currentWord];
}

-(void)createButtonFront:(int)whichLetter :(NSString *)letter
{
    // Compute the location where the first letter should begin
    CGFloat width = self.view.frame.size.width;
    int count = [self.currentWord length];
    int xoffset = (width - count * 80) / 2;
    const int yoffset = 250;
    
    CGPoint pointToAddButton = CGPointMake(xoffset + whichLetter * 80, yoffset);
    
    UIButton *buttonToAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonToAdd setBackgroundColor:[UIColor cyanColor]];
    
    [buttonToAdd setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlStateNormal];
    
    buttonToAdd.titleLabel.font = [UIFont systemFontOfSize:40];
    
    buttonToAdd.frame = CGRectMake(pointToAddButton.x, pointToAddButton.y, 70.0f, 70.0f);
    
    [buttonToAdd addTarget:self action:@selector(displayPhonics:)
          forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    [buttonToAdd setTitle:letter forState:(UIControlState)UIControlStateNormal];
    
    [_wordButtons addObject: buttonToAdd];
    
    [self.view addSubview:buttonToAdd];
    
}

-(IBAction)displayPhonics:(id)sender
{
    UIButton* letterButton = sender;
    [self selectedPhonics:letterButton.titleLabel.text];
    
    NSArray* phonicsNames = [_phonemesToGraphemes objectForKey:letterButton.titleLabel.text];
    
    //Create the PhonicsViewController.
    _phonicsViewController = [[PhonicsViewController alloc] initWithStyle:UITableViewStylePlain data:phonicsNames];
    
    //Set this VC as the delegate.
    _phonicsViewController.delegate = self;
    
    // If the phonics popover is already shown, hide it
    if (_phonicsPopover)
    {
        [_phonicsPopover dismissPopoverAnimated:YES];
    }
    
    //Show the phonics popover
    _phonicsPopover = [[UIPopoverController alloc] initWithContentViewController:_phonicsViewController];
    
    [_phonicsPopover presentPopoverFromRect:letterButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
 }

- (void)viewDidUnload
{
    [self setMainImage:nil];
    [self setTempDrawImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)reset:(id)sender {
    
    self.tempDrawImage.image = nil;
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        
        UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 0.0);
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
        UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (IBAction)saveButtonPressed:(id)sender
{
    UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 0.0);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photo album"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.tempDrawImage];
    NSLog(@"Touch began at: %f, %f", lastPoint.x, lastPoint.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGFloat brush = 10.0;
    CGFloat opacity = 1.0;

    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.tempDrawImage];
    
    UIGraphicsBeginImageContext(self.tempDrawImage.frame.size);

    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

-(void)selectedPhonics:(NSString *)phonicsName
{
    // Read the word
    [self.google_TTS_BySham speak:phonicsName];
}

@end
