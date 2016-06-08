//
//  GameStart.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 07.06.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameStart.h"
#import "GameScene.h"

@implementation GameStart

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:touchLocation];
    
    if ([node.name isEqualToString:@"playbutton"]) {
        SKView * skView = (SKView *)self.view;
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
}

@end
