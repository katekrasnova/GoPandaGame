//
//  Tiles.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 15/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Tiles : NSObject

@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *borders;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *horizontalPlatforms;
@property (strong, nonatomic) NSMutableArray *lastPlatformPositions;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *waters;
@property (strong, nonatomic) SKSpriteNode *background;
@property (strong, nonatomic) SKNode *exitSign;

- (void)setupTilesForScene:(SKScene *)scene;
- (void)setupBackgroundImageForScene:(SKScene *)scene;

@end
