//
//  GameScene.h
//  GoPanda
//

//  Copyright (c) 2016 Ekaterina Krasnova. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CoreMotion/CoreMotion.h"
#import "Panda.h"
#import "HUD.h"
//#import "MotionHUD/MHMotionHUDScene.h"
@import AVFoundation;

@interface GameScene : SKScene <AVAudioPlayerDelegate>

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
@property (nonatomic) SKAction *littlePandaSleep;
@property (nonatomic) SKAction *littlePandaMove;

//@property (strong, nonatomic) CMMotionManager *motionManager;

@end
