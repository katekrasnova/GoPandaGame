//
//  KKGameData.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 05.07.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKGameData : NSObject <NSCoding>

@property (assign, nonatomic) long score;
@property (assign, nonatomic) int time;

@property (assign, nonatomic) int numberOfLives;

@property (assign, nonatomic) long totalScore;

@property (assign, nonatomic) float musicVolume;
@property (assign, nonatomic) float soundVolume;
@property (assign, nonatomic) BOOL isMusicON;
@property (assign, nonatomic) BOOL isSoundON;

@property (assign, nonatomic) BOOL isAccelerometerON;

@property (assign, nonatomic) int currentLevel;
@property (assign, nonatomic) int completeLevels;
@property (assign, readonly) int numberOfLevels;

@property (assign, nonatomic) BOOL is1millionPointsAchievement;
@property (assign, nonatomic) BOOL is30secAchievement;
@property (assign, nonatomic) BOOL is60secAchievement;
@property (assign, nonatomic) BOOL isAllLevelsAchievement;
@property (assign, nonatomic) BOOL isDestroyAllEnemiesAchievement;

+(instancetype)sharedGameData;
-(void)reset;
-(void)save;

@end
