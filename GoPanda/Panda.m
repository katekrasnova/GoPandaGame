//
//  Panda.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 14/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "Panda.h"

@implementation Panda

+ (instancetype)initPanda
{
    Panda *panda = [[Panda alloc] init];
    return panda;
}

- (void)didLoadPanda {
    [self createAnimationsForPanda];
    self.isDie = NO;
    self.isFall = NO;
    self.isHurt = NO;
    self.isJump = NO;
}

- (void)createAnimationsForPanda {
    //Create Panda run animation
    NSMutableArray<SKTexture *> *textures = [NSMutableArray new];
    for (int i = 0; i <= 5; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Run_00%i",i]]];
    }
    self.runAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    
    //Create Panda jump animation
    textures = [NSMutableArray new];
    for (int i = 0; i <= 9; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Jump2_00%i",i]]];
    }
    self.jumpAnimation = [SKAction animateWithTextures:textures timePerFrame:0.04];
    
    //Create Panda idle animation
    textures = [NSMutableArray new];
    for (int i = 0; i <= 9; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Idle_00%i",i]]];
    }
    self.idleAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    
    // Create Panda hurt animation
    textures = [NSMutableArray new];
    for (int i = 0; i <= 1; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Hurt_00%i", i]]];
    }
    self.hurtAnimation = [SKAction sequence:@[[SKAction repeatAction:[SKAction animateWithTextures:textures timePerFrame:0.1] count:1], [SKAction repeatAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.6 duration:0.15], [SKAction fadeAlphaTo:1.0 duration:0.15]]] count:4]]];
    
    // Create Panda die animation
    textures = [NSMutableArray new];
    for (int i = 1; i <= 9; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Die_00%i", i]]];
    }
    self.dieAnimation = [SKAction sequence:@[[SKAction repeatAction:[SKAction animateWithTextures:textures timePerFrame:0.2] count:1]]];
}

- (void)idle {
    [self runAction:self.idleAnimation withKey:@"StayAnimation"];
}

- (void)run {
    [self runAction:self.runAnimation withKey:@"MoveAnimation"];
}

- (void)hurt {
    [self runAction:self.hurtAnimation completion:^{
        self.isHurt = NO;
    }];
}

- (void)leftMove {
    self.xScale = -1.0*ABS(self.xScale);
    self.position = CGPointMake(self.position.x - 5, self.position.y);
}

- (void)rightMove {
    self.xScale = 1.0*ABS(self.xScale);
    self.position = CGPointMake(self.position.x + 5, self.position.y);
}

- (void)jumpWithLeftMoveButton:(BOOL)LeftMoveButton andRightMoveButton:(BOOL)RightMoveButton {
    self.isJump = YES;
    [self removePandaActionForKey:@"MoveAnimation"];
    SKAction *jumpMove = [SKAction applyImpulse:CGVectorMake(0, 200) duration:0.1];
    [self runAction:[SKAction sequence:@[jumpMove, self.jumpAnimation]] completion:^{
        self.isJump = NO;
        if (LeftMoveButton == YES || RightMoveButton == YES) {
            [self runAction:self.runAnimation withKey:@"MoveAnimation"];
        }
    }];
}

- (void)removePandaActionForKey:(NSString *)key {
    [self removeActionForKey:key];
}

- (void)moveOnHorizontalPlatforms:(NSArray<SKSpriteNode *> *)horizontalPlatforms withLastPlatformPositions:(NSMutableArray *)lastPlatformPositions{
    for (int i = 0; i < [horizontalPlatforms count]; i++) {
        if (CGRectGetMinY(self.frame) <= CGRectGetMaxY(horizontalPlatforms[i].frame)+10 && CGRectGetMinY(self.frame) >= CGRectGetMaxY(horizontalPlatforms[i].frame)-10 && self.position.x >= horizontalPlatforms[i].position.x-77 && self.position.x <= horizontalPlatforms[i].position.x+77) {
            
            self.position = CGPointMake(self.position.x + (horizontalPlatforms[i].position.x - [lastPlatformPositions[i] floatValue]), self.position.y);
        }
        lastPlatformPositions[i] = [NSNumber numberWithFloat:horizontalPlatforms[i].position.x];
    }
}
@end
