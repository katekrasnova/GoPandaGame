//
//  Enemies.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 15/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Panda.h"

@interface Enemies : NSObject

@property (strong, nonatomic) SKAction *blueSnailIdleAnimation;
@property (strong, nonatomic) SKAction *blueSnailHurtAnimation;
@property (strong, nonatomic) SKAction *redSnailIdleAnimation;
@property (strong, nonatomic) SKAction *redSnailHurtAnimation;
@property (strong, nonatomic) SKAction *mushroomIdleAnimation;
@property (strong, nonatomic) SKAction *mushroomHurtAnimation;
@property (strong, nonatomic) SKAction *flowerIdleAnimation;
@property (strong, nonatomic) SKAction *flowerHurtAnimation;
@property (strong, nonatomic) SKAction *flowerAttackAnimation;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *bluesnails;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *redsnails;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *mushrooms;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *flowers;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *flowersSpit;
@property (strong, nonatomic) NSMutableArray *isFlowerAttackAnimation;

- (void)setupEnemiesArraysForScene:(SKScene *)scene;
- (SKAction *) attackAnimationForFlower:(SKSpriteNode *)flower inScene:(SKScene *)scene;
- (void)flowersSpitMovingWithExitSign:(SKNode *)exitSign;
@end
