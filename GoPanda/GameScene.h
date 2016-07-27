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
@property (nonatomic) SKAction *hurtAnimation;
@property (nonatomic) SKAction *coinAnimation;
@property (nonatomic) SKAction *blueSnailIdleAnimation;
@property (nonatomic) SKAction *blueSnailHurtAnimation;
@property (nonatomic) SKAction *redSnailIdleAnimation;
@property (nonatomic) SKAction *redSnailHurtAnimation;
@property (nonatomic) SKAction *mushroomIdleAnimation;
@property (nonatomic) SKAction *mushroomHurtAnimation;
@property (nonatomic) SKAction *flowerIdleAnimation;
@property (nonatomic) SKAction *flowerHurtAnimation;
@property (nonatomic) SKAction *flowerAttackAnimation;
@property (nonatomic) SKAction *littlePandaEat;

@property (strong, nonatomic) CMMotionManager *motionManager;

@end
