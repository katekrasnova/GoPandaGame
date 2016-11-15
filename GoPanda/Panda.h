//
//  Panda.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 14/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Panda : SKSpriteNode

//Animations for Panda
@property (strong, nonatomic) SKAction *runAnimation;
@property (strong, nonatomic) SKAction *jumpAnimation;
@property (strong, nonatomic) SKAction *idleAnimation;
@property (strong, nonatomic) SKAction *hurtAnimation;
@property (strong, nonatomic) SKAction *dieAnimation;
//Bool properties for panda's states
@property (nonatomic) BOOL isFall;
@property (nonatomic) BOOL isDie;
@property (nonatomic) BOOL isJump;
@property (nonatomic) BOOL isHurt;

//Methods
+ (instancetype)initPanda;
- (void)didLoadPanda;
- (void)idle;
- (void)run;
- (void)hurt;
- (void)leftMove;
- (void)rightMove;
- (void)jumpWithLeftMoveButton:(BOOL)LeftMoveButton andRightMoveButton:(BOOL)RightMoveButton;
- (void)removePandaActionForKey:(NSString *)key;
- (void)moveOnHorizontalPlatforms:(NSArray<SKSpriteNode *> *)horizontalPlatforms withLastPlatformPositions:(NSMutableArray *)lastPlatformPositions;
@end
