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
#import "AppDelegate.h"
#import "Word.h"

@implementation WordsLoaderHelper

+(void)extractWordsFromFile:(NSString*)level data:(NSMutableArray*)arrayOfWords
{
    if ([level isEqualToString:@"custom"])
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext* managedObjectContext = [appDelegate managedObjectContext];
        
        NSError *error = nil;
        NSFetchRequest *requestToGetList = [[NSFetchRequest alloc] init];
        NSEntityDescription *list = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:managedObjectContext];
        
        [requestToGetList setEntity:list];
        
        NSArray *fetchResultsList = [managedObjectContext executeFetchRequest:requestToGetList error:&error];
        
        //Seperate each word at white space and add it to an array
        NSArray *wordArray = [[[fetchResultsList lastObject] wordString] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        NSCharacterSet *charc=[NSCharacterSet characterSetWithCharactersInString:@" "];
        for (NSString* word in wordArray)
        {
            if ([word stringByTrimmingCharactersInSet:charc].length > 0)
            {
                [arrayOfWords addObject:word];
            }
        }
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

+(NSDictionary*)createPhonicsDictionary
{
    NSArray* _phonemes = [NSArray arrayWithObjects: @"a",@"e",@"i",@"o",@"u",@"b",@"c",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"m",@"n",@"p",@"q",@"r",@"s",@"t",@"v",@"w",@"x",@"y",@"z", nil];
    
    // all letters. Graphemes associated wit those letter. Max 9 graphemes per word.
    NSArray* _aGraphemes = [NSArray arrayWithObjects: @"a, as in hat",@"a, as in laugh",@"a, as in bacon",@"a, as in late",@"a, as in day",@"a, as in train",@"a, as in bread",@"a, as in want", @"a, as in draw", nil];
    NSArray* _eGraphemes = [NSArray arrayWithObjects: @"e as in bed",@"e as in few",@"e as in eight",@"e as in pie",@"e as in me",@"e as in these",@"e as in beat",@"e as in feet", @"e as in key", nil];
    NSArray* _iGraphemes = [NSArray arrayWithObjects: @"i as in find",@"i as in ride",@"i as in light",@"i as in pie",@"i as in if",@"i as in train",@"i as in eight",@"i as in vein", nil];
    NSArray* _oGraphemes = [NSArray arrayWithObjects: @"o as in hot",@"o as in ton",@"o as in bought",@"o as in no",@"o as in note",@"o as in boat",@"o as in soul",@"o as in row", nil];
    NSArray* _uGraphemes = [NSArray arrayWithObjects: @"u as in up",@"u as in haul",@"u as in bought",@"u as in human",@"u as in use",@"u as in soul", nil];
    
    NSArray* _bGraphemes = [NSArray arrayWithObjects: @"b as in big", @"b as in rubber", nil];
    NSArray* _cGraphemes = [NSArray arrayWithObjects: @"c as in cat", @"c as in school", @"c as in occur", @"c as in city", @"c as in ice",@"c as in oscience",@"c as in chef",@"c as in chip", nil];
    NSArray* _dGraphemes = [NSArray arrayWithObjects: @"d as in dog", @"d as in add", @"d as in filled", @"d as in judge" ,nil];
    NSArray* _fGraphemes = [NSArray arrayWithObjects: @"f, as in fish", nil];
    NSArray* _gGraphemes = [NSArray arrayWithObjects: @"g as in go", @"g as in egg", @"g as in cage",@"g as in barge", @"g as in judge",@"g as in gnome",@"g as in sing",  nil];
    NSArray* _hGraphemes = [NSArray arrayWithObjects: @"h as in hot",@"h as in school",@"h as in phone", @"h as in thumb", @"h as in feather",@"h as in ship", nil];
    NSArray* _jGraphemes = [NSArray arrayWithObjects: @"j as in jet", nil];
    NSArray* _kGraphemes = [NSArray arrayWithObjects: @"k as in kitten", @"k as in duck", @"k as in knee" , nil];
    NSArray* _lGraphemes = [NSArray arrayWithObjects: @"l as in leg", @"l as in bell", nil];
    NSArray* _mGraphemes = [NSArray arrayWithObjects: @"m as in mad", @"m as in hammer", @"m as in lamb", nil];
    NSArray* _nGraphemes = [NSArray arrayWithObjects: @"n as in no", @"n as in dinner", @"n as in knee",@"n as in gnome",@"n as in sing", nil];
    NSArray* _pGraphemes = [NSArray arrayWithObjects: @"p as in pie", @"p as in apple", nil];
    NSArray* _qGraphemes = [NSArray arrayWithObjects: @"q as in antique", @"q as in queue", nil];
    NSArray* _rGraphemes = [NSArray arrayWithObjects: @"r as in run", @"r as in marry", @"r as in write", nil];
    NSArray* _sGraphemes = [NSArray arrayWithObjects: @"s as in sun", @"s as in mouse", @"s as in dress",@"s as in science",@"s as in mission", nil];
    NSArray* _tGraphemes = [NSArray arrayWithObjects: @"t as in top", @"t as in letter", @"t as in thumb", @"t as in feather",@"t as in motion",@"t as in match", nil];
    NSArray* _vGraphemes = [NSArray arrayWithObjects: @"v as in vet", @"v as in give", nil];
    NSArray* _wGraphemes = [NSArray arrayWithObjects: @"w as in wet", @"w as in swim",@"w as in what", nil];
    NSArray* _xGraphemes = [NSArray arrayWithObjects: @"x as in xylophone", nil];
    NSArray* _yGraphemes = [NSArray arrayWithObjects: @"y as in yes", nil];
    NSArray* _zGraphemes = [NSArray arrayWithObjects: @"z as in zip", @"z as in fizz", @"z as in sneeze", nil];
    
    NSArray* _graphemesArrays = [NSArray arrayWithObjects: _aGraphemes, _eGraphemes, _iGraphemes, _oGraphemes, _uGraphemes, _bGraphemes, _cGraphemes, _dGraphemes, _fGraphemes, _gGraphemes, _hGraphemes, _jGraphemes, _kGraphemes, _lGraphemes, _mGraphemes, _nGraphemes,  _pGraphemes, _qGraphemes, _rGraphemes,  _sGraphemes, _tGraphemes, _vGraphemes, _wGraphemes, _xGraphemes, _yGraphemes, _zGraphemes, nil];
    return [[NSDictionary alloc] initWithObjects: _graphemesArrays forKeys: _phonemes];
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
