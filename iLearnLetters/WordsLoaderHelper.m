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
        
        [arrayOfWords addObjectsFromArray:wordArray];
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
    NSArray* _aGraphemes = [NSArray arrayWithObjects: @"a, as in \nhat",@"a, as in \nlaugh",@"a, as in \nbacon",@"a, as in \nlate",@"a, as in \nday",@"a, as in \ntrain",@"a, as in \nbread",@"a, as in \nwant", @"a, as in \ndraw", nil];
    NSArray* _eGraphemes = [NSArray arrayWithObjects: @"e as in \nbed",@"e as in \nfew",@"e as in \neight",@"e as in \npie",@"e as in \nme",@"e as in \nthese",@"e as in \nbeat",@"e as in \nfeet", @"e as in \nkey", nil];
    NSArray* _iGraphemes = [NSArray arrayWithObjects: @"i as in \nfind",@"i as in \nride",@"i as in \nlight",@"i as in \npie",@"i as in \nif",@"i as in \ntrain",@"i as in \neight",@"i as in \nvein", nil];
    NSArray* _oGraphemes = [NSArray arrayWithObjects: @"o as in \nhot",@"o as in \nton",@"o as in \nbought",@"o as in \nno",@"o as in \nnote",@"o as in \nboat",@"o as in \nsoul",@"o as in \nrow", nil];
    NSArray* _uGraphemes = [NSArray arrayWithObjects: @"u as in \nup",@"u as in \nhaul",@"u as in \nbought",@"u as in \nhuman",@"u as in \nuse",@"u as in \nsoul", nil];
    
    NSArray* _bGraphemes = [NSArray arrayWithObjects: @"b as in \nbig", @"b as in \nrubber", nil];
    NSArray* _cGraphemes = [NSArray arrayWithObjects: @"c as in \ncat", @"c as in \nschool", @"c as in \noccur", @"c as in \ncity", @"c as in \nice",@"c as in \noscience",@"c as in \nchef",@"c as in \nchip", nil];
    NSArray* _dGraphemes = [NSArray arrayWithObjects: @"d as in \ndog", @"d as in \nadd", @"d as in \nfilled", @"d as in \njudge" ,nil];
    NSArray* _fGraphemes = [NSArray arrayWithObjects: @"f, as in \nfish", nil];
    NSArray* _gGraphemes = [NSArray arrayWithObjects: @"g as in \ngo", @"g as in \negg", @"g as in \ncage",@"g as in \nbarge", @"g as in \njudge",@"g as in \ngnome",@"g as in \nsing",  nil];
    NSArray* _hGraphemes = [NSArray arrayWithObjects: @"h as in \nhot",@"h as in \nschool",@"h as in \nphone", @"h as in \nthumb", @"h as in \nfeather",@"h as in \nship", nil];
    NSArray* _jGraphemes = [NSArray arrayWithObjects: @"j as in \njet", nil];
    NSArray* _kGraphemes = [NSArray arrayWithObjects: @"k as in \nkitten", @"k as in \nduck", @"k as in \nknee" , nil];
    NSArray* _lGraphemes = [NSArray arrayWithObjects: @"l as in \nleg", @"l as in \nbell", nil];
    NSArray* _mGraphemes = [NSArray arrayWithObjects: @"m as in \nmad", @"m as in \nhammer", @"m as in \nlamb", nil];
    NSArray* _nGraphemes = [NSArray arrayWithObjects: @"n as in \nno", @"n as in \ndinner", @"n as in \nknee",@"n as in \ngnome",@"n as in \nsing",@"s as in \nmeasure", nil];
    NSArray* _pGraphemes = [NSArray arrayWithObjects: @"p as in \npie", @"p as in \napple", nil];
    NSArray* _qGraphemes = [NSArray arrayWithObjects: @"q as in \nantique", @"q as in \nqueue", nil];
    NSArray* _rGraphemes = [NSArray arrayWithObjects: @"r as in \nrun", @"r as in \nmarry", @"r as in \nwrite", nil];
    NSArray* _sGraphemes = [NSArray arrayWithObjects: @"s as in \nsun", @"s as in \nmouse", @"s as in \ndress",@"s as in \nscience",@"s as in \nmission", nil];
    NSArray* _tGraphemes = [NSArray arrayWithObjects: @"t as in \ntop", @"t as in \nletter", @"t as in \nthumb", @"t as in \nfeather",@"t as in \nmotion",@"t as in \nmatch", nil];
    NSArray* _vGraphemes = [NSArray arrayWithObjects: @"v as in \nvet", @"v as in \ngive", nil];
    NSArray* _wGraphemes = [NSArray arrayWithObjects: @"w as in \nwet", @"w as in \nswim",@"w as in \nwhat", nil];
    NSArray* _xGraphemes = [NSArray arrayWithObjects: @"x as in \nxylophone", nil];
    NSArray* _yGraphemes = [NSArray arrayWithObjects: @"y as in \nyes", nil];
    NSArray* _zGraphemes = [NSArray arrayWithObjects: @"z as in \nzip", @"z as in \nfizz", @"z as in \nsneeze", nil];
    
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
