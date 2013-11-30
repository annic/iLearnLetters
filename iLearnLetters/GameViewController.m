//
//  GameViewController.m
//  iLearnLetters
//
//  Created by Anni Cao on 2013-11-19.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import "GameViewController.h"
#import "WordsLoaderHelper.h"
#import "AppDelegate.h"
#import "GameRecord.h"
#import "Word.h"
#import <Parse/Parse.h>

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
@property BOOL chooseFirstLetter;
@property UIColor* ctlBtnDefaultColor;

@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLastLabel;

@end

@implementation GameViewController

@synthesize managedObjectContext = _managedObjectContext;

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
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    self.gameStarted = NO;
    self.currentNumQuesion = 0;
    self.correctAnswers = 0;    
    self.totalNumQuestions = 10;
    
    // Load the words from the dictionary of selected level
    [WordsLoaderHelper extractWordsFromFile:self.levelSelected
                                       data:self.arrayOfWords];
    
    if (self.arrayOfWords.count == 0)
    {
        [self.controlButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        self.controlButton.enabled = NO;
        NSString* message = [NSString stringWithFormat:@"Please add words to the dictionary of level '%@' first!", self.levelSelected];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:message
                                                  delegate:self
                                                  cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
    
    if (self.totalNumQuestions > self.arrayOfWords.count)
    {
        self.totalNumQuestions = self.arrayOfWords.count;
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
    
    self.questionLabel.text = @"Ready to play a game?";
    self.firstLastLabel.text = @"";
    self.statusLabel.text = @"";
    self.wordLabel.text = @"";
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

- (void)showNextQuestion
{
    // Randomly pick a word and create a question
    self.currentWord = [self.arrayOfWords objectAtIndex:self.currentNumQuesion];
    
    // Choose the first or last letter - 50% chance for each
    // Set the question string label accordingly
    self.chooseFirstLetter = [self.levelSelected isEqualToString:@"easy"] ||(arc4random_uniform(100) % 2 == 0);
    
    NSString* firstLast = nil;
    unichar ch;
    if (self.chooseFirstLetter)
    {
        firstLast = @"first";
        ch = [self.currentWord characterAtIndex:0];
    }
    else
    {
        firstLast = @"last";
        ch = [self.currentWord characterAtIndex:self.currentWord.length - 1];
    }
    
    self.currentAnswer = [NSString stringWithFormat:@"%C", ch];
    
    self.answered = NO;
    
    self.questionLabel.text = @"What's the         letter of the word you hear?";
    
    self.firstLastLabel.text = firstLast;
    
    // Display four choices using buttons
    [self showChoices:4 include:self.currentAnswer];

    self.statusLabel.text = @"";

    self.wordLabel.text = @"";
    
    self.speakButton.hidden = NO;
    
    self.ctlBtnDefaultColor = [self.controlButton titleColorForState:UIControlStateNormal];
    
    [self.controlButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.controlButton.enabled = NO;
    
    self.currentNumQuesion++;
    
    self.progressBar.progress = (float)self.currentNumQuesion / self.totalNumQuestions;
    
    if (self.currentNumQuesion == self.totalNumQuestions)
    {
        [self.controlButton setTitle:@"Result" forState:UIControlStateNormal];
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
    
    // Shuffle the choices
    [choiceSet shuffle];
    
    // Clear the word buttons from pervious run
    [self.wordButtons removeAllObjects];
    
    // Draw the letters in choice set as buttons on the screen
    for (int i = 0; i < choiceSet.count; ++i)
    {
        [self createButtonFront:i :[choiceSet objectAtIndex:i]];
    }
}

-(void)createButtonFront:(int)whichLetter :(NSString*)letter{
    
    CGPoint pointToAddButton = CGPointMake(300 + whichLetter * 120, 250);
    
    UIButton *buttonToAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonToAdd setBackgroundColor:[UIColor cyanColor]];
    
    [buttonToAdd setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlStateNormal];
    buttonToAdd.titleLabel.font = [UIFont systemFontOfSize:40];
    
    buttonToAdd.frame = CGRectMake(pointToAddButton.x, pointToAddButton.y, 70.0f, 70.0f);
    
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
        output = [NSString stringWithFormat:@"Sorry, it's not correct. The word is:"];
        self.wordLabel.text = self.currentWord;
    }
    
    // Highlight the correct answer (button) with different color
    for (UIButton* choiceButton in self.wordButtons)
    {
        if ([choiceButton.currentTitle isEqualToString:self.currentAnswer])
        {
            [choiceButton setBackgroundColor:[UIColor yellowColor]];
        }
    }
    
    self.statusLabel.text = output;
    
    [self.controlButton setTitleColor:self.ctlBtnDefaultColor forState:UIControlStateNormal];
    
    self.controlButton.enabled = YES;
    self.answered = YES;
    
    // If the user has answed the last question, save the result
    // for the stats page
    if (self.currentNumQuesion == self.totalNumQuestions)
    {
        [self saveStats];
    }
}

- (void)saveStats
{
    GameRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"GameRecord"
                                            inManagedObjectContext:self.managedObjectContext];
    PFUser* user = [PFUser currentUser];
    if (user)
    {
        record.user = user.username;
    }
    record.level = self.levelSelected;
    record.correct = self.correctAnswers;
    record.total = self.totalNumQuestions;
    record.date = [NSDate date];
    
    NSError *error = nil;
    
    //Save objects
    if(![_managedObjectContext save:&error]){
        //Handle Error
        NSLog(@"Problem saving stats info to core data");
    }

    
}

@end
