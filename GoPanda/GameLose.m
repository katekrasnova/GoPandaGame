//
//  GameLose.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 12.06.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameLose.h"
#import "MenuScenesController.h"
#import "GameScene.h"

@implementation GameLose

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:touchLocation];
    
    SKView * skView = (SKView *)self.view;
    
    if ([node.name isEqualToString:@"homebuttonlose"]) {
        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameStart"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"restartbuttonlose"]) {
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
}

@end
