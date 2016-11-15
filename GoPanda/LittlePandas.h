//
//  LittlePandas.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 15/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface LittlePandas : NSObject

@property (strong, nonatomic) SKAction *littlePandaEat;
@property (strong, nonatomic) SKAction *littlePandaSleep;
@property (strong, nonatomic) SKAction *littlePandaMove;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *littlePandas;
@property (strong, nonatomic) NSMutableArray<SKSpriteNode *> *littlePandasMoving;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *littlePandasMoveStartPosition;

- (void)createAnimationsForLittlePandas;
- (void)setupArrayOfLittlePandasForScene:(SKScene *)scene;
- (void)littlePandasMove;

@end
