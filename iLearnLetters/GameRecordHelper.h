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

#import <Foundation/Foundation.h>
#import "GameRecord.h"

@interface GameRecordHelper : NSObject

+ (NSArray*)loadGameRecordsForUser: (NSString*)user
                            atLevel:(NSString*)level
                            context:(NSManagedObjectContext*) context;

+ (BOOL)saveGameRecordForUser: (NSString*)user level:(NSString*)level correct:(int)correct total:(int)total date:(NSDate*)date context:(NSManagedObjectContext*) context;

+ (void)clearGameRecordsForUser: (NSString*)user
                        atLevel: (NSString*)level
                        context: (NSManagedObjectContext*)context;
@end
