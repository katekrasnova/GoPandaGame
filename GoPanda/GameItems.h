//
//  GameItems.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 14/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface GameItems : NSObject

@property (strong, nonatomic) SKAction *coinAnimation;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *coins;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *pickUpHearts;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *pickUpClocks;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *pickUpStars;

- (void)setupItemsForScene:(SKScene *)scene;

@end
