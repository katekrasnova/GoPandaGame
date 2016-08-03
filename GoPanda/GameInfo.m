//
//  GameInfo.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 12.06.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameInfo.h"
#import "GameStart.h"
#import "KKSoundEffects.h"

@implementation GameInfo

KKSoundEffects *soundsInfoScene;

- (void)didMoveToView:(SKView *)view {
    
    soundsInfoScene = [[KKSoundEffects alloc]init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:touchLocation];
    
    SKView * skView = (SKView *)self.view;
    
    if ([node.name isEqualToString:@"okinfobutton"]) {
        [soundsInfoScene playClickSound];
        
        GameStart *scene = [GameStart nodeWithFileNamed:@"GameStart"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
}

@end
