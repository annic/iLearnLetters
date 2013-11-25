//
//  ParentsTeacherPageViewController.m
//
//  Purpose: The definition of class ParentsTeacherPageViewController
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

#import "ParentsTeacherPageViewController.h"
#import "Google_TTS_BySham.h"
#import <stdlib.h>
#import "AppDelegate.h"
#import "List.h"
#import "Word.h"

@interface ParentsTeacherPageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *testWords;
@property (weak, nonatomic) IBOutlet UITextView *wordList;
@property (weak, nonatomic) IBOutlet UITextView *currentList;
@property (nonatomic,strong)Google_TTS_BySham *google_TTS_BySham;


@end

@implementation ParentsTeacherPageViewController


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (void)viewDidLoad
{
    
    UIColor * backgroundColor = [UIColor colorWithRed:211/255.0f green:227/255.0f blue:237/255.0f alpha:0.0f];
    [addWordsButton setBackgroundColor: backgroundColor];

    [super viewDidLoad];
    
    [self navigationController].navigationBarHidden = NO;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    _managedObjectContext = [appDelegate managedObjectContext];
    
	// Do any additional setup after loading the view.
    self.google_TTS_BySham = [[Google_TTS_BySham alloc] init];
    
    [self displayCurrentList];
    
}

// This method plays sound of the word in text box
- (IBAction)testButton:(id)sender {
    
    //To test how a word sounds we use an instance of google text to speach object
    [self.google_TTS_BySham speak:[NSString stringWithFormat:@"%@", self.testWords.text]];
}


// This method updates the list view with the words added by user
- (IBAction)saveButton:(id)sender {
    
    //First clean previous data stored
    [self cleanData];
    
    List *list = [self createNewlist];
    
    NSArray *wordsToBeAdded = [self addWordsToList:[self getWordsFromUserList] :list];
    
    [self updateListView:wordsToBeAdded];
    
    self.updateTimeLabel.text = [self getListTimeStamp];
}

// This method sorts the words list
-(int)cleanData{
    NSError *error = nil;
    
    NSFetchRequest *requestToGetList = [[NSFetchRequest alloc] init];
    NSEntityDescription *list = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:self.managedObjectContext];
    
    [requestToGetList setEntity:list];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wordString" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [requestToGetList setSortDescriptors:sortDescriptors];
    
    NSMutableArray *mutableFetchResultsList = [[self.managedObjectContext executeFetchRequest:requestToGetList error:&error] mutableCopy];
    
    for (NSManagedObject *managedObject in mutableFetchResultsList) {
        [self.managedObjectContext  deleteObject:managedObject];
    }
    
    return [mutableFetchResultsList count];

}

-(NSString *)getWordsFromUserList{
    
    //Get the words that user entered in the text area
    NSString *newList;
    
    newList = self.wordList.text;
    
    return newList;

}

// Allocates a new word list
-(List *)createNewlist{
    
    // Save the list in core data
    
    List *list = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    list.listName = [self getCurrentDateTime];
    
    NSError *error = nil;
    
    //Save objects
    if(![_managedObjectContext save:&error]){
        //Handle Error
        NSLog(@"Problem saving the object to core data");
    }
    
    return list;
}

-(NSArray *)addWordsToList:(NSString *)wordToAddto :(List *)thisList{
    
    //Get word entity from core data
    Word *word = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:self.managedObjectContext];
    
    //Seperate each word at white space and add it to an array
    NSArray *wordArray = [wordToAddto componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //Now add each word to the list
    for (NSString *currentString in wordArray) {
        word.wordString = currentString;
        [thisList addWordsObject:word];
    }
    
    NSError *error = nil;
    
    //Save objects
    if(![_managedObjectContext save:&error]){
        //Handle Error
        NSLog(@"Problem saving the object to core data");
    }
    
    return wordArray;
}

// This method adds the given words to the list view
-(void)updateListView:(NSArray *)addedWords{
    
    NSMutableString *displayList = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [addedWords count]; i++) {
        
        [displayList appendString:[NSString stringWithFormat:@"%@",[addedWords objectAtIndex:i]]];
    }
    
    self.currentList.text = displayList;
 
}

-(NSString *)getCurrentDateTime{
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    return currentTime;
    
}

-(void)displayCurrentList{
    NSError *error = nil;
    
    NSFetchRequest *requestToGetList = [[NSFetchRequest alloc] init];
    NSEntityDescription *list = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:self.managedObjectContext];
    
    [requestToGetList setEntity:list];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wordString" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [requestToGetList setSortDescriptors:sortDescriptors];
    
    NSMutableArray *mutableFetchResultsList = [[self.managedObjectContext executeFetchRequest:requestToGetList error:&error] mutableCopy];
    
    if([mutableFetchResultsList count] == 0){
        self.currentList.text = @"No words added yet";
        self.wordList.text  = @"Add Words ...";
        self.updateTimeLabel.text = @" ";
    }else{
        
        NSMutableString *displayList = [[NSMutableString alloc] init];
        
        for (int i = 0; i < [mutableFetchResultsList count]; i++) {
            [displayList appendString:[NSString stringWithFormat:@"%@", [[mutableFetchResultsList objectAtIndex:i] wordString]]];
        }
        
        self.currentList.text = displayList;
        self.wordList.text  = displayList;
        self.updateTimeLabel.text = [self getListTimeStamp];
    }
}

// Returns the formated date string of last time stamp
-(NSString *)getListTimeStamp{
    NSError *error = nil;
    
    NSFetchRequest *requestList = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *listTitle = [NSEntityDescription entityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    
    [requestList setEntity:listTitle];
    
    
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:requestList error:&error] mutableCopy];
    
    return [NSString stringWithFormat:@"Last Update: %@", [[mutableFetchResult lastObject] listName]];
}


@end
