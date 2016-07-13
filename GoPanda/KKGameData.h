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
@property (assign, nonatomic) int distance;

@property (assign, nonatomic) long highScore;
@property (assign, nonatomic) long totalDistance;

@property (assign, nonatomic) BOOL isAccelerometerON;

@property (assign, nonatomic) int completeLevels;
@property (assign, readonly) int numberOfLevels;

+(instancetype)sharedGameData;
-(void)reset;
-(void)save;

@end
