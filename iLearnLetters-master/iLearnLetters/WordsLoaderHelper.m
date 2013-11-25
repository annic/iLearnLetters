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

#import "WordsLoaderHelper.h"

@implementation WordsLoaderHelper

+(void)extractWordsFromFile:(NSString*)level data:(NSMutableArray*)arrayOfWords
{
    if ([level isEqualToString:@"custom"])
    {
        // TODO: custom loading
    }
    else
    {
        NSString* path = [[NSBundle mainBundle] pathForResource:level ofType:@"txt"];
    
        NSString* content = [NSString stringWithContentsOfFile:path
                                      encoding:NSUTF8StringEncoding
                                      error:NULL];
    
        NSArray *lineArray = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    
        for (int i = 0; i < [lineArray count]; i++)
        {
            NSString* word = [lineArray objectAtIndex:i];
            if (word.length > 0)
                [arrayOfWords addObject:word];
        }
    }
    
    NSLog(@"Loaded %d words for level: %@", [arrayOfWords count], level);
}

@end

@implementation NSMutableArray (Shuffling)

- (void) shuffle
{
    NSUInteger count = self.count;
    for (NSUInteger i = 0; i < count; ++i)
    {
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
