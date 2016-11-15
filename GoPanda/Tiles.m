//
//  Tiles.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 15/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "Tiles.h"

@implementation Tiles

- (void)setupTilesForScene:(SKScene *)scene {
    //Init arrays
    self.borders = [NSMutableArray new];
    self.horizontalPlatforms = [NSMutableArray new];
    self.lastPlatformPositions = [NSMutableArray new];
    self.waters = [NSMutableArray new];
    //Setup arrays
    for (SKSpriteNode *child in [scene children]) {
        if ([child.name isEqualToString:@"border"]) {
            [self.borders addObject:child];
        }
        else if ([child.name isEqualToString:@"horizontalPlatform"]) {
            [self.horizontalPlatforms addObject:child];
            [self.lastPlatformPositions addObject:[NSNumber numberWithFloat:0]];
        }
        else if ([child.name isEqualToString:@"water"]) {
            [self.waters addObject:child];
        }
    }
    //Init exitSign
    self.exitSign = [scene childNodeWithName:@"exitSign"];
}

- (void)setupBackgroundImageForScene:(SKScene *)scene {
    int k = self.exitSign.position.x / 1024;
    for (int i = 0; i <= k; i++) {
        self.background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        self.background.xScale = 1.03;
        self.background.yScale = 1.03;
        self.background.zPosition = -99;
        self.background.anchorPoint = CGPointZero;
        self.background.position = CGPointMake(i * self.background.size.width, 0);
        [scene addChild:self.background];
    }
}

@end
