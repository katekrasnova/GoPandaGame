//
//  GameSettings.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 08.06.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameSettings.h"
#import "GameStart.h"

@implementation GameSettings

- (void)didMoveToView:(SKView *)view {
    self.isAccelerometerON = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    SKView * skView = (SKView *)self.view;

    if ([node.name isEqualToString:@"cancelsettingsbutton"]) {
        GameStart *scene = [GameStart nodeWithFileNamed:@"GameStart"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    if ([node.name isEqualToString:@"checkbutton"]) {

        if (self.isAccelerometerON == YES) {
            node.texture =  [SKTexture textureWithImageNamed:@"checkbuttonoff"];
            self.isAccelerometerON = NO;
        }
        else {
            node.texture = [SKTexture textureWithImageNamed:@"checkbuttonon"];
            self.isAccelerometerON = YES;

        }
    }
}

@end
