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

//BOOL isHurtAnimationRunning; //Delete
//BOOL isPandaFall;  //Delete
//BOOL isPandaJump;  //Delete
BOOL isExit;
BOOL isPause;
float lastCameraPosition;
int level;

//SKSpriteNode *panda; // Delete
//Panda *panda;

SKNode *exitSign;
SKSpriteNode *pauseButton;
SKCameraNode *camera;
NSMutableArray<SKSpriteNode *> *coins;
NSMutableArray<SKSpriteNode *> *pickUpHearts;
NSMutableArray<SKSpriteNode *> *pickUpClocks;
NSMutableArray<SKSpriteNode *> *pickUpStars;

NSMutableArray<SKSpriteNode *> *hearts;

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
SKSpriteNode *leftMoveButton;
SKSpriteNode *rightMoveButton;
SKSpriteNode *jumpButton;

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
    
//    isPandaFall = NO;  //Delete
//    isDieAnimation = NO;  //Delete
//    isPandaJump = NO;  //Delete
//    isHurtAnimationRunning = NO;  //Delete
    
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
    
    
    
    //Add Panda Character

//    //Create Panda run animation //Delete
//    NSMutableArray<SKTexture *> *textures = [NSMutableArray new];
//    for (int i = 0; i <= 5; i++) {
//        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Run_00%i",i]]];
//    }
//    self.runAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
//    
//    //Create Panda jump animation //Delete
//    textures = [NSMutableArray new];
//    for (int i = 0; i <= 9; i++) {
//        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Jump2_00%i",i]]];
//    }
//    self.jumpAnimation = [SKAction animateWithTextures:textures timePerFrame:0.04];
//    
//    //Create Panda idle animation //Delete
//    textures = [NSMutableArray new];
//    for (int i = 0; i <= 9; i++) {
//        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Idle_00%i",i]]];
//    }
//    self.idleAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
//    
//    // Create Panda hurt animation //Delete
//    textures = [NSMutableArray new];
//    for (int i = 0; i <= 1; i++) {
//        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Hurt_00%i", i]]];
//    }
//    self.hurtAnimation = [SKAction sequence:@[[SKAction repeatAction:[SKAction animateWithTextures:textures timePerFrame:0.1] count:1], [SKAction repeatAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.6 duration:0.15], [SKAction fadeAlphaTo:1.0 duration:0.15]]] count:4]]];
//    
//    // Create Panda die animation //Delete
//    textures = [NSMutableArray new];
//    for (int i = 1; i <= 9; i++) {
//        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Die_00%i", i]]];
//    }
//    self.dieAnimation = [SKAction sequence:@[[SKAction repeatAction:[SKAction animateWithTextures:textures timePerFrame:0.2] count:1]]];
    
    //Create Coin animation
    NSMutableArray<SKTexture *> *textures = [NSMutableArray new];
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
    
    //Init Panda
    self.panda = [Panda initPanda];
    self.panda = (Panda *)[self childNodeWithName:@"Panda"];
    [self.panda didLoadPanda];
    [self.panda idle];
    
    //Create camera
    camera = (SKCameraNode *)[self childNodeWithName:@"MainCamera"];
    id horizConstraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:0] toNode:self.panda];
    id vertConstraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:0] toNode:self.panda];
    id leftConstraint = [SKConstraint positionX:[SKRange rangeWithLowerLimit:camera.position.x]];
    id bottomConstraint = [SKConstraint positionY:[SKRange rangeWithLowerLimit:camera.position.y]];
    id rightConstraint = [SKConstraint positionX:[SKRange rangeWithUpperLimit:(exitSign.position.x + 200 - camera.position.x)]];
    id topConstraint = [SKConstraint positionY:[SKRange rangeWithUpperLimit:(_background.frame.size.height - 10 - camera.position.y)]];
    [camera setConstraints:@[horizConstraint, vertConstraint, leftConstraint, bottomConstraint, rightConstraint, topConstraint]];
    
    //Add moving buttons to screen
    //left move button
    leftMoveButton = [SKSpriteNode spriteNodeWithImageNamed:@"leftbutton"];
    leftMoveButton.alpha = 0.5;
    leftMoveButton.scale = 0.8;
    leftMoveButton.position = CGPointMake(-440, -218);
    leftMoveButton.zPosition = 20;
    leftMoveButton.name = @"leftMoveButton";
    [camera addChild:leftMoveButton];
    //right move button
    rightMoveButton = [SKSpriteNode spriteNodeWithImageNamed:@"rightbutton"];
    rightMoveButton.alpha = 0.5;
    rightMoveButton.scale = 0.8;
    rightMoveButton.position = CGPointMake(-280, -218);
    rightMoveButton.zPosition = 20;
    rightMoveButton.name = @"rightMoveButton";
    [camera addChild:rightMoveButton];
    //jump button
    jumpButton = [SKSpriteNode spriteNodeWithImageNamed:@"jumpbutton"];
    jumpButton.alpha = 0.5;
    jumpButton.scale = 0.8;
    jumpButton.position = CGPointMake(440, -218);
    jumpButton.zPosition = 20;
    jumpButton.name = @"jumpButton";
    [camera addChild:jumpButton];
    
    //Pause Button
    pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"pauseButtonOff"];
    pauseButton.size = CGSizeMake(91, 95);
    pauseButton.position = CGPointMake(460, 230);
    pauseButton.alpha = 0.8;
    pauseButton.zPosition = 100;
    pauseButton.name = @"pauseButton";
    [camera addChild:pauseButton]; 
    
    if ([KKGameData sharedGameData].numberOfLives == 0) {
        [KKGameData sharedGameData].numberOfLives = 3;
    }
    //Score
    [self setupHUD];
    _score.text = [NSString stringWithFormat:@"%li", [KKGameData sharedGameData].totalScore];
    _time.text = @"00:00";
    _littlePandaScore.text = @"x 3";
    
    
    //Setup array of coins
    coins = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"coin"]) {
            [child runAction:self.coinAnimation withKey:@"CoinAnimation"];
            [coins addObject:child];
        }
    }
    
    //Setup array of pickUpHearts
    pickUpHearts = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"heart"]) {
            [pickUpHearts addObject:child];
        }
    }
    
    //Setup array of pickUpClocks
    pickUpClocks = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"clock"]) {
            [pickUpClocks addObject:child];
        }
    }
    
    //Setup array of pickUpStars
    pickUpStars = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"star"]) {
            [pickUpStars addObject:child];
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

//Score
SKLabelNode* _score;
SKLabelNode* _littlePandaScore;
SKLabelNode* _time;

-(void)setupHUD
{
    SKSpriteNode *littlePanda = [SKSpriteNode spriteNodeWithImageNamed:@"littlePandaEat_02"];
    littlePanda.position = CGPointMake(-280, 265);
    littlePanda.zPosition = 1000;
    littlePanda.name = [NSString stringWithFormat:@"littlePanda"];
    littlePanda.scale = 1;
    [camera addChild:littlePanda];
    
    _littlePandaScore = [[SKLabelNode alloc] initWithFontNamed:@"MarkerFelt-Wide"];
    _littlePandaScore.fontSize = 35.0;
    _littlePandaScore.position = CGPointMake(-242, 252);
    _littlePandaScore.fontColor = [SKColor blackColor];
    _littlePandaScore.zPosition = 1000;
    _littlePandaScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [camera addChild:_littlePandaScore];
    
    _score = [[SKLabelNode alloc] initWithFontNamed:@"MarkerFelt-Wide"];
    _score.fontSize = 30.0;
    _score.position = CGPointMake(-497, 155);
    _score.fontColor = [SKColor blackColor];
    _score.zPosition = 1000;
    _score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [camera addChild:_score];
    
    SKSpriteNode *clock = [SKSpriteNode spriteNodeWithImageNamed:@"clock"];
    clock.position = CGPointMake(-480, 215);
    clock.zPosition = 1000;
    clock.name = [NSString stringWithFormat:@"clock"];
    clock.scale = 0.5;
    [camera addChild:clock];
    _time = [[SKLabelNode alloc] initWithFontNamed:@"MarkerFelt-Wide"];
    _time.fontSize = 30.0;
    _time.position = CGPointMake(-445, 203);
    _time.zPosition = 1000;
    _time.fontColor = [SKColor blueColor];
    _time.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [camera addChild:_time];
    
    //heart's nodes
    hearts = [NSMutableArray new];
    for (int i = 0; i < [KKGameData sharedGameData].numberOfLives; i++) {
        SKSpriteNode *heart = [SKSpriteNode spriteNodeWithImageNamed:@"hud_heartFull"];
        heart.position = CGPointMake(-480 + i*50, 265);
        heart.zPosition = 1000;
        heart.name = [NSString stringWithFormat:@"heart%i",i];
        heart.scale = 0.8;
        [camera addChild:heart];
        [hearts insertObject:heart atIndex:i];
    }
}

- (void)updateScoreHUD {
    _score.text = [NSString stringWithFormat:@"%li", [KKGameData sharedGameData].score + [KKGameData sharedGameData].totalScore];
    SKAction *labelMoveIn = [SKAction scaleTo:1.2 duration:0.2];
    SKAction *labelMoveOut = [SKAction scaleTo:1.0 duration:0.2];
    [_score runAction:[SKAction sequence:@[labelMoveIn, labelMoveOut]]];
}

- (void)updateHeartsHUD {
    //update hearts
    if ([KKGameData sharedGameData].numberOfLives < [hearts count]) {
        [hearts[[KKGameData sharedGameData].numberOfLives] setTexture:[SKTexture textureWithImageNamed:@"hud_heartEmpty"]];
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
SKSpriteNode *pauseWindow;
SKLabelNode *pausedLabel;
SKSpriteNode *pauseMusicButton;
SKSpriteNode *pauseSoundButton;
SKSpriteNode *pauseResumeButton;
SKSpriteNode *pauseRestartButton;
SKSpriteNode *pauseHomeButton;
SKSpriteNode *pauseLevelsButton;

- (void)setupPauseWindow {
    pauseWindow = [SKSpriteNode spriteNodeWithImageNamed:@"pausewindow"];
    pauseWindow.zPosition = 1000;
    pauseWindow.position = CGPointMake(camera.position.x, 385);
    pauseWindow.scale = 0.8;
    
    pausedLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    pausedLabel.fontSize = 55.0;
    pausedLabel.position = CGPointMake(camera.position.x, 583);
    pausedLabel.zPosition = 1002;
    pausedLabel.fontColor = [SKColor whiteColor];
    pausedLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    pausedLabel.text = @"Paused";
    
    if ([KKGameData sharedGameData].isMusicON == YES) {
        pauseMusicButton = [SKSpriteNode spriteNodeWithImageNamed:@"musicbutton_on"];
    }
    else {
        pauseMusicButton = [SKSpriteNode spriteNodeWithImageNamed:@"musicbutton_off"];
    }
    pauseMusicButton.zPosition = 1001;
    pauseMusicButton.position = CGPointMake(camera.position.x - 49, 485);
    pauseMusicButton.scale = 0.4;
    pauseMusicButton.name = @"pauseMusicButton";
    
    if ([KKGameData sharedGameData].isSoundON == YES) {
        pauseSoundButton = [SKSpriteNode spriteNodeWithImageNamed:@"soundbutton_on"];
    }
    else {
        pauseSoundButton = [SKSpriteNode spriteNodeWithImageNamed:@"soundbutton_off"];
    }
    pauseSoundButton.zPosition = 1001;
    pauseSoundButton.position = CGPointMake(camera.position.x + 49, 485);
    pauseSoundButton.scale = 0.4;
    pauseSoundButton.name = @"pauseSoundButton";
    
    pauseResumeButton = [SKSpriteNode spriteNodeWithImageNamed:@"resumeButton"];
    pauseResumeButton.zPosition = 1001;
    pauseResumeButton.position = CGPointMake(camera.position.x, 404);
    pauseResumeButton.scale = 0.4;
    pauseResumeButton.name = @"pauseButton";
    
    pauseRestartButton = [SKSpriteNode spriteNodeWithImageNamed:@"restartButton"];
    pauseRestartButton.zPosition = 1001;
    pauseRestartButton.position = CGPointMake(camera.position.x, 324);
    pauseRestartButton.scale = 0.4;
    pauseRestartButton.name = @"restartbutton";
    
    pauseHomeButton = [SKSpriteNode spriteNodeWithImageNamed:@"blueHomeButton"];
    pauseHomeButton.zPosition = 1001;
    pauseHomeButton.position = CGPointMake(camera.position.x - 49, 244);
    pauseHomeButton.scale = 0.4;
    pauseHomeButton.name = @"homebutton";
    
    pauseLevelsButton = [SKSpriteNode spriteNodeWithImageNamed:@"blueLevelButton"];
    pauseLevelsButton.zPosition = 1001;
    pauseLevelsButton.position = CGPointMake(camera.position.x + 49, 244);
    pauseLevelsButton.scale = 0.4;
    pauseLevelsButton.name = @"levelsbutton";
    
    [self addChild:pauseWindow];
    [self addChild:pausedLabel];
    [self addChild:pauseMusicButton];
    [self addChild:pauseSoundButton];
    [self addChild:pauseResumeButton];
    [self addChild:pauseRestartButton];
    [self addChild:pauseHomeButton];
    [self addChild:pauseLevelsButton];
}
- (void)removePauseWindow {
    [pauseWindow removeFromParent];
    [pausedLabel removeFromParent];
    [pauseMusicButton removeFromParent];
    [pauseSoundButton removeFromParent];
    [pauseResumeButton removeFromParent];
    [pauseRestartButton removeFromParent];
    [pauseHomeButton removeFromParent];
    [pauseLevelsButton removeFromParent];
}

const int kMoveSpeed = 200;
//static const NSTimeInterval kHugeTime = 9999.0;

BOOL isLeftMoveButton;
BOOL isRightMoveButton;
BOOL isJumpButton;
BOOL isSecondTouchJumpButton;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    if (!self.panda.isFall && !self.panda.isDie && !isExit && !isPause) {
        if ([node.name isEqualToString:@"jumpButton"]) {
            if (!self.panda.isJump) {
                //Jump
                [jumpButton setTexture:[SKTexture textureWithImageNamed:@"greenjumpbutton"]];
                isJumpButton = YES;
                self.panda.isJump = YES;
                [self.panda removePandaActionForKey:@"MoveAnimation"];
                SKAction *jumpMove = [SKAction applyImpulse:CGVectorMake(0, 200) duration:0.1];
                [self.panda runAction:[SKAction sequence:@[jumpMove, _panda.jumpAnimation]] completion:^{
                    self.panda.isJump = NO;
                    if (isLeftMoveButton == YES || isRightMoveButton == YES) {
                        [self.panda runAction:self.panda.runAnimation withKey:@"MoveAnimation"];
                    }
                }];
            }
            else {
                isSecondTouchJumpButton = YES;
            }
        }
        
        if ([node.name isEqualToString:@"leftMoveButton"]) {
            //left move
            [leftMoveButton setTexture:[SKTexture textureWithImageNamed:@"greenleftbutton"]];
            isLeftMoveButton = YES;
            [self.panda leftMove];
            [self.panda run];
            
        }
        if ([node.name isEqualToString:@"rightMoveButton"]) {
            //right move
            [rightMoveButton setTexture:[SKTexture textureWithImageNamed:@"greenrightbutton"]];
            isRightMoveButton = YES;
            [self.panda rightMove];
            [self.panda run];
        }
    }
    
    //Touch Pause Button
    if ([node.name isEqualToString:@"pauseButton"] && !isExit) {
        if (isPause) {
            isPause = NO;
            [self removePauseWindow];
            pauseButton.texture = [SKTexture textureWithImageNamed:@"pauseButtonOff"];
        }
        else {
            isPause = YES;
            [self setupPauseWindow];
            pauseButton.texture = [SKTexture textureWithImageNamed:@"pauseButtonOn"];
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
            
            [leftMoveButton setTexture:[SKTexture textureWithImageNamed:@"greenleftbutton"]];
            [rightMoveButton setTexture:[SKTexture textureWithImageNamed:@"rightbutton"]];

            //left move
            isLeftMoveButton = YES;
            isRightMoveButton = NO;
            [self.panda leftMove];
            
        }
        if ([node.name isEqualToString:@"rightMoveButton"]) {
            
            [rightMoveButton setTexture:[SKTexture textureWithImageNamed:@"greenrightbutton"]];
            [leftMoveButton setTexture:[SKTexture textureWithImageNamed:@"leftbutton"]];

            //right move
            isRightMoveButton = YES;
            isLeftMoveButton = NO;
            [self.panda rightMove];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if ((isLeftMoveButton || isRightMoveButton) && !isJumpButton) {
        if (!isSecondTouchJumpButton) {
            [self.panda removePandaActionForKey:@"MoveAction"];
            [self.panda removePandaActionForKey:@"MoveAnimation"];
            [self.panda idle];
            
            isLeftMoveButton = NO;
            isRightMoveButton = NO;
            
            [leftMoveButton setTexture:[SKTexture textureWithImageNamed:@"leftbutton"]];
            [rightMoveButton setTexture:[SKTexture textureWithImageNamed:@"rightbutton"]];
        }
        else if (isSecondTouchJumpButton){
            isSecondTouchJumpButton = NO;
        }
    }
    
    else if (isJumpButton) {
        
        [jumpButton setTexture:[SKTexture textureWithImageNamed:@"jumpbutton"]];
        
        isJumpButton = NO;
        if (!isRightMoveButton && !isLeftMoveButton) {
            [self.panda idle];

        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
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



- (void)pandaFallinWater {
    for (int i = 0; i < [waters count]; i++) {
        if ([self.panda intersectsNode:waters[i]] && self.panda.position.y <= 150) {
            isExit = YES;
            if (!self.panda.isFall) {
                
                for (int i = 0; i < [hearts count];i++) {
                    [hearts[i] setTexture:[SKTexture textureWithImageNamed:@"hud_heartEmpty"]];
                }
                
                [backgroundGameMusic stop];
                [self playSoundNamed:@"lose_sound" ofType:@"mp3"];
                self.panda.physicsBody = nil;
                SKAction *jumpFallUp = [SKAction moveTo:CGPointMake(self.panda.position.x, self.panda.position.y + 200) duration:0.3];
                SKAction *jumpFallDown = [SKAction moveTo:CGPointMake(self.panda.position.x, self.panda.position.y - 150) duration:0.3];
                [self.panda runAction:[SKAction sequence:@[jumpFallUp,[SKAction waitForDuration:1]]] completion:^{
                    [self.panda runAction:[SKAction sequence:@[jumpFallDown]] completion:^{
                        [self endLevel:kEndReasonLose];
                    }];
                }];
            }
            
            self.panda.isFall = YES;
        }
    }
    
}

- (void)saveLittlePandas {
    for (int i = 0; i < [littlePandas count]; i++) {
        if ([self.panda intersectsNode:littlePandas[i]]) {
            [self playSoundNamed:@"savePanda" ofType:@"wav"];

            [KKGameData sharedGameData].score += 500;
            [self updateScoreHUD];
            [littlePandas[i] removeFromParent];
            [littlePandas[i] removeAllActions];
            [littlePandas removeObject:littlePandas[i]];
            _littlePandaScore.text = [NSString stringWithFormat:@"x %lu",(unsigned long)[littlePandas count]];
            SKAction *labelMoveIn = [SKAction scaleTo:1.2 duration:0.2];
            SKAction *labelMoveOut = [SKAction scaleTo:1.0 duration:0.2];
            [_littlePandaScore runAction:[SKAction sequence:@[labelMoveIn, labelMoveOut]]];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    [self.panda moveOnHorizontalPlatforms:horizontalPlatforms withLastPlatformPositions:lastPlatformPositions];
    
    if (!isPause) {
        [super update:currentTime]; //Calls the Visualiser
        
        [self saveLittlePandas];
        
        [self pandaFallinWater];
        
        [self littlePandasMove];
        
        if (!self.panda.isFall && !self.panda.isDie) {
            if (isLeftMoveButton == YES) {
                self.panda.position = CGPointMake(self.panda.position.x - 5, self.panda.position.y);
            }
            if (isRightMoveButton == YES) {
                self.panda.position = CGPointMake(self.panda.position.x + 5, self.panda.position.y);
            }
        }
        
        // Score for coins
        for (int i = 0; i < [coins count]; i++) {
            if ([self.panda intersectsNode:coins[i]]) {
                [self playSoundNamed:@"coin" ofType:@"wav"];
                [KKGameData sharedGameData].score += 10;
                [self updateScoreHUD];
                [self removeChildrenInArray:[NSArray arrayWithObjects:coins[i], nil]];
                [coins[i] removeAllActions];
                [coins removeObject:coins[i]];
            }
        }
        
        //Pick Up Hearts
        for (int i = 0; i < [pickUpHearts count]; i++) {
            if ([self.panda intersectsNode:pickUpHearts[i]]) {
                [self playSoundNamed:@"pickupheart" ofType:@"wav"];
                [KKGameData sharedGameData].score += 50;
                [self updateScoreHUD];
                
                if ([KKGameData sharedGameData].numberOfLives < 3) {
                    [KKGameData sharedGameData].numberOfLives++;
                    [hearts[[KKGameData sharedGameData].numberOfLives - 1] setTexture:
                     [SKTexture textureWithImageNamed:@"hud_heartFull"]];
                    
                }
                
                
                [self removeChildrenInArray:[NSArray arrayWithObjects:pickUpHearts[i], nil]];
                [pickUpHearts removeObject:pickUpHearts[i]];
            }
        }
        
        //Pick Up Clocks
        for (int i = 0; i < [pickUpClocks count]; i++) {
            if ([self.panda intersectsNode:pickUpClocks[i]]) {
                [self playSoundNamed:@"pickupheart" ofType:@"wav"];
                [KKGameData sharedGameData].score += 50;
                [self updateScoreHUD];
                
                [KKGameData sharedGameData].time -= 10;
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"mm:ss"];
                NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[KKGameData sharedGameData].time];
                
                _time.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
                SKAction *labelMoveIn = [SKAction scaleTo:1.2 duration:0.2];
                SKAction *labelMoveOut = [SKAction scaleTo:1.0 duration:0.2];
                [_time runAction:[SKAction sequence:@[labelMoveIn, labelMoveOut]]];
                
                [self removeChildrenInArray:[NSArray arrayWithObjects:pickUpClocks[i], nil]];
                [pickUpClocks removeObject:pickUpClocks[i]];
            }
        }
        
        //Pick Up Stars
        for (int i = 0; i < [pickUpStars count]; i++) {
            if ([self.panda intersectsNode:pickUpStars[i]]) {
                [self playSoundNamed:@"pickupheart" ofType:@"wav"];
                [KKGameData sharedGameData].score += 200;
                [self updateScoreHUD];
                
                //Animation for picked star
                NSMutableArray *textures = [NSMutableArray new];
                for (int i = 1; i <= 6; i++) {
                    [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"star0%i",i]]];
                }
                SKAction *starAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
                
                SKSpriteNode *pickedStar = [SKSpriteNode spriteNodeWithImageNamed:@"star01"];
                pickedStar.position = pickUpStars[i].position;
                pickedStar.zPosition = 5;
                [self addChild:pickedStar];
                [pickedStar runAction:starAnimation completion:^{
                    [pickedStar removeFromParent];
                }];
                
                [self removeChildrenInArray:[NSArray arrayWithObjects:pickUpStars[i], nil]];
                [pickUpStars removeObject:pickUpStars[i]];
            }
        }
        
        
        //Score for times
        static NSTimeInterval _lastCurrentTime = 0;
        if (currentTime-_lastCurrentTime>1 && !self.panda.isDie &&!self.panda.isFall && !isExit) {
            [KKGameData sharedGameData].time++;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"mm:ss"];
            NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[KKGameData sharedGameData].time];
            
            _time.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
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
        self.panda.isDie = NO;
        
        //play "oops" sound
        [self playSoundNamed:@"oops" ofType:@"wav"];
        
        [KKGameData sharedGameData].numberOfLives--;
        [self updateHeartsHUD];
        
        if ([KKGameData sharedGameData].numberOfLives == 0) {
            
            self.panda.isDie = YES;
            isExit = YES;
            
            if (isLeftMoveButton) {
                isLeftMoveButton = NO;
                [leftMoveButton setTexture:[SKTexture textureWithImageNamed:@"leftbutton"]];
            }
            if (isRightMoveButton) {
                isRightMoveButton = NO;
                [rightMoveButton setTexture:[SKTexture textureWithImageNamed:@"rightbutton"]];
            }
            if (isJumpButton) {
                isJumpButton = NO;
                [jumpButton setTexture:[SKTexture textureWithImageNamed:@"jumpbutton"]];
            }
            
            [backgroundGameMusic stop];
            [self playSoundNamed:@"lose_sound" ofType:@"mp3"];

            [self.panda runAction:self.panda.dieAnimation completion:^{
                self.panda.alpha = 0.0;
                [self endLevel:kEndReasonLose];
            }];
            
        }
        
        if (!self.panda.isDie) {
            self.panda.isHurt = YES;
            [self.panda hurt];
            
            if (isLeftMoveButton == YES || isRightMoveButton == YES || isJumpButton == YES) {
                [self.panda run];
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
            
            if ([enemiesArray[i] intersectsNode:self.panda] && CGRectGetMinX(self.panda.frame) <= CGRectGetMaxX(enemiesArray[i].frame) && CGRectGetMaxX(self.panda.frame) >= CGRectGetMinX(enemiesArray[i].frame) && (CGRectGetMinY(enemiesArray[i].frame) - CGRectGetMinY(self.panda.frame) <= 3 && CGRectGetMinY(enemiesArray[i].frame) - CGRectGetMinY(self.panda.frame) >= -3)) {
                
                if ((enemiesArray[i].xScale < 0 && (self.panda.xScale < 0)) || (self.panda.xScale > 0 && self.panda.position.x > enemiesArray[i].position.x)) {
                    
                    enemiesArray[i].xScale = 1.0*ABS(enemiesArray[i].xScale);
                }
                else if ((enemiesArray[i].xScale > 0 && self.panda.xScale > 0) || (self.panda.xScale < 0 && self.panda.position.x < enemiesArray[i].position.x)) {
                    
                    enemiesArray[i].xScale = -1.0*ABS(enemiesArray[i].xScale);
                }
                
                if (!self.panda.isHurt && !self.panda.isDie) {
                    [self pandaHurts];
                }
                
            }
            
            //Killing enemy
            if ([enemiesArray[i] intersectsNode:self.panda] && CGRectGetMinY(self.panda.frame) >= CGRectGetMinY(enemiesArray[i].frame) + 20 && CGRectGetMinY(self.panda.frame) <= CGRectGetMaxY(enemiesArray[i].frame)) {
                
                [self playSoundNamed:@"jumpland" ofType:@"wav"];

                [enemiesArray[i] removeAllActions];
                
                SKSpriteNode *tempSnail = [SKSpriteNode new];
                tempSnail = enemiesArray[i];
                [enemiesArray removeObject:enemiesArray[i]];
                [KKGameData sharedGameData].score += 100;
                [self updateScoreHUD];
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
        if ([self.panda intersectsNode:flowersSpit[i]] && !self.panda.isHurt &&!self.panda.isDie) {
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
        
        if (self.panda.position.x < flowers[i].position.x) {
            flowers[i].xScale = 1.0*ABS(flowers[i].xScale);
        }
        else {
            flowers[i].xScale = -1.0*ABS(flowers[i].xScale);
        }
        
        //Intersecting panda and enemy
        if ([flowers[i] intersectsNode:self.panda] && CGRectGetMinX(self.panda.frame) <= CGRectGetMaxX(flowers[i].frame) && CGRectGetMaxX(self.panda.frame) >= CGRectGetMinX(flowers[i].frame) && CGRectGetMaxX(self.panda.frame) - CGRectGetMinX(flowers[i].frame) >= 20 && (CGRectGetMinY(flowers[i].frame) - CGRectGetMinY(self.panda.frame) <= 3 && CGRectGetMinY(flowers[i].frame) - CGRectGetMinY(self.panda.frame) >= -6) && !self.panda.isHurt && !self.panda.isDie) {
            
            [self pandaHurts];
        }
        
        //Killing enemy
        if ([flowers[i] intersectsNode:self.panda] && CGRectGetMinY(self.panda.frame) >= CGRectGetMaxY(flowers[i].frame) - 20 ) {
            
            [self playSoundNamed:@"jumpland" ofType:@"wav"];
            
            [flowers[i] removeAllActions];
            
            SKSpriteNode *tempSnail = [SKSpriteNode new];
            tempSnail = flowers[i];

            [isFlowerAttackAnimation removeObject:isFlowerAttackAnimation[i]];
            [flowers removeObject:flowers[i]];
            [KKGameData sharedGameData].score += 100;
            [self updateScoreHUD];
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
    if (self.panda.position.x > (particleExit.position.x - 25) && self.panda.position.x < (particleExit.position.x + 25)) {
        if ([self.panda actionForKey:@"JumpAnimation"] == nil && [self.panda actionForKey:@"MoveAnimation"] == nil) {
            lastCurrentTime += 1;
            if (lastCurrentTime >= 30 && !isExit && [littlePandas count] == 0) {
                lastCurrentTime = 0;
                isExit = YES;
                [self playSoundNamed:@"win_sound" ofType:@"wav"];
                [self.panda runAction:[SKAction waitForDuration:0.8] completion:^{
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
        
        SKSpriteNode *windowWin = [SKSpriteNode spriteNodeWithImageNamed:@"windowwin"];
        windowWin.zPosition = 1000;
        windowWin.position = CGPointMake(camera.position.x, 410);
        windowWin.scale = 0.8;
        
        SKLabelNode *completeLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
        completeLabel.fontSize = 30.0;
        completeLabel.position = CGPointMake(camera.position.x, 598);
        completeLabel.zPosition = 1001;
        completeLabel.fontColor = [SKColor whiteColor];
        completeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        completeLabel.text = @"Level Complete";
        
        SKLabelNode *scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
        scoreLabel.fontSize = 32.0;
        scoreLabel.position = CGPointMake(camera.position.x - 108, 360);
        scoreLabel.zPosition = 1001;
        scoreLabel.fontColor = [SKColor blueColor];
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        scoreLabel.text = @"Score";
        
        SKLabelNode *totalScoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
        totalScoreLabel.fontSize = 32.0;
        totalScoreLabel.position = CGPointMake(camera.position.x + 20, 360);
        totalScoreLabel.zPosition = 1001;
        totalScoreLabel.fontColor = [SKColor whiteColor];
        totalScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        totalScoreLabel.text = [NSString stringWithFormat:@"%ld",k];
        
        SKLabelNode *timeLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
        timeLabel.fontSize = 32.0;
        timeLabel.position = CGPointMake(camera.position.x - 108, 280);
        timeLabel.zPosition = 1001;
        timeLabel.fontColor = [SKColor blueColor];
        timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        timeLabel.text = @"Time";
        
        SKSpriteNode *clock = [SKSpriteNode spriteNodeWithImageNamed:@"clock"];
        clock.zPosition = 1000;
        clock.position = CGPointMake(camera.position.x - 14, 290);
        clock.scale = 0.8;
        
        SKLabelNode *timeScoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
        timeScoreLabel.fontSize = 32.0;
        timeScoreLabel.position = CGPointMake(camera.position.x + 25, 280);
        timeScoreLabel.zPosition = 1001;
        timeScoreLabel.fontColor = [SKColor whiteColor];
        timeScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm:ss"];
        NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:t];
        timeScoreLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
        
        SKSpriteNode *homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"homebutton"];
        homeButton.zPosition = 1001;
        homeButton.position = CGPointMake(camera.position.x - 112, 179);
        homeButton.scale = 0.6;
        homeButton.name = @"homebutton";
        
        SKSpriteNode *levelsButton = [SKSpriteNode spriteNodeWithImageNamed:@"levelsbutton"];
        levelsButton.zPosition = 1001;
        levelsButton.position = CGPointMake(camera.position.x - 2, 179);
        levelsButton.scale = 0.6;
        levelsButton.name = @"levelsbutton";
        
        SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"playbuttonsmall"];
        playButton.zPosition = 1001;
        playButton.position = CGPointMake(camera.position.x + 108, 179);
        playButton.scale = 0.6;
        playButton.name = @"playbutton";
        
        [self addChild:windowWin];
        [self addChild:completeLabel];
        [self addChild:scoreLabel];
        [self addChild:totalScoreLabel];
        [self addChild:timeLabel];
        [self addChild:timeScoreLabel];
        [self addChild:clock];
        [self addChild:homeButton];
        [self addChild:levelsButton];
        [self addChild:playButton];
        

        if ([pickUpStars count] < 3) {
            SKSpriteNode *star1 = [SKSpriteNode spriteNodeWithImageNamed:@"starsmall"];
            star1.zPosition = 1001;
            star1.position = CGPointMake(camera.position.x - 104.5, 472);
            [self addChild:star1];
            
            if ([pickUpStars count] < 2) {
                SKSpriteNode *star2 = [SKSpriteNode spriteNodeWithImageNamed:@"starbig"];
                star2.zPosition = 1001;
                star2.position = CGPointMake(camera.position.x - 10, 505);
                [self addChild:star2];
                
                if ([pickUpStars count] < 1) {
                    SKSpriteNode *star3 = [SKSpriteNode spriteNodeWithImageNamed:@"starsmall"];
                    star3.zPosition = 1001;
                    star3.position = CGPointMake(camera.position.x + 89, 472);
                    [self addChild:star3];
                }
            }
        }
    }
    
    else if (endReason == kEndReasonLose) {
        
        SKSpriteNode *windowLose = [SKSpriteNode spriteNodeWithImageNamed:@"windowlose"];
        windowLose.zPosition = 1000;
        windowLose.position = CGPointMake(camera.position.x, 385);
        windowLose.scale = 0.8;
        
        SKSpriteNode *tapeLose = [SKSpriteNode spriteNodeWithImageNamed:@"tapelose"];
        tapeLose.zPosition = 1001;
        tapeLose.position = CGPointMake(camera.position.x, 591);
        tapeLose.scale = 0.8;
        
        SKLabelNode *failedLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
        failedLabel.fontSize = 39.0;
        failedLabel.position = CGPointMake(camera.position.x, 593);
        failedLabel.zPosition = 1002;
        failedLabel.fontColor = [SKColor whiteColor];
        failedLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        failedLabel.text = @"Level Failed";
        
        SKLabelNode *loseLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
        loseLabel.fontSize = 53.0;
        loseLabel.position = CGPointMake(camera.position.x, 394);
        loseLabel.zPosition = 1001;
        loseLabel.fontColor = [SKColor blackColor];
        loseLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        loseLabel.text = @"You Lose";
        
        SKSpriteNode *homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"homebutton"];
        homeButton.zPosition = 1001;
        homeButton.position = CGPointMake(camera.position.x - 112, 183);
        homeButton.scale = 0.6;
        homeButton.name = @"homebutton";
        
        SKSpriteNode *levelsButton = [SKSpriteNode spriteNodeWithImageNamed:@"levelsbutton"];
        levelsButton.zPosition = 1001;
        levelsButton.position = CGPointMake(camera.position.x - 2, 183);
        levelsButton.scale = 0.6;
        levelsButton.name = @"levelsbutton";
        
        SKSpriteNode *restartButton = [SKSpriteNode spriteNodeWithImageNamed:@"restartbutton"];
        restartButton.zPosition = 1001;
        restartButton.position = CGPointMake(camera.position.x + 108, 183);
        restartButton.scale = 0.6;
        restartButton.name = @"restartbutton";
        
        [self addChild:windowLose];
        [self addChild:tapeLose];
        [self addChild:failedLabel];
        [self addChild:loseLabel];
        [self addChild:homeButton];
        [self addChild:levelsButton];
        [self addChild:restartButton];
    }
}

@end
