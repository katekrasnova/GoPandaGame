//
//  GameLevels.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 13.07.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameLevels.h"
#import "KKGameData.h"
#import "GameStart.h"
#import "GameSettings.h"
#import "GameScene.h"
#import "KKSoundEffects.h"

@implementation GameLevels

KKSoundEffects *soundsLevelsScene;

- (void)didMoveToView:(SKView *)view {
    
    soundsLevelsScene = [[KKSoundEffects alloc]init];
    
    [KKGameData sharedGameData].completeLevels = 1;
    
    for (int i = 1; i <= [KKGameData sharedGameData].numberOfLevels; i++) {
        SKSpriteNode *level = (SKSpriteNode *)[self childNodeWithName:[NSString stringWithFormat:@"level%i", i]];
        if (i <= [KKGameData sharedGameData].completeLevels + 1) {
            level.texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"levelbutton%i", i]];
        }
        else {
            level.texture = [SKTexture textureWithImageNamed:@"levellock"];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:touchLocation];
    SKView * skView = (SKView *)self.view;
    
    if ([node.name isEqualToString:@"levelHomeButton"]) {
        [soundsLevelsScene playClickSound];
        
        GameStart *scene = [GameStart nodeWithFileNamed:@"GameStart"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    if ([node.name isEqualToString:@"levelSettingsButton"]) {
        [soundsLevelsScene playClickSound];

        GameSettings *scene = [GameSettings nodeWithFileNamed:@"GameSettings"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    if ([node.name isEqualToString:@"levelPlayButton"]) {
        [soundsLevelsScene playClickSound];

        GameScene *scene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", [KKGameData sharedGameData].completeLevels + 1]];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    for (int i = 1; i <= [KKGameData sharedGameData].completeLevels + 1; i++) {
        if ([node.name isEqualToString:[NSString stringWithFormat:@"level%i", i]]) {
            [soundsLevelsScene playClickSound];

            GameScene *scene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", i]];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }
    }
    
}

@end
