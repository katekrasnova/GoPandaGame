//
//  GameScene.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 07.06.16.
//  Copyright (c) 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@property (strong, nonatomic) SKSpriteNode *background;

@end

typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;

@implementation GameScene

BOOL isExit;
BOOL isPause;
float lastCameraPosition;
int level;
HUD *hud;
Panda *panda;
LittlePandas *littlePandas;
Enemies *enemies;
GameItems *items;
GameSceneWindows *windowController;
SoundController *soundController;
SKNode *exitSign;
SKCameraNode *camera;
NSMutableArray<SKSpriteNode *> *borders;
NSMutableArray<SKSpriteNode *> *horizontalPlatforms;
NSMutableArray *lastPlatformPositions;
NSMutableArray<SKSpriteNode *> *waters;

-(void)didMoveToView:(SKView *)view {
    
    isLeftMoveButton = NO;
    isRightMoveButton = NO;
    isJumpButton = NO;
    isExit = NO;
    isPause = NO;
    level = [KKGameData sharedGameData].currentLevel;
    //Init sound controller and background music
    soundController = [[SoundController alloc]init];
    [soundController setupBackgroundGameMusic];
    soundController.backgroundGameMusic.delegate = self;
    [soundController.backgroundGameMusic play];
    // Set boundaries and background
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
    //Init Little Pandas
    littlePandas = [[LittlePandas alloc]init];
    [littlePandas setupArrayOfLittlePandasForScene:self];
    //Init Panda
    panda = [Panda initPanda];
    panda = (Panda *)[self childNodeWithName:@"Panda"];
    [panda didLoadPanda];
    [panda idle];
    //Create camera
    camera = (SKCameraNode *)[self childNodeWithName:@"MainCamera"];
    id horizConstraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:0] toNode:panda];
    id vertConstraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:0] toNode:panda];
    id leftConstraint = [SKConstraint positionX:[SKRange rangeWithLowerLimit:camera.position.x]];
    id bottomConstraint = [SKConstraint positionY:[SKRange rangeWithLowerLimit:camera.position.y]];
    id rightConstraint = [SKConstraint positionX:[SKRange rangeWithUpperLimit:(exitSign.position.x + 200 - camera.position.x)]];
    id topConstraint = [SKConstraint positionY:[SKRange rangeWithUpperLimit:(_background.frame.size.height - 10 - camera.position.y)]];
    [camera setConstraints:@[horizConstraint, vertConstraint, leftConstraint, bottomConstraint, rightConstraint, topConstraint]];
    if ([KKGameData sharedGameData].numberOfLives == 0) {
        [KKGameData sharedGameData].numberOfLives = 3;
    }
    //Add moving buttons to screen
    hud = [[HUD alloc]init];
    [hud addButtonsAndLabelsWithCameraNode:camera];
    hud.score.text = [NSString stringWithFormat:@"%li", [KKGameData sharedGameData].totalScore];
    hud.time.text = @"00:00";
    hud.littlePandaScore.text = @"x 3";
    //Init pause window
    windowController = [[GameSceneWindows alloc]init];
    //Init items
    items = [[GameItems alloc]init];
    [items setupItemsForScene:self];
    //Init enemies
    enemies = [[Enemies alloc]init];
    [enemies setupEnemiesArraysForScene:self];
    //Setup array of borders
    borders = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"border"]) {
            [borders addObject:child];
        }
    }
    //Setup array of horizontal platforms
    horizontalPlatforms = [NSMutableArray new];
    lastPlatformPositions = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"horizontalPlatform"]) {
            [horizontalPlatforms addObject:child];
            [lastPlatformPositions addObject:[NSNumber numberWithFloat:0]];
        }
    }
    //Setup array of waters
    waters = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"water"]) {
            [waters addObject:child];
        }
    }
    if ([KKGameData sharedGameData].currentLevel == 1) {
        [windowController initLabelForfirstLevelForScene:self];
    }
}

const int kMoveSpeed = 200;
BOOL isLeftMoveButton;
BOOL isRightMoveButton;
BOOL isJumpButton;
BOOL isSecondTouchJumpButton;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    if (!panda.isFall && !panda.isDie && !isExit && !isPause) {
        if ([node.name isEqualToString:@"jumpButton"]) {
            if (!panda.isJump) {
                //Jump
                [hud.jumpButton setTexture:[SKTexture textureWithImageNamed:@"greenjumpbutton"]];
                isJumpButton = YES;
                panda.isJump = YES;
                [panda removePandaActionForKey:@"MoveAnimation"];
                SKAction *jumpMove = [SKAction applyImpulse:CGVectorMake(0, 200) duration:0.1];
                [panda runAction:[SKAction sequence:@[jumpMove, panda.jumpAnimation]] completion:^{
                    panda.isJump = NO;
                    if (isLeftMoveButton == YES || isRightMoveButton == YES) {
                        [panda runAction:panda.runAnimation withKey:@"MoveAnimation"];
                    }
                }];
            }
            else {
                isSecondTouchJumpButton = YES;
            }
        }
        if ([node.name isEqualToString:@"leftMoveButton"]) {
            //left move
            [hud.leftMoveButton setTexture:[SKTexture textureWithImageNamed:@"greenleftbutton"]];
            isLeftMoveButton = YES;
            [panda leftMove];
            [panda run];
            
        }
        if ([node.name isEqualToString:@"rightMoveButton"]) {
            //right move
            [hud.rightMoveButton setTexture:[SKTexture textureWithImageNamed:@"greenrightbutton"]];
            isRightMoveButton = YES;
            [panda rightMove];
            [panda run];
        }
    }
    //Touch Pause Button
    if ([node.name isEqualToString:@"pauseButton"] && !isExit) {
        if (isPause) {
            [windowController removePauseWindow];
            hud.pauseButton.texture = [SKTexture textureWithImageNamed:@"pauseButtonOff"];
            isPause = NO;
        }
        else {
            [windowController setupPauseWindowForScene:self withCamera:camera];
            hud.pauseButton.texture = [SKTexture textureWithImageNamed:@"pauseButtonOn"];
            isPause = YES;
        }
    }
    //Touch music button in pause window
    if ([node.name isEqualToString:@"pauseMusicButton"]) {
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];
        if ([KKGameData sharedGameData].musicVolume > 0) {
            [KKGameData sharedGameData].musicVolume = 0;
            [KKGameData sharedGameData].isMusicON = NO;
            node.texture = [SKTexture textureWithImageNamed:@"musicbutton_off"];
        }
        else {
            [KKGameData sharedGameData].musicVolume = 0.5;
            [KKGameData sharedGameData].isMusicON = YES;
            node.texture = [SKTexture textureWithImageNamed:@"musicbutton_on"];
        }
        [[KKGameData sharedGameData]save];
        soundController.backgroundGameMusic.volume = [KKGameData sharedGameData].musicVolume;
    }
    //Touch sound button in pause window
    if ([node.name isEqualToString:@"pauseSoundButton"]) {
        if ([KKGameData sharedGameData].soundVolume > 0) {
            [KKGameData sharedGameData].soundVolume = 0;
            [KKGameData sharedGameData].isSoundON = NO;
            node.texture = [SKTexture textureWithImageNamed:@"soundbutton_off"];
        }
        else {
            [KKGameData sharedGameData].soundVolume = 0.75;
            [KKGameData sharedGameData].isSoundON = YES;
            node.texture = [SKTexture textureWithImageNamed:@"soundbutton_on"];
        }
        [[KKGameData sharedGameData]save];
    }
    
    if ([node.name isEqualToString:@"homebutton"] || [node.name isEqualToString:@"levelsbutton"] || [node.name isEqualToString:@"restartbutton"] || [node.name isEqualToString:@"playbutton"]) {
        
        SKView * skView = (SKView *)self.view;
        MenuScenesController *scene = [MenuScenesController new];
        if ([node.name isEqualToString:@"homebutton"]) {
            [soundController.backgroundGameMusic stop];
            [[KKGameData sharedGameData] reset];
            [[[GameViewController alloc]init]playMenuBackgroundMusic];
            scene = [MenuScenesController nodeWithFileNamed:@"GameStart"];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }
        else if ([node.name isEqualToString:@"levelsbutton"]) {
            [soundController.backgroundGameMusic stop];
            [[KKGameData sharedGameData] reset];
            [[[GameViewController alloc]init]playMenuBackgroundMusic];
            scene = [MenuScenesController nodeWithFileNamed:@"GameLevels"];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }
        else if ([node.name isEqualToString:@"playbutton"]) {
            if (level < [KKGameData sharedGameData].numberOfLevels) {
                [KKGameData sharedGameData].currentLevel = level + 1;
            }
            else {
                [KKGameData sharedGameData].currentLevel = level;
            }
            GameScene *gameScene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", [KKGameData sharedGameData].currentLevel]];
            [[KKGameData sharedGameData] save];
            [[KKGameData sharedGameData] reset];
            gameScene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:gameScene];
        }
        else if ([node.name isEqualToString:@"restartbutton"]) {
            GameScene *gameScene;
            if (level < 1) {
                gameScene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", 1]];
            }
            else {
                gameScene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", level]];
            }
            [KKGameData sharedGameData].currentLevel = level;
            [[KKGameData sharedGameData] save];
            [[KKGameData sharedGameData] reset];
            gameScene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:gameScene];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    if (isLeftMoveButton || isRightMoveButton) {
        if ([node.name isEqualToString:@"leftMoveButton"]) {
            [hud.leftMoveButton setTexture:[SKTexture textureWithImageNamed:@"greenleftbutton"]];
            [hud.rightMoveButton setTexture:[SKTexture textureWithImageNamed:@"rightbutton"]];
            //left move
            isLeftMoveButton = YES;
            isRightMoveButton = NO;
            [panda leftMove];
        }
        if ([node.name isEqualToString:@"rightMoveButton"]) {
            [hud.rightMoveButton setTexture:[SKTexture textureWithImageNamed:@"greenrightbutton"]];
            [hud.leftMoveButton setTexture:[SKTexture textureWithImageNamed:@"leftbutton"]];
            //right move
            isRightMoveButton = YES;
            isLeftMoveButton = NO;
            [panda rightMove];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ((isLeftMoveButton || isRightMoveButton) && !isJumpButton) {
        if (!isSecondTouchJumpButton) {
            [panda removePandaActionForKey:@"MoveAction"];
            [panda removePandaActionForKey:@"MoveAnimation"];
            [panda idle];
            isLeftMoveButton = NO;
            isRightMoveButton = NO;
            [hud.leftMoveButton setTexture:[SKTexture textureWithImageNamed:@"leftbutton"]];
            [hud.rightMoveButton setTexture:[SKTexture textureWithImageNamed:@"rightbutton"]];
        }
        else if (isSecondTouchJumpButton){
            isSecondTouchJumpButton = NO;
        }
    }
    
    else if (isJumpButton) {
        [hud.jumpButton setTexture:[SKTexture textureWithImageNamed:@"jumpbutton"]];
        isJumpButton = NO;
        if (!isRightMoveButton && !isLeftMoveButton) {
            [panda idle];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)pandaFallinWater {
    for (int i = 0; i < [waters count]; i++) {
        if ([panda intersectsNode:waters[i]] && panda.position.y <= 150) {
            isExit = YES;
            if (!panda.isFall) {
                for (int i = 0; i < [hud.hearts count];i++) {
                    [hud.hearts[i] setTexture:[SKTexture textureWithImageNamed:@"hud_heartEmpty"]];
                }
                [soundController.backgroundGameMusic stop];
                [soundController playSoundNamed:@"lose_sound" ofType:@"mp3"];
                panda.physicsBody = nil;
                SKAction *jumpFallUp = [SKAction moveTo:CGPointMake(panda.position.x, panda.position.y + 200) duration:0.3];
                SKAction *jumpFallDown = [SKAction moveTo:CGPointMake(panda.position.x, panda.position.y - 150) duration:0.3];
                [panda runAction:[SKAction sequence:@[jumpFallUp,[SKAction waitForDuration:1]]] completion:^{
                    [panda runAction:[SKAction sequence:@[jumpFallDown]] completion:^{
                        [self endLevel:kEndReasonLose];
                    }];
                }];
            }
            panda.isFall = YES;
        }
    }
}

- (void)saveLittlePandas {
    for (int i = 0; i < [littlePandas.littlePandas count]; i++) {
        if ([panda intersectsNode:littlePandas.littlePandas[i]]) {
            [soundController playSoundNamed:@"savePanda" ofType:@"wav"];
            [KKGameData sharedGameData].score += 500;
            [hud updateScoreHUD];
            [littlePandas.littlePandas[i] removeFromParent];
            [littlePandas.littlePandas[i] removeAllActions];
            [littlePandas.littlePandas removeObject:littlePandas.littlePandas[i]];
            hud.littlePandaScore.text = [NSString stringWithFormat:@"x %lu",(unsigned long)[littlePandas.littlePandas count]];
            SKAction *labelMoveIn = [SKAction scaleTo:1.2 duration:0.2];
            SKAction *labelMoveOut = [SKAction scaleTo:1.0 duration:0.2];
            [hud.littlePandaScore runAction:[SKAction sequence:@[labelMoveIn, labelMoveOut]]];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    [panda moveOnHorizontalPlatforms:horizontalPlatforms withLastPlatformPositions:lastPlatformPositions];
    if (!isPause) {
        [super update:currentTime]; //Calls the Visualiser
        [self saveLittlePandas];
        [self pandaFallinWater];
        [littlePandas littlePandasMove];
        
        if (!panda.isFall && !panda.isDie) {
            if (isLeftMoveButton == YES) {
                panda.position = CGPointMake(panda.position.x - 5, panda.position.y);
            }
            if (isRightMoveButton == YES) {
                panda.position = CGPointMake(panda.position.x + 5, panda.position.y);
            }
        }
        // Score for coins
        for (int i = 0; i < [items.coins count]; i++) {
            if ([panda intersectsNode:items.coins[i]]) {
                [soundController playSoundNamed:@"coin" ofType:@"wav"];
                [KKGameData sharedGameData].score += 10;
                [hud updateScoreHUD];
                [self removeChildrenInArray:[NSArray arrayWithObjects:items.coins[i], nil]];
                [items.coins[i] removeAllActions];
                [items.coins removeObject:items.coins[i]];
            }
        }
        //Pick Up Hearts
        for (int i = 0; i < [items.pickUpHearts count]; i++) {
            if ([panda intersectsNode:items.pickUpHearts[i]]) {
                [soundController playSoundNamed:@"pickupheart" ofType:@"wav"];
                [KKGameData sharedGameData].score += 50;
                [hud updateScoreHUD];
                if ([KKGameData sharedGameData].numberOfLives < 3) {
                    [KKGameData sharedGameData].numberOfLives++;
                    [hud.hearts[[KKGameData sharedGameData].numberOfLives - 1] setTexture:
                     [SKTexture textureWithImageNamed:@"hud_heartFull"]];
                }
                [self removeChildrenInArray:[NSArray arrayWithObjects:items.pickUpHearts[i], nil]];
                [items.pickUpHearts removeObject:items.pickUpHearts[i]];
            }
        }
        //Pick Up Clocks
        for (int i = 0; i < [items.pickUpClocks count]; i++) {
            if ([panda intersectsNode:items.pickUpClocks[i]]) {
                [soundController playSoundNamed:@"pickupheart" ofType:@"wav"];
                [KKGameData sharedGameData].score += 50;
                [hud updateScoreHUD];
                [KKGameData sharedGameData].time -= 10;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"mm:ss"];
                NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[KKGameData sharedGameData].time];
                hud.time.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
                SKAction *labelMoveIn = [SKAction scaleTo:1.2 duration:0.2];
                SKAction *labelMoveOut = [SKAction scaleTo:1.0 duration:0.2];
                [hud.time runAction:[SKAction sequence:@[labelMoveIn, labelMoveOut]]];
                [self removeChildrenInArray:[NSArray arrayWithObjects:items.pickUpClocks[i], nil]];
                [items.pickUpClocks removeObject:items.pickUpClocks[i]];
            }
        }
        //Pick Up Stars
        for (int i = 0; i < [items.pickUpStars count]; i++) {
            if ([panda intersectsNode:items.pickUpStars[i]]) {
                [soundController playSoundNamed:@"pickupheart" ofType:@"wav"];
                [KKGameData sharedGameData].score += 200;
                [hud updateScoreHUD];
                //Animation for picked star
                NSMutableArray *textures = [NSMutableArray new];
                for (int i = 1; i <= 6; i++) {
                    [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"star0%i",i]]];
                }
                SKAction *starAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
                SKSpriteNode *pickedStar = [SKSpriteNode spriteNodeWithImageNamed:@"star01"];
                pickedStar.position = items.pickUpStars[i].position;
                pickedStar.zPosition = 5;
                [self addChild:pickedStar];
                [pickedStar runAction:starAnimation completion:^{
                    [pickedStar removeFromParent];
                }];
                [self removeChildrenInArray:[NSArray arrayWithObjects:items.pickUpStars[i], nil]];
                [items.pickUpStars removeObject:items.pickUpStars[i]];
            }
        }
        //Score for times
        static NSTimeInterval _lastCurrentTime = 0;
        if (currentTime-_lastCurrentTime>1 && !panda.isDie &&!panda.isFall && !isExit) {
            [KKGameData sharedGameData].time++;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"mm:ss"];
            NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[KKGameData sharedGameData].time];
            
            hud.time.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
            _lastCurrentTime = currentTime;
        }
        [self exit];
        [self enemies:enemies.bluesnails withIdleAnimationKey:@"BlueSnailIdleAnimation" withHurtAnimation:enemies.blueSnailHurtAnimation];
        [self enemies:enemies.redsnails withIdleAnimationKey:@"RedSnailIdleAnimation" withHurtAnimation:enemies.redSnailHurtAnimation];
        [self enemies:enemies.mushrooms withIdleAnimationKey:@"MushroomIdleAnimation" withHurtAnimation:enemies.mushroomHurtAnimation];
        [self flowersEnemies];
        if (!isExit) {
            [self flowersSpitMovingUpdate];
        }
        else {
            for (int i = 0; i < [enemies.flowersSpit count]; i++) {
                [enemies.flowersSpit[i] removeFromParent];
            }
        }
    }
}

- (void)pandaHurts {
    if ([KKGameData sharedGameData].numberOfLives > 0) {
        panda.isDie = NO;
        //play "oops" sound
        [soundController playSoundNamed:@"oops" ofType:@"wav"];
        [KKGameData sharedGameData].numberOfLives--;
        [hud updateHeartsHUD];
        if ([KKGameData sharedGameData].numberOfLives == 0) {
            panda.isDie = YES;
            isExit = YES;
            if (isLeftMoveButton) {
                isLeftMoveButton = NO;
                [hud.leftMoveButton setTexture:[SKTexture textureWithImageNamed:@"leftbutton"]];
            }
            if (isRightMoveButton) {
                isRightMoveButton = NO;
                [hud.rightMoveButton setTexture:[SKTexture textureWithImageNamed:@"rightbutton"]];
            }
            if (isJumpButton) {
                isJumpButton = NO;
                [hud.jumpButton setTexture:[SKTexture textureWithImageNamed:@"jumpbutton"]];
            }
            [soundController.backgroundGameMusic stop];
            [soundController playSoundNamed:@"lose_sound" ofType:@"mp3"];

            [panda runAction:panda.dieAnimation completion:^{
                panda.alpha = 0.0;
                [self endLevel:kEndReasonLose];
            }];
        }
        if (!panda.isDie) {
            panda.isHurt = YES;
            [panda hurt];
            if (isLeftMoveButton == YES || isRightMoveButton == YES || isJumpButton == YES) {
                [panda run];
            }
        }
    }
}

- (void)enemies:(NSMutableArray<SKSpriteNode *> *)enemiesArray withIdleAnimationKey:(NSString *)idleAnimationKey withHurtAnimation:(SKAction *)hurtAnimation {
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
            while ([enemiesArray[i] intersectsNode:borders[k]]) {
                if (enemiesArray[i].xScale < 0) {
                    enemiesArray[i].position = CGPointMake(enemiesArray[i].position.x + 0.15, enemiesArray[i].position.y);
                }
                else if (enemiesArray[i].xScale > 0) {
                    enemiesArray[i].position = CGPointMake(enemiesArray[i].position.x - 0.15, enemiesArray[i].position.y);
                }
            }
            if ([enemiesArray[i] intersectsNode:panda] && CGRectGetMinX(panda.frame) <= CGRectGetMaxX(enemiesArray[i].frame) && CGRectGetMaxX(panda.frame) >= CGRectGetMinX(enemiesArray[i].frame) && (CGRectGetMinY(enemiesArray[i].frame) - CGRectGetMinY(panda.frame) <= 3 && CGRectGetMinY(enemiesArray[i].frame) - CGRectGetMinY(panda.frame) >= -3)) {
                
                if ((enemiesArray[i].xScale < 0 && (panda.xScale < 0)) || (panda.xScale > 0 && panda.position.x > enemiesArray[i].position.x)) {
                    enemiesArray[i].xScale = 1.0*ABS(enemiesArray[i].xScale);
                }
                else if ((enemiesArray[i].xScale > 0 && panda.xScale > 0) || (panda.xScale < 0 && panda.position.x < enemiesArray[i].position.x)) {
                    enemiesArray[i].xScale = -1.0*ABS(enemiesArray[i].xScale);
                }
                if (!panda.isHurt && !panda.isDie) {
                    [self pandaHurts];
                }
            }
            //Killing enemy
            if ([enemiesArray[i] intersectsNode:panda] && CGRectGetMinY(panda.frame) >= CGRectGetMinY(enemiesArray[i].frame) + 20 && CGRectGetMinY(panda.frame) <= CGRectGetMaxY(enemiesArray[i].frame)) {
                
                [soundController playSoundNamed:@"jumpland" ofType:@"wav"];
                [enemiesArray[i] removeAllActions];
                SKSpriteNode *tempSnail = [SKSpriteNode new];
                tempSnail = enemiesArray[i];
                [enemiesArray removeObject:enemiesArray[i]];
                [KKGameData sharedGameData].score += 100;
                [hud updateScoreHUD];
                [tempSnail setPhysicsBody:NULL];
                [tempSnail runAction:hurtAnimation completion:^{
                    [tempSnail removeFromParent];
                    [tempSnail removeAllActions];
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

- (void)flowersSpitMovingUpdate {
    for (int i = 0; i < [enemies.flowersSpit count]; i++) {
        //Moving spits
        if (enemies.flowersSpit[i].xScale > 0) {
            enemies.flowersSpit[i].position = CGPointMake(enemies.flowersSpit[i].position.x - 5, enemies.flowersSpit[i].position.y);
        }
        else {
            enemies.flowersSpit[i].position = CGPointMake(enemies.flowersSpit[i].position.x + 5, enemies.flowersSpit[i].position.y);
        }
        //Intersecting spit with panda
        if ([panda intersectsNode:enemies.flowersSpit[i]] && !panda.isHurt &&!panda.isDie) {
            [self pandaHurts];
        }
        //Delete spits
        if (enemies.flowersSpit[i].position.x <= -200 || enemies.flowersSpit[i].position.x >= exitSign.position.x + 400) {
            [enemies.flowersSpit removeObject:enemies.flowersSpit[i]];
        }
    }
}

- (void)flowersEnemies {
    int i = 0;
    while (i < [enemies.flowers count]) {
        if (enemies.flowers[i].position.x >= camera.position.x - self.frame.size.width/2 && enemies.flowers[i].position.x <= camera.position.x + self.frame.size.width/2 && enemies.isFlowerAttackAnimation[i] == [NSNumber numberWithInteger:0] && !isExit) {
            
            enemies.isFlowerAttackAnimation[i] = [NSNumber numberWithInteger:1];
            [soundController playSoundNamed:@"spitting" ofType:@"wav"];
            [enemies.flowers[i] runAction:[enemies attackAnimationForFlower:enemies.flowers[i] inScene:self] completion:^{
                enemies.isFlowerAttackAnimation[i] = [NSNumber numberWithInteger:0];
            }];
        }
        if (panda.position.x < enemies.flowers[i].position.x) {
            enemies.flowers[i].xScale = 1.0*ABS(enemies.flowers[i].xScale);
        }
        else {
            enemies.flowers[i].xScale = -1.0*ABS(enemies.flowers[i].xScale);
        }
        //Intersecting panda and enemy
        if ([enemies.flowers[i] intersectsNode:panda] && CGRectGetMinX(panda.frame) <= CGRectGetMaxX(enemies.flowers[i].frame) && CGRectGetMaxX(panda.frame) >= CGRectGetMinX(enemies.flowers[i].frame) && CGRectGetMaxX(panda.frame) - CGRectGetMinX(enemies.flowers[i].frame) >= 20 && (CGRectGetMinY(enemies.flowers[i].frame) - CGRectGetMinY(panda.frame) <= 3 && CGRectGetMinY(enemies.flowers[i].frame) - CGRectGetMinY(panda.frame) >= -6) && !panda.isHurt && !panda.isDie) {
            
            [self pandaHurts];
        }
        //Killing enemy
        if ([enemies.flowers[i] intersectsNode:panda] && CGRectGetMinY(panda.frame) >= CGRectGetMaxY(enemies.flowers[i].frame) - 20 ) {
            
            [soundController playSoundNamed:@"jumpland" ofType:@"wav"];
            
            [enemies.flowers[i] removeAllActions];
            
            SKSpriteNode *tempSnail = [SKSpriteNode new];
            tempSnail = enemies.flowers[i];

            [enemies.isFlowerAttackAnimation removeObject:enemies.isFlowerAttackAnimation[i]];
            [enemies.flowers removeObject:enemies.flowers[i]];
            [KKGameData sharedGameData].score += 100;
            [hud updateScoreHUD];
            [tempSnail setPhysicsBody:NULL];
            [tempSnail runAction:enemies.flowerHurtAnimation completion:^{
                [tempSnail removeFromParent];
                [tempSnail removeAllActions];
            }];
            //break;
        }
        i++;
    }
}

- (void)exit {
    static NSTimeInterval lastCurrentTime = 0;
    SKEmitterNode *particleExit = (SKEmitterNode *)[self childNodeWithName:@"particleExit"];
    if ([littlePandas.littlePandas count] == 0) {
        particleExit.alpha = 1.0;
    }
    else {
        particleExit.alpha = 0.0;
    }
    if (panda.position.x > (particleExit.position.x - 25) && panda.position.x < (particleExit.position.x + 25)) {
        if ([panda actionForKey:@"JumpAnimation"] == nil && [panda actionForKey:@"MoveAnimation"] == nil) {
            lastCurrentTime += 1;
            if (lastCurrentTime >= 30 && !isExit && [littlePandas.littlePandas count] == 0) {
                lastCurrentTime = 0;
                isExit = YES;
                [soundController playSoundNamed:@"win_sound" ofType:@"wav"];
                [panda runAction:[SKAction waitForDuration:0.8] completion:^{
                    [self endLevel:kEndReasonWin];
                }];
            }
        }
    }
}

- (void)endLevel:(EndReason)endReason {
    
    isExit = YES;
    if (endReason == kEndReasonWin) {
        [KKGameData sharedGameData].totalScore += [KKGameData sharedGameData].score;
        if ([KKGameData sharedGameData].completeLevels == [KKGameData sharedGameData].currentLevel - 1) {
            [KKGameData sharedGameData].completeLevels += 1;
        }
    }
    [[KKGameData sharedGameData] save];
    long tempScore = [KKGameData sharedGameData].score;
    long tempTime = [KKGameData sharedGameData].time;
    [[KKGameData sharedGameData] reset];
    
    [soundController.backgroundGameMusic stop];
    
    if (endReason == kEndReasonWin) {
        //Achievements
        if (![KKGameData sharedGameData].is30secAchievement && tempTime <= 30) {
            [KKGameData sharedGameData].is30secAchievement = YES;
            NSString *achievement = [NSString stringWithFormat:@"30secAchievement"];
            [windowController addAchievement:achievement forScene:self withCamera:camera];
        }
        if (![KKGameData sharedGameData].is60secAchievement && tempTime <= 60 && tempTime > 30) {
            [KKGameData sharedGameData].is60secAchievement = YES;
            NSString *achievement = [NSString stringWithFormat:@"60secAchievement"];
            [windowController addAchievement:achievement forScene:self withCamera:camera];
        }
        if (![KKGameData sharedGameData].is1millionPointsAchievement && [KKGameData sharedGameData].totalScore >= 1000000) {
            [KKGameData sharedGameData].is1millionPointsAchievement = YES;
            NSString *achievement = [NSString stringWithFormat:@"1millionPointsAchievement"];
            [windowController addAchievement:achievement forScene:self withCamera:camera];
        }
        if (![KKGameData sharedGameData].isAllLevelsAchievement && [KKGameData sharedGameData].completeLevels == [KKGameData sharedGameData].numberOfLevels) {
            [KKGameData sharedGameData].isAllLevelsAchievement = YES;
            NSString *achievement = [NSString stringWithFormat:@"AllLevelsAchievement"];
            [windowController addAchievement:achievement forScene:self withCamera:camera];
        }
        if (![KKGameData sharedGameData].isDestroyAllEnemiesAchievement && [enemies.bluesnails count] == 0 && [enemies.redsnails count] == 0 && [enemies.mushrooms count] == 0 && [enemies.flowers count] == 0 ) {
            [KKGameData sharedGameData].isDestroyAllEnemiesAchievement = YES;
            NSString *achievement = [NSString stringWithFormat:@"DestroyAllEnemiesAchievement"];
            [windowController addAchievement:achievement forScene:self withCamera:camera];
        }
        [[KKGameData sharedGameData] save];
        [windowController setupWinWindowForScene:self withCamera:camera winTime:tempTime winScore:tempScore andPickedUpStars:items.pickUpStars];
    }
    else if (endReason == kEndReasonLose) {
        [windowController setupLoseWindowForScene:self withCamera:camera];
    }
}

@end
