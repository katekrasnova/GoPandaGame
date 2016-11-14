//
//  HUD.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 14/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "KKGameData.h"

@interface HUD : NSObject

@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *hearts;
@property (strong, nonatomic) SKSpriteNode *pauseButton;
@property (strong, nonatomic) SKSpriteNode *leftMoveButton;
@property (strong, nonatomic) SKSpriteNode *rightMoveButton;
@property (strong, nonatomic) SKSpriteNode *jumpButton;
@property (strong, nonatomic) SKLabelNode *score;
@property (strong, nonatomic) SKLabelNode *littlePandaScore;
@property (strong, nonatomic) SKLabelNode *time;

- (void)addButtonsAndLabelsWithCameraNode:(SKCameraNode *)camera;
- (void)updateScoreHUD;
- (void)updateHeartsHUD;

@end
