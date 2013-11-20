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
//  2013-11-16      David Shiach                Added words being removed when new words
//                                              generated.
//  2013-11-19      David Shiach                Added Phonics popup.
//  2013-11-19      Anni Cao                    Merged with David's fix and re-applied the
//                                              fix for word counting.
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


@interface WordsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *randomWord;
@property ( nonatomic) int countOfCustomWords;
@property (nonatomic, strong) NSMutableArray *arrayOfWords;
@property  NSMutableArray *wordButtons;
@property NSMutableArray *phonicsView;
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
    
    if ([levelSelected isEqualToString:@"easy"]) {
        [self extractEasyWordsFromFile];
    }else if ([levelSelected isEqualToString:@"hard"]) {
        [self extractHardWordsFromFile];
    }else{
        [self extractCustomWordsFromFile];
    }
    
    self.google_TTS_BySham = [[Google_TTS_BySham alloc] init];
}

-(void)extractEasyWordsFromFile{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"easy" ofType:@"txt"];
    
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    NSArray *lineArray = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    
    for (int i = 0; i < [lineArray count]; i++)
    {
        [self.arrayOfWords addObject:[lineArray objectAtIndex:i]];
    }
    
    NSLog(@"Loaded %d EASY words", [self.arrayOfWords count]);
}


-(void)extractHardWordsFromFile{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"hard" ofType:@"txt"];
    
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    NSArray *lineArray = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    
    for (int i = 0; i < [lineArray count]; i++)
    {
        [self.arrayOfWords addObject:[lineArray objectAtIndex:i]];
    }
    
    NSLog(@"Loaded %d HARD words", [self.arrayOfWords count]);
}


-(void)extractCustomWordsFromFile{
    
    NSError *error = nil;
    
    
    NSFetchRequest *requestToGetList = [[NSFetchRequest alloc] init];
    NSEntityDescription *list = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:self.managedObjectContext];
    
    [requestToGetList setEntity:list];
    
    NSMutableArray *mutableFetchResultsList = [[self.managedObjectContext executeFetchRequest:requestToGetList error:&error] mutableCopy];
    
    //Seperate each word at white space and add it to an array
    NSArray *wordArray = [[[mutableFetchResultsList lastObject] wordString] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    self.arrayOfWords = [wordArray mutableCopy];
    
    
    NSLog(@"Loaded %d CUSTOM words", [wordArray count]);
}



-(NSString *)randomlyPickWord{
    
    int r = arc4random() % [self.arrayOfWords count];
    
    for (UIButton *button in _wordButtons) {
        [button removeFromSuperview];
    }
    [_wordButtons removeAllObjects];
    
    for (int i = 0; i < [[self.arrayOfWords objectAtIndex:r] length]; i++) {
        [self createButtonFront:i :[NSString stringWithFormat:@"%@", [[self.arrayOfWords objectAtIndex:r] substringWithRange:NSMakeRange(i, 1)]]];
        
    }
    
    return [self.arrayOfWords objectAtIndex:r];
}

- (IBAction)readTheWord:(id)sender {
    
    
    self.randomWord.text = [NSString stringWithFormat:@"%@", [self randomlyPickWord]];
    
    
    
    [self.google_TTS_BySham speak:[NSString stringWithFormat:@"%@", self.randomWord.text]];
    
}

-(void)createButtonFront:(int)whichLetter :(NSString *)letter{
    
    CGPoint pointToAddButton = CGPointMake((whichLetter + 5) * 70, yCo);
    
    UIButton *buttonToAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonToAdd setBackgroundColor:[UIColor cyanColor]];
    
    [buttonToAdd setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlStateNormal];
    
    buttonToAdd.frame = CGRectMake(pointToAddButton.x, pointToAddButton.y, 44.0f, 44.0f);
    
    //[buttonToAdd addTarget:self action:@selector(readTheChar:)
    //      forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
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
    
    CGPoint pointToAddButton = CGPointMake(950, 625);
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setBackgroundColor:[UIColor cyanColor]];
    [exitButton setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlStateNormal];
    exitButton.frame = CGRectMake(pointToAddButton.x, pointToAddButton.y, 44.0f, 44.0f);    
    [exitButton addTarget:self action:@selector(exitPhonics:)
          forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    [exitButton setTitle:@"Back" forState:(UIControlState)UIControlStateNormal];
    [_phonicsView addObject: exitButton];
    [self.view addSubview:exitButton];
    
}

-(IBAction)exitPhonics:(id)sender{

    for (UIButton *button in _phonicsView) {
        [button removeFromSuperview];
    }
    for (UIView *view in _phonicsView) {
        [view removeFromSuperview];
    }
    [_phonicsView removeAllObjects];
    
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
