//
//  GameScene.h
//  GoPanda
//

//  Copyright (c) 2016 Ekaterina Krasnova. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CoreMotion/CoreMotion.h"
#import "MotionHUD/MHMotionHUDScene.h"

@interface GameScene : MHMotionHUDScene

@property (nonatomic) SKAction *runAnimation;
@property (nonatomic) SKAction *jumpAnimation;
@property (nonatomic) SKAction *idleAnimation;
@property (nonatomic) SKAction *coinAnimation;
@property (nonatomic) SKAction *blueSnailIdleAnimation;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end
