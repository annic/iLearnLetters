//
//  StatsInfo.h
//  iLearnLetters
//
//  Created by Anni Cao on 2013-11-24.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface GameRecord : NSManagedObject

@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *level;
@property (nonatomic) int correct;
@property (nonatomic) int total;
@property (nonatomic, retain) NSDate *date;

@end
