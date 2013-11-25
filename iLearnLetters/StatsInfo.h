//
//  StatsInfo.h
//  iLearnLetters
//
//  Created by Zheng Wang on 2013-11-24.
//  Copyright (c) 2013 Rouzbeh Roshanravan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface GameRecord : NSObject
@property NSString *user;
@property NSString *level;
@property int correctAnswers;
@property int totalQuestions;
@property NSDate *date;

@end

@interface StatsInfo : NSManagedObject

-(void) addRecord: (GameRecord*)record;
-(void) getRecords: (NSMutableArray*)data byUser:(NSString*)user;

@end
