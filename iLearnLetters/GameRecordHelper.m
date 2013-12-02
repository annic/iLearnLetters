//  Purpose: Helper class for loading/saving game records
//
//  Application: iLearnLetters
//
//  Team: Flying Moose - Group 1
//
//  Revision history:
//
//  Date            Author                      Description
//  ---------------------------------------------------------------------------
//  2013-12-01      Anni Cao                    Original definition
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Anni Cao. All rights reserved.
//

#import "GameRecordHelper.h"
#import "GameRecord.h"

@implementation GameRecordHelper

+ (NSArray*)loadGameRecordsForUser: (NSString*)user
                            atLevel:(NSString*)level
                            context:(NSManagedObjectContext*) context
{
    // Create a fetch request to retrieve stats from core data
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"GameRecord"
                inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(user == %@) AND (level == %@)", user, level];
    [request setPredicate:predicate];
    
    // Sort by the date in ascending order
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    // Run the fetch request
    NSError* error;
    NSArray* records = [context executeFetchRequest:request error:&error];
    if (!records)
    {
        NSLog(@"Failed to load stats from core data");
    }
    return records;
}

+ (BOOL)saveGameRecordForUser: (NSString*)user level:(NSString*)level correct:(int)correct total:(int)total date:(NSDate*)date context:(NSManagedObjectContext*) context

{
    GameRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"GameRecord" inManagedObjectContext:context];
    record.user = user;
    record.level = level;
    record.correct = correct;
    record.total = total;
    record.date = date;
    
    NSError *error = nil;
    
    //Save objects
    return [context save:&error];
}

+ (void)clearGameRecordsForUser:(NSString *)user atLevel:(NSString *)level context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"GameRecord"
                inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(user == %@) AND (level == %@)", user, level];
    [request setPredicate:predicate];
    
    // Run the fetch request
    NSError* error;
    NSArray* records = [context executeFetchRequest:request error:&error];
    if (records)
    {
        for (GameRecord* record in records)
        {
            [context deleteObject:record];
        }
    }
    else
    {
        NSLog(@"Failed to load stats from core data");
    }
    
    //Save context to remove the records
    if(![context save:&error]){
        //Handle Error
        NSLog(@"Problem saving stats info to core data");
    }
}

@end
