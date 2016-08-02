//
//  GameStart.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 07.06.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameStart.h"
#import "GameScene.h"
#import "GameSettings.h"
#import "GameAchievement.h"
#import "GameInfo.h"
#import "GameLevels.h"
#import "KKSoundEffects.h"

@implementation GameStart

KKSoundEffects *sound;

- (void) didMoveToView:(SKView *)view {
    
    sound = [[KKSoundEffects alloc]init];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:touchLocation];
    
    SKView * skView = (SKView *)self.view;
    
    if ([node.name isEqualToString:@"playbutton"]) {
        [sound playClickSound];
        GameLevels *scene = [GameLevels nodeWithFileNamed:@"GameLevels"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"settingsbutton"]) {
        [sound playClickSound];
        GameSettings *scene = [GameSettings nodeWithFileNamed:@"GameSettings"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"achievementsbutton"]) {
        [sound playClickSound];
        GameAchievement *scene = [GameAchievement nodeWithFileNamed:@"GameAchievement"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"infobutton"]) {
        [sound playClickSound];
        GameInfo *scene = [GameInfo nodeWithFileNamed:@"GameInfo"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
}

@end
