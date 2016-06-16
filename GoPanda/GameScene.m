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

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
//    SKNode *background = [self childNodeWithName:@"background"];
//    SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:background.frame];
//    self.physicsBody = borderBody;
//    self.physicsBody.friction = 1.0f;
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime]; //Calls the Visualiser
}

@end
