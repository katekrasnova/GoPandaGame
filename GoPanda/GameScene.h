//
//  GameScene.h
//  GoPanda
//

//  Copyright (c) 2016 Ekaterina Krasnova. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CoreMotion/CoreMotion.h"
#import "MotionHUD/MHMotionHUDScene.h"
#import "GameSettings.h"

@interface GameScene : MHMotionHUDScene

@property (nonatomic) SKAction *runAnimation;
@property (nonatomic) SKAction *jumpAnimation;
@property (nonatomic) SKAction *idleAnimation;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) GameSettings *gameSettings;
@property (nonatomic) BOOL isAccelerometerOn;

@end
