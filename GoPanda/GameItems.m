//
//  GameItems.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 14/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameItems.h"

@implementation GameItems

- (void)setupItemsForScene:(SKScene *)scene {
    //Create Coin animation
    NSMutableArray<SKTexture *> *textures = [NSMutableArray new];
    for (int i = 1; i <= 6; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Coin0%i", i]]];
    }
    self.coinAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    
    //Init arays of items
    self.coins = [NSMutableArray new];
    self.pickUpHearts = [NSMutableArray new];
    self.pickUpClocks = [NSMutableArray new];
    self.pickUpStars = [NSMutableArray new];

    //Add object in arrays of items
    for (SKSpriteNode *child in [scene children]) {
        if ([child.name isEqualToString:@"coin"]) {
            [child runAction:self.coinAnimation withKey:@"CoinAnimation"];
            [self.coins addObject:child];
        }
        else if ([child.name isEqualToString:@"heart"]) {
            [self.pickUpHearts addObject:child];
        }
        else if ([child.name isEqualToString:@"clock"]) {
            [self.pickUpClocks addObject:child];
        }
        if ([child.name isEqualToString:@"star"]) {
            [self.pickUpStars addObject:child];
        }
    }
}

@end
