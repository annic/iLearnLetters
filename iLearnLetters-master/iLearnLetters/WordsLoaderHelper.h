//
//  Purpose: Helper class for loading word dictionary
//
//  Application: iLearnLetters
//
//  Team: Flying Moose - Group 1
//
//  Revision history:
//
//  Date            Author                      Description
//  ---------------------------------------------------------------------------
//  2013-11-24      Anni Cao                    Original definition
//
//  Known bugs: N/A
//
//  Copyright (c) 2013 Anni Cao. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface WordsLoaderHelper : NSObject

+(void)extractWordsFromFile:(NSString*)level data:(NSMutableArray*)array;

@end

@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end
