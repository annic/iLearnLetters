//
//  GameViewController.m
//  iLearnLetters
//
//  Created by Zheng Wang on 2013-11-19.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import "GameViewController.h"
#include "WordsLoaderHelper.h"
#import "Google_TTS_BySham.h"

@interface GameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) NSMutableArray *arrayOfWords;
@property NSMutableArray *wordButtons;
@property NSMutableArray *alphabetArray;
@property (nonatomic,strong) Google_TTS_BySham *google_TTS_BySham;

@property BOOL gameStarted;
@property int totalNumQuestions;
@property int currentNumQuesion;
@property int correctAnswers;
@property NSString* currentWord;
@property NSString* currentAnswer;
@property BOOL answered;
@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;

@end

@implementation GameViewController
@synthesize statusLabel;
@synthesize nextButton;
@synthesize nextLable;
-(NSMutableArray *)arrayOfWords{
    if(!_arrayOfWords){
        _arrayOfWords = [[NSMutableArray alloc] init];
    }
    
    return _arrayOfWords;
}

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
    
    UIColor * backgroundColor = [UIColor colorWithRed:211/255.0f green:227/255.0f blue:237/255.0f alpha:0.0f];
    [_controlButton setBackgroundColor: backgroundColor];

    [super viewDidLoad];
    self.gameStarted = NO;
    self.currentNumQuesion = 0;
    self.correctAnswers = 0;    
    self.totalNumQuestions = 10;
    nextLable.hidden = TRUE;
    nextButton.hidden = TRUE;
    // Load the words from the dictionary of selected level
    [WordsLoaderHelper extractWordsFromFile:self.levelSelected
                                       data:self.arrayOfWords];
    
    if (self.arrayOfWords.count == 0)
    {
        self.controlButton.alpha = 0.4;
        self.controlButton.enabled = NO;
        NSString* message = [NSString stringWithFormat:@"Please add words to the dictionary of level '%@' first!", self.levelSelected];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:message
                                                  delegate:self
                                                  cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
    
    // Shuffle the words
    [self.arrayOfWords shuffle];
    
    // Define an alphabet array for the set of letter choices
    NSString* alphabet = @"a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z";
    NSArray* list = [alphabet componentsSeparatedByString:@","];
    self.alphabetArray = [[NSMutableArray alloc] init];
    for (NSString* str in list)
    {
        [self.alphabetArray addObject:str];
    }
    
    self.wordButtons = [[NSMutableArray alloc] init];
    
    self.google_TTS_BySham = [[Google_TTS_BySham alloc] init];
    
    [self.controlButton setTitle:@"Start" forState:UIControlStateNormal];
    
    self.statusLabel.text = @"";
    self.speakButton.hidden = YES;
    self.progressBar.progress = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)controlButtonPressed:(id)sender
{
    if (!self.gameStarted)
    {
        // Change button to 'Next'
        self.gameStarted = YES;
        [self.controlButton setTitle:@"Next" forState:UIControlStateNormal];
        _controlButton.hidden = TRUE;
        _startLable.hidden = TRUE;
        nextButton.hidden = FALSE;
        nextLable.hidden = FALSE;
    }
    // Show the next question
    
    if (self.currentNumQuesion < self.totalNumQuestions)
    {
        [self showNextQuestion];
    }
    else
    {
        [self showResult];
    }
}
- (IBAction)nextButtonPressed:(id)sender {
    // Show the next question
    
    if (self.currentNumQuesion < self.totalNumQuestions)
    {
        [self showNextQuestion];
    }
    else
    {
        [self showResult];
    }
}

- (void)showNextQuestion
{
    // Randomly pick a word and create a question
    self.currentWord = [self.arrayOfWords objectAtIndex:self.currentNumQuesion];
    
    // Choose the first or last letter - 50% chance for each
    // Set the question string label accordingly
    BOOL chooseFirstLetter = [self.levelSelected isEqualToString:@"easy"] ||(arc4random_uniform(100) % 2 == 0);
    NSString* questionString = nil;
    unichar ch;
    if (chooseFirstLetter)
    {
        questionString = @"What's the first letter of the word you hear?";
        ch = [self.currentWord characterAtIndex:0];
    }
    else
    {
        questionString = @"What's the last letter of the word you hear?";
        ch = [self.currentWord characterAtIndex:self.currentWord.length - 1];
    }
    
    self.currentAnswer = [NSString stringWithFormat:@"%C", ch];
    
    self.answered = NO;
    
    self.questionLabel.text = questionString;
    
    // Display four choices using buttons
    [self showChoices:4 include:self.currentAnswer];
    
    self.statusLabel.text = @"";
    
    self.speakButton.hidden = NO;
    
    self.nextButton.alpha = 0.6;
    self.nextButton.enabled = NO;
    
    self.currentNumQuesion++;
    
    self.progressBar.progress = (float)self.currentNumQuesion / self.totalNumQuestions;
    
    if (self.currentNumQuesion == self.totalNumQuestions)
    {
        [self.nextButton setTitle:@"Result" forState:UIControlStateNormal];
    }
    
    // Play the sound of the current word
    [self.google_TTS_BySham speak:self.currentWord];
    
    NSLog(@"Selected word is: %@, the first/last letter is: %@", self.currentWord, self.currentAnswer);
    
    NSLog(@"Current question: %d out of %d",
          self.currentNumQuesion,
          self.totalNumQuestions);
    
}

- (void)showChoices:(int)count include:(NSString*)letter
{
    // Randomly choose given number of letters from the alphabet including
    // the correct answer
    [self.alphabetArray shuffle];
    
    NSMutableArray* choiceSet = [[NSMutableArray alloc] init];
    [choiceSet addObject:letter];
    count--;
    int i = 0;
    while (count > 0)
    {
        NSString* ch = [self.alphabetArray objectAtIndex:i++];
        if (![ch isEqualToString:letter])
        {
            [choiceSet addObject:ch];
            count --;
        }
    }
    
    [choiceSet shuffle];
    
    // Draw the letters in choice set as buttons on the screen
    for (int i = 0; i < choiceSet.count; ++i)
    {
        [self createButtonFront:i :[choiceSet objectAtIndex:i]];
    }
}

-(void)createButtonFront:(int)whichLetter :(NSString*)letter{
    
    CGPoint pointToAddButton = CGPointMake(250 + whichLetter * 150, 250);
    
    UIButton *buttonToAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIColor * backgroundColor = [UIColor colorWithRed:211/255.0f green:227/255.0f blue:237/255.0f alpha:1.0f];
    [buttonToAdd setBackgroundColor: backgroundColor];
    
    NSInteger r = (arc4random() % (255 - 87)) + 87;
    NSInteger g = (arc4random() % (255 - 87)) + 87;
    NSInteger b = (arc4random() % (255 - 87)) + 87;
    
    UIColor * textColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
    [buttonToAdd setTitleColor:textColor forState: UIControlStateNormal];
    //[buttonToAdd setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlStateNormal];
    buttonToAdd.titleLabel.font = [UIFont boldSystemFontOfSize:76];
    
    buttonToAdd.frame = CGRectMake(pointToAddButton.x, pointToAddButton.y, 100.0f, 100.0f);
    
    [buttonToAdd addTarget:self action:@selector(verifyAnswer:)
          forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    [buttonToAdd setTitle:letter forState:(UIControlState)UIControlStateNormal];
    
    [self.wordButtons addObject: buttonToAdd];
    
    [self.view addSubview:buttonToAdd];
    
    
}

- (IBAction)speakButtonPressed:(id)sender
{
    // Read the word
    if (self.currentWord)
    {
        [self.google_TTS_BySham speak:self.currentWord];
    }
}

- (void)showResult
{
    NSString* message = [NSString stringWithFormat:@"You anwsered %d quesions correctly out of %d.", self.correctAnswers, self.totalNumQuestions];
    UIAlertView *resultView = [[UIAlertView alloc] initWithTitle:@"Result"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Close", nil];
    [resultView show];
}

- (IBAction)verifyAnswer:(id)sender
{
    if (self.answered)
        return;
    
    // Check if answer is correct
    NSString* output = nil;
    UIButton* button = sender;
    if ([button.currentTitle isEqualToString:self.currentAnswer])
    {
        output = @"Correct!";
        self.correctAnswers++;
    }
    else
    {
        output = [NSString stringWithFormat:@"Sorry, that's not correct. The word is %@."  ,self.currentWord];
    }
    self.statusLabel.text = output;
    self.nextButton.alpha = 1.0;
    self.nextButton.enabled = YES;
    self.answered = YES;
}

@end
