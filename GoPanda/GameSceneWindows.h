//
//  GameSceneWindows.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 14/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "KKGameData.h"

@interface GameSceneWindows : NSObject

@property (strong, nonatomic) SKSpriteNode *pauseWindow;
@property (strong, nonatomic) SKLabelNode *pausedLabel;
@property (strong, nonatomic) SKSpriteNode *pauseMusicButton;
@property (strong, nonatomic) SKSpriteNode *pauseSoundButton;
@property (strong, nonatomic) SKSpriteNode *pauseResumeButton;
@property (strong, nonatomic) SKSpriteNode *pauseRestartButton;
@property (strong, nonatomic) SKSpriteNode *pauseHomeButton;
@property (strong, nonatomic) SKSpriteNode *pauseLevelsButton;

- (void)setupPauseWindowForScene:(SKScene *)scene withCamera:(SKCameraNode *)camera;
- (void)removePauseWindow;
- (void)setupLoseWindowForScene:(SKScene *)scene withCamera:(SKCameraNode *)camera;
- (void)setupWinWindowForScene:(SKScene *)scene withCamera:(SKCameraNode *)camera winTime:(long)t winScore:(long)k andPickedUpStars:(NSMutableArray *)stars;
- (void)addAchievement:(NSString *)achievement forScene:(SKScene *)scene withCamera:(SKCameraNode *)camera;
- (void)initLabelForfirstLevelForScene:(SKScene *)scene;

@end
