//
//  StatsInfo.m
//  iLearnLetters
//
//  Created by Zheng Wang on 2013-11-24.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import "StatsInfo.h"

static StatsInfo *instance;

@implementation StatsInfo
{
    NSMutableArray *_records;
}

+(StatsInfo*) getInstance
{
    if (!instance)
    {
        instance = [[StatsInfo alloc] init];
    }
    return instance;
}

-(id) init
{
    if (self = [super init])
    {
        _records = [[NSMutableArray alloc] init];
        return self;
    }
    else
        return nil;
}

-(void) addRecord:(GameRecord *)record
{
    [_records addObject:record];
}

-(void) getRecords: (NSMutableArray*)data byUser:(NSString*)user
{
    for (GameRecord* record in _records)
    {
        if ([record.user isEqualToString: user]) {
            [data addObject:record];
        }
    }
}

@end
