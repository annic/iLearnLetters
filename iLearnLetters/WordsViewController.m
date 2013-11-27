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
//  2013-11-26      David Shiach                Added Phonics for all letters.
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

@property NSDictionary *phonemesToGraphemes;
@property NSArray *phonemes;
@property NSArray *graphemesArrays;

@property NSArray *aGraphemes;
@property NSArray *eGraphemes;
@property NSArray *iGraphemes;
@property NSArray *oGraphemes;
@property NSArray *uGraphemes;

@property NSArray *bGraphemes;
@property NSArray *cGraphemes;
@property NSArray *dGraphemes;
@property NSArray *fGraphemes;
@property NSArray *gGraphemes;
@property NSArray *hGraphemes;
@property NSArray *jGraphemes;
@property NSArray *kGraphemes;
@property NSArray *lGraphemes;
@property NSArray *mGraphemes;
@property NSArray *nGraphemes;
@property NSArray *pGraphemes;
@property NSArray *qGraphemes;
@property NSArray *rGraphemes;
@property NSArray *sGraphemes;
@property NSArray *tGraphemes;
@property NSArray *vGraphemes;
@property NSArray *wGraphemes;
@property NSArray *xGraphemes;
@property NSArray *yGraphemes;
@property NSArray *zGraphemes;

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
    
    _phonemes = [NSArray arrayWithObjects: @"a",@"e",@"i",@"o",@"u",@"b",@"c",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"m",@"n",@"p",@"q",@"r",@"s",@"t",@"v",@"w",@"x",@"y",@"z", nil];
    
    // all letters. Graphemes associated wit those letter. Max 9 graphemes per word.
    _aGraphemes = [NSArray arrayWithObjects: @"a, as in \nhat",@"a, as in \nlaugh",@"a, as in \nbacon",@"a, as in \nlate",@"a, as in \nday",@"a, as in \ntrain",@"a, as in \nbread",@"a, as in \nwant", @"a, as in \ndraw", nil];
    _eGraphemes = [NSArray arrayWithObjects: @"e as in \nbed",@"e as in \nfew",@"e as in \neight",@"e as in \npie",@"e as in \nme",@"e as in \nthese",@"e as in \nbeat",@"e as in \nfeet", @"e as in \nkey", nil];
    _iGraphemes = [NSArray arrayWithObjects: @"i as in \nfind",@"i as in \nride",@"i as in \nlight",@"i as in \npie",@"i as in \nif",@"i as in \ntrain",@"i as in \neight",@"i as in \nvein", nil];
    _oGraphemes = [NSArray arrayWithObjects: @"o as in \nhot",@"o as in \nton",@"o as in \nbought",@"o as in \nno",@"o as in \nnote",@"o as in \nboat",@"o as in \nsoul",@"o as in \nrow", nil];
    _uGraphemes = [NSArray arrayWithObjects: @"u as in \nup",@"u as in \nhaul",@"u as in \nbought",@"u as in \nhuman",@"u as in \nuse",@"u as in \nsoul", nil];
    
    _bGraphemes = [NSArray arrayWithObjects: @"b as in \nbig", @"b as in \nrubber", nil];
    _cGraphemes = [NSArray arrayWithObjects: @"c as in \ncat", @"c as in \nschool", @"c as in \noccur", @"c as in \ncity", @"c as in \nice",@"c as in \noscience",@"c as in \nchef",@"c as in \nchip", nil];
    _dGraphemes = [NSArray arrayWithObjects: @"d as in \ndog", @"d as in \nadd", @"d as in \nfilled", @"d as in \njudge" ,nil];
    _fGraphemes = [NSArray arrayWithObjects: @"f, as in \nfish", nil];
    _gGraphemes = [NSArray arrayWithObjects: @"g as in \ngo", @"g as in \negg", @"g as in \ncage",@"g as in \nbarge", @"g as in \njudge",@"g as in \ngnome",@"g as in \nsing",  nil];
    _hGraphemes = [NSArray arrayWithObjects: @"h as in \nhot",@"h as in \nschool",@"h as in \nphone", @"h as in \nthumb", @"h as in \nfeather",@"h as in \nship", nil];
    _jGraphemes = [NSArray arrayWithObjects: @"j as in \njet", nil];
    _kGraphemes = [NSArray arrayWithObjects: @"k as in \nkitten", @"k as in \nduck", @"k as in \nknee" , nil];
    _lGraphemes = [NSArray arrayWithObjects: @"l as in \nleg", @"l as in \nbell", nil];
    _mGraphemes = [NSArray arrayWithObjects: @"m as in \nmad", @"m as in \nhammer", @"m as in \nlamb", nil];
    _nGraphemes = [NSArray arrayWithObjects: @"n as in \nno", @"n as in \ndinner", @"n as in \nknee",@"n as in \ngnome",@"n as in \nsing",@"s as in \nmeasure", nil];
    _pGraphemes = [NSArray arrayWithObjects: @"p as in \npie", @"p as in \napple", nil];
    _qGraphemes = [NSArray arrayWithObjects: @"q as in \nantique", @"q as in \nqueue", nil];
    _rGraphemes = [NSArray arrayWithObjects: @"r as in \nrun", @"r as in \nmarry", @"r as in \nwrite", nil];
    _sGraphemes = [NSArray arrayWithObjects: @"s as in \nsun", @"s as in \nmouse", @"s as in \ndress",@"s as in \nscience",@"s as in \nmission", nil];
    _tGraphemes = [NSArray arrayWithObjects: @"t as in \ntop", @"t as in \nletter", @"t as in \nthumb", @"t as in \nfeather",@"t as in \nmotion",@"t as in \nmatch", nil];
    _vGraphemes = [NSArray arrayWithObjects: @"v as in \nvet", @"v as in \ngive", nil];
    _wGraphemes = [NSArray arrayWithObjects: @"w as in \nwet", @"w as in \nswim",@"w as in \nwhat", nil];
    _xGraphemes = [NSArray arrayWithObjects: @"x as in \nxylophone", nil];
    _yGraphemes = [NSArray arrayWithObjects: @"y as in \nyes", nil];
    _zGraphemes = [NSArray arrayWithObjects: @"z as in \nzip", @"z as in \nfizz", @"z as in \nsneeze", nil];
    
    _graphemesArrays = [NSArray arrayWithObjects: _aGraphemes, _eGraphemes, _iGraphemes, _oGraphemes, _uGraphemes, _bGraphemes, _cGraphemes, _dGraphemes, _fGraphemes, _gGraphemes, _hGraphemes, _jGraphemes, _kGraphemes, _lGraphemes, _mGraphemes, _nGraphemes,  _pGraphemes, _qGraphemes, _rGraphemes,  _sGraphemes, _tGraphemes, _vGraphemes, _wGraphemes, _xGraphemes, _yGraphemes, _zGraphemes, nil];
    _phonemesToGraphemes = [[NSDictionary alloc] initWithObjects: _graphemesArrays forKeys: _phonemes];
    
    if ([levelSelected isEqualToString:@"easy"]) {
        [self extractEasyWordsFromFile];
    }else if ([levelSelected isEqualToString:@"hard"]) {
        [self extractHardWordsFromFile];
    }else{
        [self extractCustomWordsFromFile];
    }
    
    self.google_TTS_BySham = [[Google_TTS_BySham alloc] init];
}

-(void)closeSettings:(id)sender
{
    
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
