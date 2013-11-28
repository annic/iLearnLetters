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
@property (weak, nonatomic) IBOutlet UILabel *randomWord;
@property ( nonatomic) int countOfCustomWords;
@property (nonatomic, strong) NSMutableArray *arrayOfWords;
@property  NSMutableArray *wordButtons;
@property NSMutableArray *phonicsView;
@property NSDictionary *phonemesToGraphemes;

@property int wordIndex;

@property (nonatomic,strong)Google_TTS_BySham *google_TTS_BySham;
@end

@implementation WordsViewController

@synthesize levelSelected;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize tempDrawImage, mainImage;

#define yCo 250

-(NSMutableArray *)arrayOfWords{
    if(!_arrayOfWords){
        _arrayOfWords = [[NSMutableArray alloc] init];
    }
    
    return _arrayOfWords;
}

- (void)viewDidLoad
{
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    _managedObjectContext = [appDelegate managedObjectContext];
    
    _wordButtons = [NSMutableArray array];
    _phonicsView = [NSMutableArray array];
    
    _phonemesToGraphemes = [WordsLoaderHelper createPhonicsDictionary];
    
    _wordIndex = 0;
    
    // Load the words from the dictionary of selected level
    [WordsLoaderHelper extractWordsFromFile:self.levelSelected
                                       data:self.arrayOfWords];
    
    if (self.arrayOfWords.count == 0)
    {
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

-(void)closeSettings:(id)sender
{
    
}

-(NSString *)randomlyPickWord{
    
    int r = self.wordIndex++ % [self.arrayOfWords count];
    NSString* word = [self.arrayOfWords objectAtIndex:r];
    
    for (UIButton *button in _wordButtons) {
        [button removeFromSuperview];
    }
    [_wordButtons removeAllObjects];
    
    for (int i = 0; i < [[self.arrayOfWords objectAtIndex:r] length]; i++) {
        [self createButtonFront:i :[NSString stringWithFormat:@"%@", [word substringWithRange:NSMakeRange(i, 1)]]];
        
    }
    
    return [self.arrayOfWords objectAtIndex:r];
}

- (IBAction)readTheWord:(id)sender
{
        
    self.randomWord.text = [NSString stringWithFormat:@"%@", [self randomlyPickWord]];
    
    [self.google_TTS_BySham speak:[NSString stringWithFormat:@"%@", self.randomWord.text]];
    
}

-(void)createButtonFront:(int)whichLetter :(NSString *)letter{
    
    CGPoint pointToAddButton = CGPointMake((whichLetter + 5) * 70, yCo);
    
    UIButton *buttonToAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonToAdd setBackgroundColor:[UIColor cyanColor]];
    
    [buttonToAdd setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlStateNormal];
    
    buttonToAdd.frame = CGRectMake(pointToAddButton.x, pointToAddButton.y, 44.0f, 44.0f);
    
    [buttonToAdd addTarget:self action:@selector(displayPhonics:)
          forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    [buttonToAdd setTitle:letter forState:(UIControlState)UIControlStateNormal];
    
    [_wordButtons addObject: buttonToAdd];
    
    [self.view addSubview:buttonToAdd];
    
}

-(IBAction)displayPhonics:(id)sender{
    
    // Create UIViews for phonics screen
    CGRect viewRect = CGRectMake(10, 10, 1000, 675);
    UIView* phonics = [[UIView alloc] initWithFrame:viewRect];
    [phonics setBackgroundColor:[UIColor whiteColor]];
    [_phonicsView addObject: phonics];
    [self.view addSubview:phonics];
    
    CGPoint pointToAddButton = CGPointMake(15, 15);
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setBackgroundColor:[UIColor cyanColor]];
    [exitButton setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlStateNormal];
    exitButton.frame = CGRectMake(pointToAddButton.x, pointToAddButton.y, 60.0f, 60.0f);
    [exitButton addTarget:self action:@selector(exitPhonics:)
         forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    exitButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    exitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    exitButton.titleLabel.numberOfLines = 0;
    [exitButton setTitle:@"Back to \nWord" forState:(UIControlState)UIControlStateNormal];
    [_phonicsView addObject: exitButton];
    [self.view addSubview:exitButton];
    
    // letter button
    [self createPhonicsButtonFront:-1 :[NSString stringWithFormat:@"%@", [sender titleLabel].text]];
    
    // phonics buttons
    int count = 0;
    for (NSString* currString in [_phonemesToGraphemes objectForKey:[NSString stringWithFormat:@"%@", [sender titleLabel].text]])
    {
        [self createPhonicsButtonFront:count:[NSString stringWithFormat:@"%@", currString]];
        count++;
    }
    
}

-(void)createPhonicsButtonFront:(int)whichButton :(NSString *)text{
    
    
    CGPoint pointToAddButton;
    if (whichButton < 0){
        pointToAddButton = CGPointMake(200, 300);
    } else {
        int x = ((floor(whichButton/3)) * 200 ) + 400;
        int y = ((whichButton % 3) * 200 ) + 100;
        pointToAddButton = CGPointMake(x, y);
    }
    
    UIButton *buttonToAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonToAdd setBackgroundColor:[UIColor cyanColor]];
    
    [buttonToAdd setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlStateNormal];
    
    buttonToAdd.frame = CGRectMake(pointToAddButton.x, pointToAddButton.y, 100.0f, 100.0f);
    
    [buttonToAdd addTarget:self action:@selector(readTheChar:)
          forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    buttonToAdd.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    buttonToAdd.titleLabel.textAlignment = NSTextAlignmentCenter;
    buttonToAdd.titleLabel.numberOfLines = 0;
    
    [buttonToAdd setTitle:text forState:(UIControlState)UIControlStateNormal];
    
    [_phonicsView addObject: buttonToAdd];
    
    [self.view addSubview:buttonToAdd];
    
}

-(IBAction)exitPhonics:(id)sender{

    for (UIButton *button in _phonicsView) {
        [button removeFromSuperview];
    }
    for (UIView *view in _phonicsView) {
        [view removeFromSuperview];
    }
    [_phonicsView removeAllObjects];
    
    //reset whiteboard
    self.tempDrawImage.image = nil;
    
}

-(IBAction)readTheChar:(id)sender{
    
    [self.google_TTS_BySham speak:[NSString stringWithFormat:@"%@", [sender titleLabel].text]];
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

@end
