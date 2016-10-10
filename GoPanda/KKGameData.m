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
static NSString* const SSGameDataCurrentLevelKey = @"currentLevel";
static NSString* const SSGameDataCompleteLevelsKey = @"completeLevels";
static NSString* const SSGameDataNumberOfLevelsKey = @"numberOfLevels";
static NSString* const SSGameDataNumberOfLivesKey = @"numberOfLives";
static NSString* const SSGameDataMusicVolumeKey = @"musicVolume";
static NSString* const SSGameDataSoundVolumeKey = @"soundVolume";
static NSString* const SSGameDataIsMusicONKey = @"isMusicON";
static NSString* const SSGameDataIsSoundONKey = @"isSoundON";

static const int KKNumberOfLevels = 15;
static const int KKNumberOfLives = 3;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.totalScore forKey: SSGameDataTotalScoreKey];
    [encoder encodeBool:self.isAccelerometerON forKey:SSGameDataAccelerometerKey];
    [encoder encodeInt:self.completeLevels forKey:SSGameDataCompleteLevelsKey];
    [encoder encodeInt:self.currentLevel forKey:SSGameDataCurrentLevelKey];
    //[encoder encodeInt:self.numberOfLevels forKey:SSGameDataNumberOfLevelsKey];
    _numberOfLevels = KKNumberOfLevels;
    [encoder encodeInt:self.numberOfLives forKey:SSGameDataNumberOfLivesKey];
    [encoder encodeFloat:self.musicVolume forKey:SSGameDataMusicVolumeKey];
    [encoder encodeFloat:self.soundVolume forKey:SSGameDataSoundVolumeKey];
    [encoder encodeBool:self.isMusicON forKey:SSGameDataIsMusicONKey];
    [encoder encodeBool:self.isSoundON forKey:SSGameDataIsSoundONKey];

    
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        _totalScore = [decoder decodeDoubleForKey: SSGameDataTotalScoreKey];
        _isAccelerometerON = [decoder decodeBoolForKey:SSGameDataAccelerometerKey];
        _completeLevels = [decoder decodeIntForKey:SSGameDataCompleteLevelsKey];
        _currentLevel = [decoder decodeIntForKey:SSGameDataCurrentLevelKey];
        _musicVolume = [decoder decodeFloatForKey:SSGameDataMusicVolumeKey];
        _soundVolume = [decoder decodeFloatForKey:SSGameDataSoundVolumeKey];
        _isMusicON = [decoder decodeBoolForKey:SSGameDataIsMusicONKey];
        _isSoundON = [decoder decodeBoolForKey:SSGameDataIsSoundONKey];
        _numberOfLevels = KKNumberOfLevels;
        _numberOfLives = KKNumberOfLives;
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
    self.numberOfLives = KKNumberOfLives;
    //self.currentLevel = 0;
}

@end
