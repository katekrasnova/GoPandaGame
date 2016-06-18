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

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    // Set off accelerometer
    GameSettings *settings = [[GameSettings alloc]init];
    settings.isAccelerometerON = YES;
    
    // Set motion manager for accelerometer
    if (settings.isAccelerometerON == YES) {
        self.motionManager = [[CMMotionManager alloc]init];
        if (self.motionManager.accelerometerAvailable) {
            [self.motionManager startAccelerometerUpdates];
        }
    }
    else {
        [self.motionManager stopAccelerometerUpdates];
    }
    
    // Set boundaries
    SKNode *background = [self childNodeWithName:@"background"];
    SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:background.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 1.0f;
    
    // Set boundaries
//    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
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
    SKCameraNode *camera = (SKCameraNode *)[self childNodeWithName:@"MainCamera"];
    id horizConstraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:100] toNode:panda];
    id vertConstraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:50] toNode:panda];
    id leftConstraint = [SKConstraint positionX:[SKRange rangeWithLowerLimit:camera.position.x]];
    id bottomConstraint = [SKConstraint positionY:[SKRange rangeWithLowerLimit:camera.position.y]];
    id rightConstraint = [SKConstraint positionX:[SKRange rangeWithUpperLimit:(background.frame.size.width - camera.position.x)]];
    id topConstraint = [SKConstraint positionY:[SKRange rangeWithUpperLimit:(background.frame.size.height - 150 - camera.position.y)]];
    [camera setConstraints:@[horizConstraint, vertConstraint, leftConstraint, bottomConstraint, rightConstraint, topConstraint]];


}



int leftTouches;
int rightTouches;
const int kMoveSpeed = 200;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    static const NSTimeInterval kHugeTime = 9999.0;
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
        SKAction *jumpMove = [SKAction applyImpulse:CGVectorMake(0, 200) duration:0.05];
        [panda.physicsBody setAccessibilityFrame:CGRectMake(panda.position.x, panda.position.y, 125, 222)];
        [panda removeActionForKey:@"StayAnimation"];
        [panda runAction:jumpMove withKey:@"JumpAction"];
        [panda runAction:self.jumpAnimation withKey:@"JumpAnimation"];
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

-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime]; //Calls the Visualiser
}

@end
