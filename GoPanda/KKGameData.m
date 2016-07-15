//
//  KKGameData.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 05.07.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "KKGameData.h"

@implementation KKGameData

static NSString* const SSGameDataTotalScoreKey = @"totalScore";
static NSString* const SSGameDataAccelerometerKey = @"isAccelerometerON";
static NSString* const SSGameDataCompleteLevelsKey = @"completeLevels";
static NSString* const SSGameDataNumberOfLevelsKey = @"numberOfLevels";

static const int KKNumberOfLevels = 5;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.totalScore forKey: SSGameDataTotalScoreKey];
    [encoder encodeBool:self.isAccelerometerON forKey:SSGameDataAccelerometerKey];
    [encoder encodeInt:self.completeLevels forKey:SSGameDataCompleteLevelsKey];
    [encoder encodeInt:self.numberOfLevels forKey:SSGameDataNumberOfLevelsKey];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        _totalScore = [decoder decodeDoubleForKey: SSGameDataTotalScoreKey];
        _isAccelerometerON = [decoder decodeBoolForKey:SSGameDataAccelerometerKey];
        _completeLevels = [decoder decodeIntForKey:SSGameDataCompleteLevelsKey];
        _numberOfLevels = KKNumberOfLevels;
    }
    return self;
}

+ (NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}

+ (instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [KKGameData filePath]];
    if (decodedData) {
        KKGameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[KKGameData alloc] init];
}

+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[KKGameData filePath] atomically:YES];
}

-(void)reset
{
    self.score = 0;
    self.time = 0;
}

@end
