//
//  GameScene.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 07.06.16.
//  Copyright (c) 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameScene.h"
#import "GameWin.h"
#import "GameLose.h"
#import "GameSettings.h"
#import "KKGameData.h"
#import "GameStart.h"

@interface GameScene ()

@property (strong, nonatomic) SKSpriteNode *background;

@end

typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;

@implementation GameScene

BOOL isHurtAnimationRunning;
float lastCameraPosition;
SKNode *exitSign;
SKSpriteNode *endGame;
SKCameraNode *camera;
NSMutableArray<SKSpriteNode *> *coins;
NSMutableArray<SKSpriteNode *> *bluesnails;
NSMutableArray<SKSpriteNode *> *redsnails;
NSMutableArray<SKSpriteNode *> *mushrooms;
NSMutableArray<SKSpriteNode *> *flowers;
NSMutableArray<SKSpriteNode *> *flowersSpit;
NSMutableArray<SKSpriteNode *> *borders;
NSMutableArray<SKSpriteNode *> *littlePandas;
NSMutableArray<SKSpriteNode *> *littlePandasMoving;
NSMutableArray<NSNumber *> *littlePandasMoveStartPosition;
SKSpriteNode *leftMoveButton;
SKSpriteNode *rightMoveButton;
SKSpriteNode *jumpButton;

-(void)didMoveToView:(SKView *)view {
    
    isFlowerAttackAnimation = NO;
    
    isLeftMoveButton = NO;
    isRightMoveButton = NO;
    isJumpButton = NO;
    
    // Set boundaries
    /*SKNode *background = [self childNodeWithName:@"background"];
    SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:background.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 1.0f; */
    
    // Set boundaries and background   //NEW
    exitSign = [self childNodeWithName:@"exitSign"];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, exitSign.position.x + 200, 680)];
    
    int k = exitSign.position.x / 1024;
    for (int i = 0; i <= k; i++) {
        _background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        _background.xScale = 1.03;
        _background.yScale = 1.03;
        _background.zPosition = -99;
        _background.anchorPoint = CGPointZero;
        _background.position = CGPointMake(i * _background.size.width, 0);
        [self addChild:_background];
    }
    
    
    
    //Add Panda Character
    /*SKSpriteNode *panda = [SKSpriteNode spriteNodeWithImageNamed:@"Idle_001"];
    panda.xScale = 0.5;
    panda.yScale = 0.5;
    panda.anchorPoint = CGPointZero;
    panda.position = CGPointMake(0, 0);
    [self addChild:panda]; */
    
    //Create Panda run animation
    NSMutableArray<SKTexture *> *textures = [NSMutableArray new];
    for (int i = 0; i <= 5; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Run_00%i",i]]];
    }
//    [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Idle_000"]]];
    self.runAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    
    //Create Panda jump animation
    textures = [NSMutableArray new];
    for (int i = 0; i <= 9; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Jump2_00%i",i]]];
    }
//    self.jumpAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    self.jumpAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
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
    
    //Create Coin animation
    textures = [NSMutableArray new];
    for (int i = 1; i <= 6; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Coin0%i", i]]];
    }
    self.coinAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    
    //Create blue snails idle animation
    textures = [NSMutableArray new];
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
    //Creat little panda eat animation
    textures = [NSMutableArray new];
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
    
    //Create camera
    SKNode *panda = [self childNodeWithName:@"Panda"];
    [panda runAction:self.idleAnimation withKey:@"StayAnimation"];
    
    
    camera = (SKCameraNode *)[self childNodeWithName:@"MainCamera"];
    id horizConstraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:0] toNode:panda];
    id vertConstraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:0] toNode:panda];
    id leftConstraint = [SKConstraint positionX:[SKRange rangeWithLowerLimit:camera.position.x]];
    id bottomConstraint = [SKConstraint positionY:[SKRange rangeWithLowerLimit:camera.position.y]];
    id rightConstraint = [SKConstraint positionX:[SKRange rangeWithUpperLimit:(exitSign.position.x + 200 - camera.position.x)]];
    id topConstraint = [SKConstraint positionY:[SKRange rangeWithUpperLimit:(_background.frame.size.height - 150 - camera.position.y)]];
    [camera setConstraints:@[horizConstraint, vertConstraint, leftConstraint, bottomConstraint, rightConstraint, topConstraint]];
    //lastCameraPosition = camera.position.x;
    
    //Add moving buttons to screen
    //left move button
    leftMoveButton = [SKSpriteNode spriteNodeWithImageNamed:@"leftbutton"];
    leftMoveButton.alpha = 0.5;
    leftMoveButton.scale = 0.6;
    leftMoveButton.position = CGPointMake(-440, -140);
    leftMoveButton.zPosition = 5;
    leftMoveButton.name = @"leftMoveButton";
    [camera addChild:leftMoveButton];
    //right move button
    rightMoveButton = [SKSpriteNode spriteNodeWithImageNamed:@"rightbutton"];
    rightMoveButton.alpha = 0.5;
    rightMoveButton.scale = 0.6;
    rightMoveButton.position = CGPointMake(-280, -140);
    rightMoveButton.zPosition = 5;
    rightMoveButton.name = @"rightMoveButton";
    [camera addChild:rightMoveButton];
    //jump button
    jumpButton = [SKSpriteNode spriteNodeWithImageNamed:@"jumpbutton"];
    jumpButton.alpha = 0.5;
    jumpButton.scale = 0.6;
    jumpButton.position = CGPointMake(440, -140);
    jumpButton.zPosition = 5;
    jumpButton.name = @"jumpButton";
    [camera addChild:jumpButton];
    
    //End game button
    endGame = [SKSpriteNode spriteNodeWithImageNamed:@"okbutton"];
    endGame.size = CGSizeMake(91, 95);
    endGame.position = CGPointMake(440, 300);
    endGame.name = @"endGame";
    [camera addChild:endGame];

    
    //Score
    [self setupHUD];
    _score.text = [NSString stringWithFormat:@"%li pt", [KKGameData sharedGameData].totalScore];
    _time.text = @"";
    
    //Setup array of coins
    coins = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"coin"]) {
            [child runAction:self.coinAnimation withKey:@"CoinAnimation"];
            [coins addObject:child];
        }
    }
    
    //Setup array of blue snails
    bluesnails = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"bluesnail"]) {
            [child runAction:self.blueSnailIdleAnimation withKey:@"BlueSnailIdleAnimation"];
            [child setPhysicsBody:nil];
            [bluesnails addObject:child];
        }
    }
    
    //Setup array of red snails
    redsnails = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"redsnail"]) {
            [child runAction:self.redSnailIdleAnimation withKey:@"RedSnailIdleAnimation"];
            [child setPhysicsBody:nil];
            [redsnails addObject:child];
        }
    }
    
    //Setup array of mushrooms
    mushrooms = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"mushroom"]) {
            [child runAction:self.mushroomIdleAnimation withKey:@"MushroomIdleAnimation"];
            [child setPhysicsBody:nil];
            [mushrooms addObject:child];
        }
    }
    
    //Setup array of flowers
    flowers = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"flower"]) {
            
            [child runAction:self.flowerIdleAnimation withKey:@"FlowerIdleAnimation"];
            [child setPhysicsBody:nil];
            [flowers addObject:child];
        }
    }
    flowersSpit = [NSMutableArray new];
    
    //Setup array of little pandas
    littlePandas = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"littlePandaEat"] || [child.name isEqualToString:@"littlePandaSleep"] || [child.name isEqualToString:@"littlePandaMove"]) {
            
            [child setPhysicsBody:nil];
            [littlePandas addObject:child];
            
            if ([child.name isEqualToString:@"littlePandaEat"]) {
                [child runAction:self.littlePandaEat withKey:@"LittlePandaEatAnimation"];
            }
            else if ([child.name isEqualToString:@"littlePandaSleep"]) {
                [child runAction:self.littlePandaSleep withKey:@"LittlePandaSleepAnimation"];
            }
            else {
                [child runAction:self.littlePandaMove withKey:@"LittlePandaMoveAnimation"];
                //NSNumber *k = [NSNumber numberWithFloat:child.position.x];
                //[littlePandasMoveStartPosition addObject:k];
            }
        }
    }
    
    littlePandasMoveStartPosition = [NSMutableArray new];
    littlePandasMoving = [NSMutableArray new];
    int i = 0;
    for (SKSpriteNode *panda in littlePandas) {
        if ([panda.name isEqualToString:@"littlePandaMove"]) {
            [littlePandasMoving insertObject:panda atIndex:i];
            
            NSNumber *k = [NSNumber numberWithFloat:panda.position.x];
            [littlePandasMoveStartPosition insertObject:k atIndex:i];
            i++;
        }
    }
    
    //Setup array of borders
    borders = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"border"]) {
            [borders addObject:child];
        }
    }
    
    
}

//Score
SKLabelNode* _score;
SKLabelNode* _time;

-(void)setupHUD
{
    _score = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    _score.fontSize = 30.0;
    _score.position = CGPointMake(362, 130);
    _score.fontColor = [SKColor blackColor];
    [camera addChild:_score];
    
    _time = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    _time.fontSize = 30.0;
    _time.position = CGPointMake(82, 130);
    _time.fontColor = [SKColor blueColor];
    [camera addChild:_time];
}

- (void)updateScore {
    _score.text = [NSString stringWithFormat:@"%li pt", [KKGameData sharedGameData].score + [KKGameData sharedGameData].totalScore];
}


const int kMoveSpeed = 200;
static const NSTimeInterval kHugeTime = 9999.0;

BOOL isLeftMoveButton;
BOOL isRightMoveButton;
BOOL isJumpButton;


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    SKNode *panda = [self childNodeWithName:@"Panda"];
    [panda runAction:self.idleAnimation withKey:@"StayAnimation"];
    

    
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    if ([node.name isEqualToString:@"jumpButton"]) {
        //Jump
        isJumpButton = YES;
        SKAction *jumpMove = [SKAction applyImpulse:CGVectorMake(0, 200) duration:0.1];
        //[panda.physicsBody setAccessibilityFrame:CGRectMake(panda.position.x, panda.position.y, 125, 222)];
        //[panda removeActionForKey:@"StayAnimation"];
        [panda runAction:[SKAction sequence:@[jumpMove, self.jumpAnimation]] completion:^{
            if (isLeftMoveButton == YES || isRightMoveButton == YES) {
                [panda runAction:self.runAnimation withKey:@"MoveAnimation"];
            }
            //[panda removeAllActions];
            //[panda runAction:self.idleAnimation withKey:@"StayAnimation"];
        }];
    }
    
    if ([node.name isEqualToString:@"leftMoveButton"]) {
        //left move
        isLeftMoveButton = YES;
        panda.xScale = -1.0*ABS(panda.xScale);
        //SKAction *leftMove = [SKAction applyForce:CGVectorMake(-150, 0) duration:kHugeTime];
        //[panda runAction:leftMove withKey:@"MoveAction"];
        panda.position = CGPointMake(panda.position.x - 7, panda.position.y);
        [panda runAction:self.runAnimation withKey:@"MoveAnimation"];
        
    }
    if ([node.name isEqualToString:@"rightMoveButton"]) {
        //right move
        isRightMoveButton = YES;
        panda.xScale = 1.0*ABS(panda.xScale);
        //SKAction *rightMove = [SKAction applyForce:CGVectorMake(150, 0) duration:kHugeTime];
        //[panda runAction:rightMove withKey:@"MoveAction"];
        panda.position = CGPointMake(panda.position.x + 7, panda.position.y);
        [panda runAction:self.runAnimation withKey:@"MoveAnimation"];
    }
    
    //Touch end button DELETE
    //CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    //SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    if ([node.name isEqualToString:@"endGame"]) {
        [self endLevel:kEndReasonWin];
    }

}



- (void)reduceTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    //SKNode *panda = [self childNodeWithName:@"Panda"];
    
    
    //CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    //SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    //moveTouches = 0;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SKNode *panda = [self childNodeWithName:@"Panda"];

    [super touchesEnded:touches withEvent:event];
    [self reduceTouches:touches withEvent:event];
    
    if ((isLeftMoveButton == YES || isRightMoveButton == YES) && isJumpButton != YES) {
        [panda removeActionForKey:@"MoveAction"];
        [panda removeActionForKey:@"MoveAnimation"];
        [panda runAction:self.idleAnimation withKey:@"StayAnimation"];
        
        isLeftMoveButton = NO;
        isRightMoveButton = NO;
    }
    
    if (isJumpButton == YES) {
        
        isJumpButton = NO;
        if (isRightMoveButton != YES && isLeftMoveButton != YES) {
            [panda runAction:self.idleAnimation withKey:@"StayAnimation"];

        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self reduceTouches:touches withEvent:event];
    
    
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
}

- (void)littlePandasMove {
    for (int i = 0; i < [littlePandasMoving count]; i++) {
        if (littlePandasMoving[i].xScale > 0) {
            if (littlePandasMoving[i].position.x >= [[littlePandasMoveStartPosition objectAtIndex:i] floatValue] - 40) {
                littlePandasMoving[i].position = CGPointMake(littlePandasMoving[i].position.x - 1, littlePandasMoving[i].position.y);
            }
            else {
                littlePandasMoving[i].xScale = -1.0*ABS(littlePandasMoving[i].xScale);
            }
        }
        else {
            if (littlePandasMoving[i].position.x <= [[littlePandasMoveStartPosition objectAtIndex:i] floatValue] + 40) {
                littlePandasMoving[i].position = CGPointMake(littlePandasMoving[i].position.x + 1, littlePandasMoving[i].position.y);
            }
            else {
                littlePandasMoving[i].xScale = 1.0*ABS(littlePandasMoving[i].xScale);
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime]; //Calls the Visualiser
    
    [self littlePandasMove];
    
    SKNode *panda = [self childNodeWithName:@"Panda"];
    
    if (isLeftMoveButton == YES) {
        panda.position = CGPointMake(panda.position.x - 7, panda.position.y);
    }
    if (isRightMoveButton == YES) {
        panda.position = CGPointMake(panda.position.x + 7, panda.position.y);
    }
    
    if ([KKGameData sharedGameData].isAccelerometerON == YES) {
        [self accelerometerUpdate];
    }
    
    // Score for coins
    //SKSpriteNode *coin = (SKSpriteNode *)[self childNodeWithName:[NSString stringWithFormat:@"coin"]];
    for (int i = 0; i < [coins count]; i++) {
        if ([panda intersectsNode:coins[i]]) {
            [KKGameData sharedGameData].score += 100;
            [self updateScore];
            [self removeChildrenInArray:[NSArray arrayWithObjects:coins[i], nil]];
            [coins[i] removeAllActions];
            [coins removeObject:coins[i]];
        }
    }
    
    
    //Score for times
    static NSTimeInterval _lastCurrentTime = 0;
    if (currentTime-_lastCurrentTime>1) {
        [KKGameData sharedGameData].time++;
        _time.text = [NSString stringWithFormat:@"%i sec", [KKGameData sharedGameData].time];
        _lastCurrentTime = currentTime;
    }
    
    
    //Move score label when camera moves
    
    //NSLog(@"%f", camera.position.x);
    //NSLog(@"%f\n\n", lastCameraPosition);

  /*  if (lastCameraPosition < camera.position.x) {
        //_score.position = CGPointMake(_score.position.x + (camera.position.x - lastCameraPosition), _score.position.y);
        
        
//        [_score runAction:[SKAction moveTo:CGPointMake(camera.position.x - 362, 130) duration:0.1] completion:^{
//            [_score removeAllActions];
//        }];
        //[_score runAction:[SKAction moveTo:CGPointMake(camera.position.x - 362, 130) duration:0.5] withKey:@"ScoreMove"];
        

        
        _time.position = CGPointMake(_time.position.x + (camera.position.x - lastCameraPosition), _time.position.y);
        endGame.position = CGPointMake(endGame.position.x + (camera.position.x - lastCameraPosition), endGame.position.y);
        leftMoveButton.position = CGPointMake(leftMoveButton.position.x + (camera.position.x - lastCameraPosition), leftMoveButton.position.y);
        rightMoveButton.position = CGPointMake(rightMoveButton.position.x + (camera.position.x - lastCameraPosition), rightMoveButton.position.y);
        jumpButton.position = CGPointMake(jumpButton.position.x + (camera.position.x - lastCameraPosition), jumpButton.position.y);
    }
    else if ((lastCameraPosition > camera.position.x) && (lastCameraPosition >= 150)) {
        if (lastCameraPosition >= 500) {
            endGame.position = CGPointMake(endGame.position.x - (lastCameraPosition - camera.position.x), endGame.position.y);
            jumpButton.position = CGPointMake(jumpButton.position.x + (camera.position.x - lastCameraPosition),
                                              jumpButton.position.y);
        }
        _score.position = CGPointMake(_score.position.x - (lastCameraPosition - camera.position.x), _score.position.y);
        _time.position = CGPointMake(_time.position.x - (lastCameraPosition - camera.position.x), _time.position.y);
        leftMoveButton.position = CGPointMake(leftMoveButton.position.x + (camera.position.x - lastCameraPosition), leftMoveButton.position.y);
        rightMoveButton.position = CGPointMake(rightMoveButton.position.x + (camera.position.x - lastCameraPosition), rightMoveButton.position.y);
    } */
    
    
    [self exit];
    
    [self enemies:bluesnails withIdleAnimationKey:@"BlueSnailIdleAnimation" withHurtAnimation:self.blueSnailHurtAnimation];
    [self enemies:redsnails withIdleAnimationKey:@"RedSnailIdleAnimation" withHurtAnimation:self.redSnailHurtAnimation];
    [self enemies:mushrooms withIdleAnimationKey:@"MushroomIdleAnimation" withHurtAnimation:self.mushroomHurtAnimation];
    [self flowersEnemies];

    [self spitMovingUpdate];
    
    //lastCameraPosition = camera.position.x;
}


- (void)pandaHurts {
    SKSpriteNode *panda = (SKSpriteNode *)[self childNodeWithName:@"Panda"];
    
    isHurtAnimationRunning = YES;
    [panda runAction:self.hurtAnimation completion:^{
        isHurtAnimationRunning = NO;
    }];
    
    if (isLeftMoveButton == YES || isRightMoveButton == YES || isJumpButton == YES) {
        [panda runAction:self.runAnimation withKey:@"MoveAnimation"];
    }
    
}

- (void)enemies:(NSMutableArray<SKSpriteNode *> *)enemiesArray withIdleAnimationKey:(NSString *)idleAnimationKey withHurtAnimation:(SKAction *)hurtAnimation {
    SKSpriteNode *panda = (SKSpriteNode *)[self childNodeWithName:@"Panda"];
    for (int i = 0; i < [enemiesArray count]; i++) {
        for (int k = 0; k < [borders count]; k++) {
            
            if ([enemiesArray[i] intersectsNode:borders[k]]) {

                if (enemiesArray[i].xScale < 0) {
                    enemiesArray[i].xScale = 1.0*ABS(enemiesArray[i].xScale);
                }
                else if (enemiesArray[i].xScale > 0) {
                    enemiesArray[i].xScale = -1.0*ABS(enemiesArray[i].xScale);
                }
            }
            
            if ([enemiesArray[i] intersectsNode:panda] && CGRectGetMinX(panda.frame) <= CGRectGetMaxX(enemiesArray[i].frame) && CGRectGetMaxX(panda.frame) >= CGRectGetMinX(enemiesArray[i].frame) && (CGRectGetMinY(enemiesArray[i].frame) - CGRectGetMinY(panda.frame) <= 3 && CGRectGetMinY(enemiesArray[i].frame) - CGRectGetMinY(panda.frame) >= -3)) {
                
                if ((enemiesArray[i].xScale < 0 && (panda.xScale < 0)) || (panda.xScale > 0 && panda.position.x > enemiesArray[i].position.x)) {
                    
                    enemiesArray[i].xScale = 1.0*ABS(enemiesArray[i].xScale);
                }
                else if ((enemiesArray[i].xScale > 0 && panda.xScale > 0) || (panda.xScale < 0 && panda.position.x < enemiesArray[i].position.x)) {
                    
                    enemiesArray[i].xScale = -1.0*ABS(enemiesArray[i].xScale);
                }
                
                if (!isHurtAnimationRunning) {
                    [self pandaHurts];
                }
                
            }
            
            //NSLog(@"%f - %f, %f - %f", CGRectGetMinY(panda.frame), CGRectGetMinY(enemiesArray[i].frame), CGRectGetMinY(panda.frame), CGRectGetMaxY(enemiesArray[i].frame));
            
            if ([enemiesArray[i] intersectsNode:panda] && CGRectGetMinY(panda.frame) >= CGRectGetMinY(enemiesArray[i].frame) + 20 && CGRectGetMinY(panda.frame) <= CGRectGetMaxY(enemiesArray[i].frame)) {
                
                
                
                [enemiesArray[i] removeActionForKey:idleAnimationKey];
                
                SKSpriteNode *tempSnail = [SKSpriteNode new];
                tempSnail = enemiesArray[i];
                [enemiesArray removeObject:enemiesArray[i]];
                [KKGameData sharedGameData].score += 1000;
                [self updateScore];
                [tempSnail setPhysicsBody:NULL];
                [tempSnail runAction:hurtAnimation completion:^{
                    [tempSnail removeFromParent];
                    [tempSnail removeAllActions];
                }];
                
                SKAction *jumpMove = [SKAction applyImpulse:CGVectorMake(0, 200) duration:0.05];
                [panda.physicsBody setAccessibilityFrame:CGRectMake(panda.position.x, panda.position.y, 125, 222)];
                [panda removeActionForKey:@"StayAnimation"];
                [panda runAction:jumpMove withKey:@"JumpAction"];
                [panda runAction:self.jumpAnimation completion:^{
                    if (isLeftMoveButton != YES && isRightMoveButton != YES) {
                        [panda runAction:self.idleAnimation withKey:@"StayAnimation"];
                    }
                }];
                
                break;
            }
            if (enemiesArray[i].xScale < 0) {
                //Right move
                enemiesArray[i].position = CGPointMake(enemiesArray[i].position.x + 0.15, enemiesArray[i].position.y);
            }
            else {
                //Left move
                enemiesArray[i].position = CGPointMake(enemiesArray[i].position.x - 0.15, enemiesArray[i].position.y);
            }
        }
    }
}

BOOL isFlowerAttackAnimation;

- (SKAction *) attackAnimationForFlower:(SKSpriteNode *)flower {
    //Create flower attack animation
    NSMutableArray *textures = [NSMutableArray new];
    for (int i = 1; i <= 9; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"flowerattack_0%i", i]]];
    }
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
    [self addChild:spit];
    [spit runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5f], [SKAction fadeAlphaTo:1 duration:0.0f]]]];
    
    self.flowerAttackAnimation = [SKAction sequence:@[[SKAction repeatAction:[SKAction animateWithTextures:textures timePerFrame:0.1] count:1], [SKAction waitForDuration:2.0f]]];
    
    [flowersSpit addObject:spit];
    
    return self.flowerAttackAnimation;
}

- (void)spitMovingUpdate {
    SKSpriteNode *panda = (SKSpriteNode *)[self childNodeWithName:@"Panda"];

    for (int i = 0; i < [flowersSpit count]; i++) {
        //NSLog(@"%f", flowersSpit[i].position.x);
        //Moving spits
        if (flowersSpit[i].xScale > 0) {
            flowersSpit[i].position = CGPointMake(flowersSpit[i].position.x - 5, flowersSpit[i].position.y);
        }
        else {
            flowersSpit[i].position = CGPointMake(flowersSpit[i].position.x + 5, flowersSpit[i].position.y);
        }
        
        //Intersecting spit with panda
        if ([panda intersectsNode:flowersSpit[i]] && !isHurtAnimationRunning) {
            [self pandaHurts];
        }
        
        //Delete spits
        if (flowersSpit[i].position.x <= -200 || flowersSpit[i].position.x >= exitSign.position.x + 400) {
            [flowersSpit removeObject:flowersSpit[i]];
        }
    }
}

- (void)flowersEnemies {
    SKSpriteNode *panda = (SKSpriteNode *)[self childNodeWithName:@"Panda"];
    for (int i = 0; i < [flowers count]; i++) {
        
        if (flowers[i].position.x >= camera.position.x - self.frame.size.width/2 && flowers[i].position.x <= camera.position.x + self.frame.size.width/2 && !isFlowerAttackAnimation) {
            
            isFlowerAttackAnimation = YES;
            [flowers[i] runAction:[self attackAnimationForFlower:flowers[i]] completion:^{
                isFlowerAttackAnimation = NO;
            }];
        }
        
        if (panda.position.x < flowers[i].position.x) {
            flowers[i].xScale = 1.0*ABS(flowers[i].xScale);
        }
        else {
            flowers[i].xScale = -1.0*ABS(flowers[i].xScale);
        }
        
        //NSLog(@"panda: %f flower: %f", CGRectGetMaxX(panda.frame), CGRectGetMinX(enemiesArray[i].frame));
        //NSLog(@"%i", [flowers[i] intersectsNode:panda]);
        //NSLog(@"%f , %f", CGRectGetMinX(panda.frame), CGRectGetMaxX(flowers[i].frame));
        //NSLog(@"%f", CGRectGetMaxX(panda.frame) - CGRectGetMinX(flowers[i].frame));
        //NSLog(@"%f", CGRectGetMinY(flowers[i].frame) - CGRectGetMinY(panda.frame));
        //NSLog(@"%f", CGRectGetMinY(flowers[i].frame) - CGRectGetMinY(panda.frame));
        //NSLog(@"min camera X = %f, max camera X = %f", camera.position.x - self.frame.size.width/2, camera.position.x + self.frame.size.width/2);
        
        //Intersecting panda and enemy
        if ([flowers[i] intersectsNode:panda] && CGRectGetMinX(panda.frame) <= CGRectGetMaxX(flowers[i].frame) && CGRectGetMaxX(panda.frame) >= CGRectGetMinX(flowers[i].frame) && CGRectGetMaxX(panda.frame) - CGRectGetMinX(flowers[i].frame) >= 20 && (CGRectGetMinY(flowers[i].frame) - CGRectGetMinY(panda.frame) <= 3 && CGRectGetMinY(flowers[i].frame) - CGRectGetMinY(panda.frame) >= -6) && !isHurtAnimationRunning) {
            
            [self pandaHurts];
        }
        
        //Killing enemy
        if ([flowers[i] intersectsNode:panda] && CGRectGetMinY(panda.frame) >= CGRectGetMaxY(flowers[i].frame) - 20 ) {
            
            SKAction *jumpMove = [SKAction applyImpulse:CGVectorMake(0, 130) duration:0.05];
            [panda.physicsBody setAccessibilityFrame:CGRectMake(panda.position.x, panda.position.y, 125, 222)];
            [panda removeActionForKey:@"StayAnimation"];
            [panda runAction:jumpMove withKey:@"JumpAction"];
            [panda runAction:self.jumpAnimation withKey:@"JumpAnimation"];
            
            //[flowers[i] removeActionForKey:@"FlowerIdleAnimation"];
            [flowers[i] removeAllActions];
            
            SKSpriteNode *tempSnail = [SKSpriteNode new];
            tempSnail = flowers[i];
            [flowers removeObject:flowers[i]];
            [KKGameData sharedGameData].score += 1000;
            [self updateScore];
            [tempSnail setPhysicsBody:NULL];
            [tempSnail runAction:self.flowerHurtAnimation completion:^{
                [tempSnail removeFromParent];
                [tempSnail removeAllActions];
            }];
            break;
        }
    }
}

- (void)exit {
    static NSTimeInterval lastCurrentTime = 0;
    SKNode *panda = [self childNodeWithName:@"Panda"];
    SKEmitterNode *particleExit = (SKEmitterNode *)[self childNodeWithName:@"particleExit"];
    if (panda.position.x > (particleExit.position.x - 10) && panda.position.x < (particleExit.position.x + 10)) {
        if ([panda actionForKey:@"JumpAnimation"] == nil && [panda actionForKey:@"MoveAnimation"] == nil) {
            lastCurrentTime += 1;
            if (lastCurrentTime >= 60) {
                lastCurrentTime = 0;
                [self endLevel:kEndReasonWin];
            }
        }
    }
}

- (void)endLevel:(EndReason)endReason {
    
    if (endReason == kEndReasonWin) {
        [KKGameData sharedGameData].totalScore += [KKGameData sharedGameData].score;
    }
    
    SKView * skView = (SKView *)self.view;
    GameStart *scene = [GameStart nodeWithFileNamed:@"GameStart"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
    
    [[KKGameData sharedGameData] save];
    [[KKGameData sharedGameData] reset];

    
}

- (void)accelerometerUpdate {
    SKNode *panda = [self childNodeWithName:@"Panda"];
    
    /* Set up the motion manager if necessary */
    if (!self.motionManager) {
        self.motionManager = [CMMotionManager new];
        self.motionManager.deviceMotionUpdateInterval = 0.1;
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
    }
    
    CMDeviceMotion *motion = self.motionManager.deviceMotion;
    if (motion) {
        CMAttitude *attitude = motion.attitude;
        NSLog(@"%f", attitude.pitch);
        if ((attitude.pitch > -0.2) && (attitude.pitch < 0.0)) {
            panda.xScale = 1.0*ABS(panda.xScale);
            SKAction *rightAccelMove = [SKAction moveBy:CGVectorMake(1.0*kMoveSpeed*kHugeTime, 0) duration:kHugeTime];
            [panda removeActionForKey:@"StayAnimation"];
            [panda runAction:rightAccelMove withKey:@"MoveAction"];
            [panda runAction:self.runAnimation withKey:@"MoveAnimation"];
        }
        else if ((attitude.pitch < 0.2) && (attitude.pitch > 0.0)) {
            panda.xScale = -1.0*ABS(panda.xScale);
            SKAction *leftAccelMove = [SKAction moveBy:CGVectorMake(-1.0*kMoveSpeed*kHugeTime, 0) duration:kHugeTime];
            [panda removeActionForKey:@"StayAnimation"];
            [panda runAction:leftAccelMove withKey:@"MoveAction"];
            [panda runAction:self.runAnimation withKey:@"MoveAnimation"];
        }
        else if ((attitude.pitch < 0.005) && (attitude.pitch > -0.005)) {
            [panda removeActionForKey:@"MoveAnimation"];
            [panda removeActionForKey:@"MoveAction"];
            [panda runAction:self.idleAnimation withKey:@"StayAnimation"];
        }
    }
    else {
        [panda runAction:self.idleAnimation withKey:@"StayAnimation"];
    }
}

@end
