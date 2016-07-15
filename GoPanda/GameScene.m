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

@implementation GameScene

float lastCameraPosition;
SKCameraNode *camera;
NSMutableArray *coins;

-(void)didMoveToView:(SKView *)view {
    
    // Set boundaries
    /*SKNode *background = [self childNodeWithName:@"background"];
    SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:background.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 1.0f; */
    
    // Set boundaries and background   //NEW
    NSLog(@"SKScene:initWithSize %f x %f",self.size.width,self.size.height);
    SKNode *exitSign = [self childNodeWithName:@"exitSign"];
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
//    [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Idle_000"]]];
//    self.jumpAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    self.jumpAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    //Create Panda idle animation
    textures = [NSMutableArray new];
    for (int i = 0; i <= 9; i++) {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Idle_00%i",i]]];
    }
    self.idleAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
    
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
    lastCameraPosition = camera.position.x;
    
    //Score
    [self setupHUD];
    _highScore.text = [NSString stringWithFormat:@"High: %li pt", [KKGameData sharedGameData].highScore];
    _score.text = @"0 pt";
    _distance.text = @"";
    
    //Setup array of coins
    coins = [NSMutableArray new];
    for (SKSpriteNode *child in [self children]) {
        if ([child.name isEqualToString:@"coin"]) {
            [coins addObject:child];
        }
    }
    NSLog(@"%lu", (unsigned long)[coins count]);
    NSLog(@"%@", coins[1]);
}

//Score
SKLabelNode* _score;
SKLabelNode* _highScore;
SKLabelNode* _distance;

-(void)setupHUD
{
    _score = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    _score.fontSize = 30.0;
    _score.position = CGPointMake(150, 130);
    _score.fontColor = [SKColor blackColor];
    [self addChild:_score];
    
    _distance = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    _distance.fontSize = 30.0;
    _distance.position = CGPointMake(430, 130);
    _distance.fontColor = [SKColor blueColor];
    //[self addChild:_distance];
    
    _highScore = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    _highScore.fontSize = 30.0;
    _highScore.position = CGPointMake(530, 130);
    _highScore.fontColor = [SKColor redColor];
    //[self addChild:_highScore];
}

int leftTouches;
int rightTouches;
const int kMoveSpeed = 200;
static const NSTimeInterval kHugeTime = 9999.0;


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    SKNode *panda = [self childNodeWithName:@"Panda"];
    [panda runAction:self.idleAnimation withKey:@"StayAnimation"];
    
    for (UITouch *touch in touches) {
        if ([touch locationInNode:panda.parent].x < panda.position.x) {
            leftTouches++;
        }
        else {
            rightTouches++;
        }
    }
    
    if ((leftTouches == 1) && (rightTouches == 0)) {
        //Move left
        panda.xScale = -1.0*ABS(panda.xScale);
        SKAction *leftMove = [SKAction moveBy:CGVectorMake(-1.0*kMoveSpeed*kHugeTime, 0) duration:kHugeTime];
        [panda removeActionForKey:@"StayAnimation"];
        [panda runAction:leftMove withKey:@"MoveAction"];
        [panda runAction:self.runAnimation withKey:@"MoveAnimation"];
    }
    else if ((leftTouches == 0) && (rightTouches == 1)) {
        //Move right
        panda.xScale = 1.0*ABS(panda.xScale);
        SKAction *rightMove = [SKAction moveBy:CGVectorMake(1.0*kMoveSpeed*kHugeTime, 0) duration:kHugeTime];
        [panda removeActionForKey:@"StayAnimation"];
        [panda runAction:rightMove withKey:@"MoveAction"];
        [panda runAction:self.runAnimation withKey:@"MoveAnimation"];
        
    }
    else if ((leftTouches + rightTouches) > 1) {
        //Jump
        SKAction *jumpMove = [SKAction applyImpulse:CGVectorMake(0, 130) duration:0.05];
        [panda.physicsBody setAccessibilityFrame:CGRectMake(panda.position.x, panda.position.y, 125, 222)];
        [panda removeActionForKey:@"StayAnimation"];
        [panda runAction:jumpMove withKey:@"JumpAction"];
        [panda runAction:self.jumpAnimation withKey:@"JumpAnimation"];
    }
    
    //Touch end button DELETE
    SKView * skView = (SKView *)self.view;
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    if ([node.name isEqualToString:@"endgame"]) {
        GameStart *scene = [GameStart nodeWithFileNamed:@"GameStart"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
        [KKGameData sharedGameData].highScore = MAX([KKGameData sharedGameData].score,
                                                    [KKGameData sharedGameData].highScore);
        [[KKGameData sharedGameData] save];
        [[KKGameData sharedGameData] reset];

        leftTouches = 0;
        rightTouches = 0;
    }
    

}

- (void)reduceTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    SKNode *panda = [self childNodeWithName:@"Panda"];
    
    for (UITouch *touch in touches) {
        if ([touch locationInNode:panda.parent].x < panda.position.x) {
            leftTouches--;
        }
        else {
            rightTouches--;
        }
    }
    while ((leftTouches < 0) || (rightTouches < 0)) {
        if (leftTouches < 0) {
            rightTouches += leftTouches;
            leftTouches = 0;
        }
        if (rightTouches < 0) {
            leftTouches += rightTouches;
            rightTouches = 0;
        }
    }
    if ((rightTouches + leftTouches) <= 0) {
        [panda removeActionForKey:@"MoveAction"];
        [panda removeActionForKey:@"MoveAnimation"];
        [panda runAction:self.idleAnimation withKey:@"StayAnimation"];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self reduceTouches:touches withEvent:event];
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

-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime]; //Calls the Visualiser
    
    if ([KKGameData sharedGameData].isAccelerometerON == YES) {
        [self accelerometerUpdate];
    }
    
    // Add box for score - DELETE
    SKNode *panda = [self childNodeWithName:@"Panda"];
    //SKSpriteNode *coin = (SKSpriteNode *)[self childNodeWithName:[NSString stringWithFormat:@"coin"]];
    for (int i = 0; i < [coins count]; i++) {
        if ([panda intersectsNode:coins[i]]) {
            [KKGameData sharedGameData].score += 100;
            _score.text = [NSString stringWithFormat:@"%li pt", [KKGameData sharedGameData].score];
            [self removeChildrenInArray:[NSArray arrayWithObjects:coins[i], nil]];
            [coins removeObject:coins[i]];
        }
    }
    
    
    //Score DELETE
    static NSTimeInterval _lastCurrentTime = 0;
    if (currentTime-_lastCurrentTime>1) {
        [KKGameData sharedGameData].distance++;
        [KKGameData sharedGameData].totalDistance++;
        _distance.text = [NSString stringWithFormat:@"%li miles", [KKGameData sharedGameData].totalDistance];
        _lastCurrentTime = currentTime;
    }
    
    
    //Move score label when camera moves
    SKSpriteNode *endGame = (SKSpriteNode *)[self childNodeWithName:@"endgame"];
    if (lastCameraPosition < camera.position.x) {
        _score.position = CGPointMake(_score.position.x + (camera.position.x - lastCameraPosition), 130);
        endGame.position = CGPointMake(endGame.position.x + (camera.position.x - lastCameraPosition), 569);
        lastCameraPosition = camera.position.x;
    }
    else if ((lastCameraPosition > camera.position.x) && (lastCameraPosition >= 150)) {
        if (lastCameraPosition >= 500) {
            endGame.position = CGPointMake(endGame.position.x - (lastCameraPosition - camera.position.x), 569);
        }
        _score.position = CGPointMake(_score.position.x - (lastCameraPosition - camera.position.x), 130);
        lastCameraPosition = camera.position.x;
    }
    
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
