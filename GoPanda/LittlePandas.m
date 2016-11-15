//
//  LittlePandas.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 15/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "LittlePandas.h"

@implementation LittlePandas

- (void)createAnimationsForLittlePandas {
    //Creat little panda eat animation
    NSMutableArray<SKTexture *> *textures = [NSMutableArray new];
    for (int i = 2; i <= 9; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"littlePandaEat_0%i", i]]];
    }
    self.littlePandaEat = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.2]];
    //Creat little panda sleep animation
    textures = [NSMutableArray new];
    for (int i = 1; i <= 12; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"littlePandaSleep_%i", i]]];
    }
    self.littlePandaSleep = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    //Creat little panda move animation
    textures = [NSMutableArray new];
    for (int i = 1; i <= 3; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"littlePandaMove_0%i", i]]];
    }
    self.littlePandaMove = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.2]];
}

- (void)setupArrayOfLittlePandasForScene:(SKScene *)scene {
    [self createAnimationsForLittlePandas];
    //Setup array of little pandas
    self.littlePandas = [NSMutableArray new];
    for (SKSpriteNode *child in [scene children]) {
        if ([child.name isEqualToString:@"littlePandaEat"] || [child.name isEqualToString:@"littlePandaSleep"] || [child.name isEqualToString:@"littlePandaMove"]) {
            [child setPhysicsBody:nil];
            [self.littlePandas addObject:child];
            if ([child.name isEqualToString:@"littlePandaEat"]) {
                [child runAction:self.littlePandaEat withKey:@"LittlePandaEatAnimation"];
            }
            else if ([child.name isEqualToString:@"littlePandaSleep"]) {
                [child runAction:self.littlePandaSleep withKey:@"LittlePandaSleepAnimation"];
            }
            else {
                [child runAction:self.littlePandaMove withKey:@"LittlePandaMoveAnimation"];
            }
        }
    }
    //Setup array of start positions
    self.littlePandasMoveStartPosition = [NSMutableArray new];
    //Setup array of moving pandas
    self.littlePandasMoving = [NSMutableArray new];
    int i = 0;
    for (SKSpriteNode *panda in self.littlePandas) {
        if ([panda.name isEqualToString:@"littlePandaMove"]) {
            [self.littlePandasMoving insertObject:panda atIndex:i];
            
            NSNumber *k = [NSNumber numberWithFloat:panda.position.x];
            [self.littlePandasMoveStartPosition insertObject:k atIndex:i];
            i++;
        }
    }
}

- (void)littlePandasMove {
    for (int i = 0; i < [self.littlePandasMoving count]; i++) {
        if (self.littlePandasMoving[i].xScale > 0) {
            if (self.littlePandasMoving[i].position.x >= [[self.littlePandasMoveStartPosition objectAtIndex:i] floatValue] - 40) {
                self.littlePandasMoving[i].position = CGPointMake(self.littlePandasMoving[i].position.x - 1, self.littlePandasMoving[i].position.y);
            }
            else {
                self.littlePandasMoving[i].xScale = -1.0*ABS(self.littlePandasMoving[i].xScale);
            }
        }
        else {
            if (self.littlePandasMoving[i].position.x <= [[self.littlePandasMoveStartPosition objectAtIndex:i] floatValue] + 40) {
                self.littlePandasMoving[i].position = CGPointMake(self.littlePandasMoving[i].position.x + 1, self.littlePandasMoving[i].position.y);
            }
            else {
                self.littlePandasMoving[i].xScale = 1.0*ABS(self.littlePandasMoving[i].xScale);
            }
        }
    }
}

@end
