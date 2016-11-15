//
//  Enemies.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 15/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "Enemies.h"

@implementation Enemies

- (void)createAnimationsForEnemies {
    //Create blue snails idle animation
    NSMutableArray<SKTexture *> *textures = [NSMutableArray new];
    for (int i = 2; i <= 5; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"bluesnail_0%i", i]]];
    }
    self.blueSnailIdleAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    //Create blue Snail Hurt Animation
    textures = [NSMutableArray new];
    for (int i = 6; i <= 9; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"bluesnail_0%i",i]]];
    }
    self.blueSnailHurtAnimation = [SKAction sequence:@[
                                                       [SKAction repeatAction:[SKAction animateWithTextures:textures timePerFrame:0.15] count:1],
                                                       [SKAction fadeOutWithDuration:1.5]]];
    //Create red snails idle animation
    textures = [NSMutableArray new];
    for (int i = 2; i <= 5; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"redsnail_0%i", i]]];
    }
    self.redSnailIdleAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    //Create red Snail Hurt Animation
    textures = [NSMutableArray new];
    for (int i = 6; i <= 9; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"redsnail_0%i",i]]];
    }
    self.redSnailHurtAnimation = [SKAction sequence:@[
                                                      [SKAction repeatAction:[SKAction animateWithTextures:textures timePerFrame:0.15] count:1],
                                                      [SKAction fadeOutWithDuration:1.5]]];
    //Create mushroom idle animation
    textures = [NSMutableArray new];
    for (int i = 1; i <= 6; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"mushroom_0%i", i]]];
    }
    self.mushroomIdleAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    //Create mushroom hurt animation
    textures = [NSMutableArray new];
    for (int i = 1; i <= 8; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"mushroomhurt_0%i", i]]];
    }
    self.mushroomHurtAnimation = [SKAction sequence:@[
                                                      [SKAction repeatAction:[SKAction animateWithTextures:textures timePerFrame:0.1] count:1],
                                                      [SKAction fadeOutWithDuration:1.5]]];
    //Create flower idle animation
    textures = [NSMutableArray new];
    for (int i = 1; i <= 6; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"floweridle_0%i", i]]];
    }
    self.flowerIdleAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    //Create flower hurt animation
    textures = [NSMutableArray new];
    for (int i = 1; i <= 7; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"flowerhurt_0%i", i]]];
    }
    self.flowerHurtAnimation = [SKAction sequence:@[
                                                    [SKAction repeatAction:[SKAction animateWithTextures:textures timePerFrame:0.1] count:1],
                                                    [SKAction fadeOutWithDuration:1.5]]];
    //Create flower attack animation
    textures = [NSMutableArray new];
    for (int i = 1; i <= 9; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"flowerattack_0%i", i]]];
    }
    self.flowerAttackAnimation = [SKAction sequence:@[[SKAction repeatAction:[SKAction animateWithTextures:textures timePerFrame:0.1] count:1], [SKAction waitForDuration:2.0f]]];
}

- (void)setupEnemiesArraysForScene:(SKScene *)scene {
    [self createAnimationsForEnemies];
    //Setup arrays of enemies
    self.bluesnails = [NSMutableArray new];
    self.redsnails = [NSMutableArray new];
    self.mushrooms = [NSMutableArray new];
    self.flowers = [NSMutableArray new];
    self.flowersSpit = [NSMutableArray new];
    for (SKSpriteNode *child in [scene children]) {
        if ([child.name isEqualToString:@"bluesnail"]) {
            [child runAction:self.blueSnailIdleAnimation withKey:@"BlueSnailIdleAnimation"];
            [child setPhysicsBody:nil];
            [self.bluesnails addObject:child];
        }
        else if ([child.name isEqualToString:@"redsnail"]) {
            [child runAction:self.redSnailIdleAnimation withKey:@"RedSnailIdleAnimation"];
            [child setPhysicsBody:nil];
            [self.redsnails addObject:child];
        }
        else if ([child.name isEqualToString:@"mushroom"]) {
            [child runAction:self.mushroomIdleAnimation withKey:@"MushroomIdleAnimation"];
            [child setPhysicsBody:nil];
            [self.mushrooms addObject:child];
        }
        else if ([child.name isEqualToString:@"flower"]) {
            [child runAction:self.flowerIdleAnimation withKey:@"FlowerIdleAnimation"];
            [child setPhysicsBody:nil];
            [self.flowers addObject:child];
        }
    }
    //Setup array isFlowerAttackAnimations
    self.isFlowerAttackAnimation = [NSMutableArray new];
    for (NSInteger i = 0; i < [self.flowers count] + 10; i++) {
        [self.isFlowerAttackAnimation addObject:[NSNumber numberWithInteger:0]];
    }
}

- (SKAction *) attackAnimationForFlower:(SKSpriteNode *)flower inScene:(SKScene *)scene {
    SKSpriteNode *spit = [SKSpriteNode spriteNodeWithImageNamed:@"flowersspit"];
    if (flower.xScale >= 0) {
        spit.position = CGPointMake(flower.position.x + 70, flower.position.y - 10);
    }
    else {
        spit.position = CGPointMake(flower.position.x - 50, flower.position.y - 10);
    }
    spit.zPosition = 3;
    spit.alpha = 0;
    spit.xScale = flower.xScale;
    [scene addChild:spit];
    [spit runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5f], [SKAction fadeAlphaTo:1 duration:0.0f]]]];
    [self.flowersSpit addObject:spit];
    return self.flowerAttackAnimation;
}

@end



