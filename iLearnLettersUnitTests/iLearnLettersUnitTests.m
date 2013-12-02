//
//  iLearnLettersUnitTests.m
//  iLearnLettersUnitTests
//
//  Created by Rouzbeh Roshanravan on 2013-10-26.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import "iLearnLettersUnitTests.h"
#import "WordsLoaderHelper.h"
#import "AppDelegate.h"
#import "Word.h"
#import "GameRecordHelper.h"

@implementation iLearnLettersUnitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testLoadingEasyWords
{
    NSMutableArray* words = [NSMutableArray new];
    [WordsLoaderHelper extractWordsFromFile:@"easy" data:words];
    STAssertTrue(words.count > 10, @"Word count should be greater than 10");
}

- (void)testLoadingHardWords
{
    NSMutableArray* words = [NSMutableArray new];
    [WordsLoaderHelper extractWordsFromFile:@"hard" data:words];
    STAssertTrue(words.count > 10, @"Word count should be greater than 10");
}

- (void)testShuffleArray
{
    NSMutableArray* array = [NSMutableArray new];
    for (int i = 0; i < 10; i++)
    {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    [array shuffle];
    // Verify that the array is not sorted any more
    BOOL sorted = YES;
    for (int i = 0; i + 1< 10; i++)
    {
        int first = [[array objectAtIndex:i] integerValue];
        int second = [[array objectAtIndex:i+1] integerValue];
        if (first > second)
        {
            sorted = NO;
            break;
        }
    }
    
    STAssertFalse(sorted, @"The array should be shuffled");
}

- (void)testGameRecords
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* managedObjectContext = [appDelegate managedObjectContext];
    
    [GameRecordHelper clearGameRecordsForUser:@"user" atLevel:@"easy" context:managedObjectContext];
    
    [GameRecordHelper clearGameRecordsForUser:@"user" atLevel:@"hard" context:managedObjectContext];
    
    // First create a few game records
    for (int i = 0; i < 3; i++)
    {
        [GameRecordHelper saveGameRecordForUser:@"user" level:@"easy" correct:8 total:10 date:[NSDate date] context:managedObjectContext];
    }
    
    for (int i = 0; i < 5; i++)
    {
        [GameRecordHelper saveGameRecordForUser:@"user" level:@"hard" correct:5 total:10 date:[NSDate date] context:managedObjectContext];
    }    
    
    NSArray* records = [GameRecordHelper loadGameRecordsForUser:@"user" atLevel:@"easy" context:managedObjectContext];
    
    STAssertTrue(records.count == 3, @"Should have 3 records for easy level");

    records = [GameRecordHelper loadGameRecordsForUser:@"user" atLevel:@"hard" context:managedObjectContext];
    
    STAssertTrue(records.count == 5, @"Should have 5 records for hard level");
}

@end
