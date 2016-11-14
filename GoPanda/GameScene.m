//
//  GameScene.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 07.06.16.
//  Copyright (c) 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameScene.h"
#import "MenuScenesController.h"
#import "KKGameData.h"
#import "GameViewController.h"

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
GameItems *items;
GameSceneWindows *windowController;

SKNode *exitSign;
SKCameraNode *camera;

NSMutableArray<SKSpriteNode *> *bluesnails;
NSMutableArray<SKSpriteNode *> *redsnails;
NSMutableArray<SKSpriteNode *> *mushrooms;
NSMutableArray<SKSpriteNode *> *flowers;
NSMutableArray<SKSpriteNode *> *flowersSpit;
NSMutableArray *isFlowerAttackAnimation;
NSMutableArray<SKSpriteNode *> *borders;

NSMutableArray<SKSpriteNode *> *horizontalPlatforms;
NSMutableArray *lastPlatformPositions;

NSMutableArray<SKSpriteNode *> *waters;
NSMutableArray<SKSpriteNode *> *littlePandas;
NSMutableArray<SKSpriteNode *> *littlePandasMoving;
NSMutableArray<NSNumber *> *littlePandasMoveStartPosition;

AVAudioPlayer *backgroundGameMusic;
AVAudioPlayer *sound;
NSMutableArray *soundsArray;

-(void)didMoveToView:(SKView *)view {
    
    soundsArray = [NSMutableArray new];
    
    isLeftMoveButton = NO;
    isRightMoveButton = NO;
    isJumpButton = NO;
    
    isExit = NO;
    isPause = NO;
    
    level = [KKGameData sharedGameData].currentLevel;
    
    //Set background music
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mainTheme" ofType:@"mp3"];
    backgroundGameMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    backgroundGameMusic.delegate = self;
    backgroundGameMusic.numberOfLoops = -1;
    backgroundGameMusic.volume = [KKGameData sharedGameData].musicVolume;
    [backgroundGameMusic play];
    
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
    
    
    //Create blue snails idle animation
    NSMutableArray<SKTexture *> *textures = [NSMutableArray new];
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
    
    items = [[GameItems alloc]init];
    [items setupItemsForScene:self];
    
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
    isFlowerAttackAnimation = [NSMutableArray new];
    for (NSInteger i = 0; i < [flowers count] + 10; i++) {
        [isFlowerAttackAnimation addObject:[NSNumber numberWithInteger:0]];
    }
    
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
        SKLabelNode *warningLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
        warningLabel.fontSize = 58.0;
        warningLabel.position = CGPointMake(-0, 0);
        warningLabel.fontColor = [SKColor blackColor];
        warningLabel.zPosition = 1000;
        warningLabel.alpha = 0.6;
        warningLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [camera addChild:warningLabel];
        warningLabel.text = @"Rescue all little pandas to open exit";
        SKAction *labelMoveIn = [SKAction scaleTo:1.0 duration:6];
        SKAction *labelMoveOut = [SKAction scaleTo:0.0 duration:1];
        [warningLabel runAction:[SKAction sequence:@[labelMoveIn, labelMoveOut]]];
    }
    
}

- (void)playSoundNamed:(NSString *)soundName ofType:(NSString *)soundType {
    for (int i = 0; i < [soundsArray count]; i++) {
        if (![soundsArray[i] isPlaying]) {
            [soundsArray removeObject:soundsArray[i]];
        }
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:soundName ofType:soundType];
    sound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    sound.volume = [KKGameData sharedGameData].soundVolume;
    sound.numberOfLoops = 0;
    [sound prepareToPlay];
    [sound play];
    [soundsArray addObject:sound];
    
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
        backgroundGameMusic.volume = [KKGameData sharedGameData].musicVolume;
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
            [backgroundGameMusic stop];
            [[KKGameData sharedGameData] reset];
            [[[GameViewController alloc]init]playMenuBackgroundMusic];
            scene = [MenuScenesController nodeWithFileNamed:@"GameStart"];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }
        else if ([node.name isEqualToString:@"levelsbutton"]) {
            [backgroundGameMusic stop];
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



- (void)pandaFallinWater {
    for (int i = 0; i < [waters count]; i++) {
        if ([panda intersectsNode:waters[i]] && panda.position.y <= 150) {
            isExit = YES;
            if (!panda.isFall) {
                
                for (int i = 0; i < [hud.hearts count];i++) {
                    [hud.hearts[i] setTexture:[SKTexture textureWithImageNamed:@"hud_heartEmpty"]];
                }
                
                [backgroundGameMusic stop];
                [self playSoundNamed:@"lose_sound" ofType:@"mp3"];
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
    for (int i = 0; i < [littlePandas count]; i++) {
        if ([panda intersectsNode:littlePandas[i]]) {
            [self playSoundNamed:@"savePanda" ofType:@"wav"];

            [KKGameData sharedGameData].score += 500;
            [hud updateScoreHUD];
            [littlePandas[i] removeFromParent];
            [littlePandas[i] removeAllActions];
            [littlePandas removeObject:littlePandas[i]];
            hud.littlePandaScore.text = [NSString stringWithFormat:@"x %lu",(unsigned long)[littlePandas count]];
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
        
        [self littlePandasMove];
        
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
                [self playSoundNamed:@"coin" ofType:@"wav"];
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
                [self playSoundNamed:@"pickupheart" ofType:@"wav"];
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
                [self playSoundNamed:@"pickupheart" ofType:@"wav"];
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
                [self playSoundNamed:@"pickupheart" ofType:@"wav"];
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
        
        [self enemies:bluesnails withIdleAnimationKey:@"BlueSnailIdleAnimation" withHurtAnimation:self.blueSnailHurtAnimation];
        [self enemies:redsnails withIdleAnimationKey:@"RedSnailIdleAnimation" withHurtAnimation:self.redSnailHurtAnimation];
        [self enemies:mushrooms withIdleAnimationKey:@"MushroomIdleAnimation" withHurtAnimation:self.mushroomHurtAnimation];
        [self flowersEnemies];
        
        if (!isExit) {
            [self spitMovingUpdate];
        }
        else {
            for (int i = 0; i < [flowersSpit count]; i++) {
                [flowersSpit[i] removeFromParent];
            }
        }
    }
}

//BOOL isDieAnimation;

- (void)pandaHurts {
    if ([KKGameData sharedGameData].numberOfLives > 0) {
        panda.isDie = NO;
        
        //play "oops" sound
        [self playSoundNamed:@"oops" ofType:@"wav"];
        
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
            
            [backgroundGameMusic stop];
            [self playSoundNamed:@"lose_sound" ofType:@"mp3"];

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
                
                [self playSoundNamed:@"jumpland" ofType:@"wav"];

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
    [self playSoundNamed:@"spitting" ofType:@"wav"];
    [spit runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5f], [SKAction fadeAlphaTo:1 duration:0.0f]]]];
    
    self.flowerAttackAnimation = [SKAction sequence:@[[SKAction repeatAction:[SKAction animateWithTextures:textures timePerFrame:0.1] count:1], [SKAction waitForDuration:2.0f]]];
    
    [flowersSpit addObject:spit];
    
    return self.flowerAttackAnimation;
}

- (void)spitMovingUpdate {
    for (int i = 0; i < [flowersSpit count]; i++) {
        //Moving spits
        if (flowersSpit[i].xScale > 0) {
            flowersSpit[i].position = CGPointMake(flowersSpit[i].position.x - 5, flowersSpit[i].position.y);
        }
        else {
            flowersSpit[i].position = CGPointMake(flowersSpit[i].position.x + 5, flowersSpit[i].position.y);
        }
        
        //Intersecting spit with panda
        if ([panda intersectsNode:flowersSpit[i]] && !panda.isHurt &&!panda.isDie) {
            [self pandaHurts];
        }
        
        //Delete spits
        if (flowersSpit[i].position.x <= -200 || flowersSpit[i].position.x >= exitSign.position.x + 400) {
            [flowersSpit removeObject:flowersSpit[i]];
        }
    }
}

- (void)flowersEnemies {
    int i = 0;
    
    while (i < [flowers count]) {
        
        if (flowers[i].position.x >= camera.position.x - self.frame.size.width/2 && flowers[i].position.x <= camera.position.x + self.frame.size.width/2 && isFlowerAttackAnimation[i] == [NSNumber numberWithInteger:0] && !isExit) {
            
            isFlowerAttackAnimation[i] = [NSNumber numberWithInteger:1];
            [flowers[i] runAction:[self attackAnimationForFlower:flowers[i]] completion:^{
                isFlowerAttackAnimation[i] = [NSNumber numberWithInteger:0];
            }];
        }
        
        if (panda.position.x < flowers[i].position.x) {
            flowers[i].xScale = 1.0*ABS(flowers[i].xScale);
        }
        else {
            flowers[i].xScale = -1.0*ABS(flowers[i].xScale);
        }
        
        //Intersecting panda and enemy
        if ([flowers[i] intersectsNode:panda] && CGRectGetMinX(panda.frame) <= CGRectGetMaxX(flowers[i].frame) && CGRectGetMaxX(panda.frame) >= CGRectGetMinX(flowers[i].frame) && CGRectGetMaxX(panda.frame) - CGRectGetMinX(flowers[i].frame) >= 20 && (CGRectGetMinY(flowers[i].frame) - CGRectGetMinY(panda.frame) <= 3 && CGRectGetMinY(flowers[i].frame) - CGRectGetMinY(panda.frame) >= -6) && !panda.isHurt && !panda.isDie) {
            
            [self pandaHurts];
        }
        
        //Killing enemy
        if ([flowers[i] intersectsNode:panda] && CGRectGetMinY(panda.frame) >= CGRectGetMaxY(flowers[i].frame) - 20 ) {
            
            [self playSoundNamed:@"jumpland" ofType:@"wav"];
            
            [flowers[i] removeAllActions];
            
            SKSpriteNode *tempSnail = [SKSpriteNode new];
            tempSnail = flowers[i];

            [isFlowerAttackAnimation removeObject:isFlowerAttackAnimation[i]];
            [flowers removeObject:flowers[i]];
            [KKGameData sharedGameData].score += 100;
            [hud updateScoreHUD];
            [tempSnail setPhysicsBody:NULL];
            [tempSnail runAction:self.flowerHurtAnimation completion:^{
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
    if ([littlePandas count] == 0) {
        particleExit.alpha = 1.0;
    }
    else {
        particleExit.alpha = 0.0;
    }
    if (panda.position.x > (particleExit.position.x - 25) && panda.position.x < (particleExit.position.x + 25)) {
        if ([panda actionForKey:@"JumpAnimation"] == nil && [panda actionForKey:@"MoveAnimation"] == nil) {
            lastCurrentTime += 1;
            if (lastCurrentTime >= 30 && !isExit && [littlePandas count] == 0) {
                lastCurrentTime = 0;
                isExit = YES;
                [self playSoundNamed:@"win_sound" ofType:@"wav"];
                [panda runAction:[SKAction waitForDuration:0.8] completion:^{
                    [self endLevel:kEndReasonWin];
                }];
            }
        }
    }
}

- (void)addAchievementLabel:(NSString *)achievement {
    SKSpriteNode *achievementBadge = [SKSpriteNode spriteNodeWithImageNamed:achievement];
    achievementBadge.zPosition = 1010;
    achievementBadge.position = CGPointMake(camera.position.x + 214.637, 365);
    achievementBadge.scale = 0.5;
    achievementBadge.alpha = 1.0;
    [self addChild:achievementBadge];
    
    SKLabelNode *newLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    newLabel.fontSize = 40.0;
    newLabel.position = CGPointMake(camera.position.x + 288.602, 484.414);
    newLabel.zPosition = 1010;
    newLabel.fontColor = [SKColor redColor];
    newLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    newLabel.text = @"New";
    newLabel.zRotation = 326;
    newLabel.alpha = 1.0;
    [self addChild:newLabel];
    
    SKLabelNode *achievementLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    achievementLabel.fontSize = 40.0;
    achievementLabel.position = CGPointMake(camera.position.x +  266.253, 446.547);
    achievementLabel.zPosition = 1010;
    achievementLabel.fontColor = [SKColor redColor];
    achievementLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    achievementLabel.text = @"Achievement!";
    achievementLabel.zRotation = 326;
    achievementLabel.alpha = 1.0;
    [self addChild:achievementLabel];
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
    long k = [KKGameData sharedGameData].score;
    long t = [KKGameData sharedGameData].time;
    [[KKGameData sharedGameData] reset];
    
    [backgroundGameMusic stop];
    
    if (endReason == kEndReasonWin) {
        
        //Achievements
        if (![KKGameData sharedGameData].is30secAchievement && t <= 30) {
            [KKGameData sharedGameData].is30secAchievement = YES;
            NSString *achievement = [NSString stringWithFormat:@"30secAchievement"];
            [self addAchievementLabel:achievement];
        }
        
        if (![KKGameData sharedGameData].is60secAchievement && t <= 60 && t > 30) {
            [KKGameData sharedGameData].is60secAchievement = YES;
            NSString *achievement = [NSString stringWithFormat:@"60secAchievement"];
            [self addAchievementLabel:achievement];
        }
        
        if (![KKGameData sharedGameData].is1millionPointsAchievement && [KKGameData sharedGameData].totalScore >= 1000000) {
            [KKGameData sharedGameData].is1millionPointsAchievement = YES;
            NSString *achievement = [NSString stringWithFormat:@"1millionPointsAchievement"];
            [self addAchievementLabel:achievement];
        }
        
        if (![KKGameData sharedGameData].isAllLevelsAchievement && [KKGameData sharedGameData].completeLevels == [KKGameData sharedGameData].numberOfLevels) {
            [KKGameData sharedGameData].isAllLevelsAchievement = YES;
            NSString *achievement = [NSString stringWithFormat:@"AllLevelsAchievement"];
            [self addAchievementLabel:achievement];
        }
        
        if (![KKGameData sharedGameData].isDestroyAllEnemiesAchievement && [bluesnails count] == 0 && [redsnails count] == 0 && [mushrooms count] == 0 && [flowers count] == 0 ) {
            [KKGameData sharedGameData].isDestroyAllEnemiesAchievement = YES;
            NSString *achievement = [NSString stringWithFormat:@"DestroyAllEnemiesAchievement"];
            [self addAchievementLabel:achievement];
        }
        [[KKGameData sharedGameData] save];
        
        [windowController setupWinWindowForScene:self withCamera:camera winTime:t winScore:k andPickedUpStars:items.pickUpStars];
        
    }
    else if (endReason == kEndReasonLose) {
        [windowController setupLoseWindowForScene:self withCamera:camera];
    }
}

@end
