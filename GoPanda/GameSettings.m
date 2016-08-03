//
//  GameSettings.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 08.06.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameSettings.h"
#import "GameStart.h"
#import "KKGameData.h"
#import "KKSoundEffects.h"


@interface GameSettings ()

@property (nonatomic) BOOL accelerometerSetting;

@end

@implementation GameSettings

KKSoundEffects *soundsSettingsScene;

- (void)didMoveToView:(SKView *)view {
    
    soundsSettingsScene = [[KKSoundEffects alloc]init];
    
    //NSLog(@"%i", [KKGameData sharedGameData].isAccelerometerON);
    
    SKSpriteNode *accelButton = (SKSpriteNode *)[self childNodeWithName:@"checkbutton"];
    if ([KKGameData sharedGameData].isAccelerometerON == YES) {
        accelButton.texture = [SKTexture textureWithImageNamed:@"checkbuttonon"];
    }
    else {
        accelButton.texture = [SKTexture textureWithImageNamed:@"checkbuttonoff"];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];

    if ([node.name isEqualToString:@"cancelsettingsbutton"]) {
        [self presentStartScene];
    }
    
    if ([node.name isEqualToString:@"oksettingsbutton"]) {
        [KKGameData sharedGameData].isAccelerometerON = _accelerometerSetting;
        [[KKGameData sharedGameData]save];
        [self presentStartScene];
    }
    
    if ([node.name isEqualToString:@"checkbutton"]) {
                
        if ([KKGameData sharedGameData].isAccelerometerON == YES) {
            node.texture =  [SKTexture textureWithImageNamed:@"checkbuttonoff"];
            _accelerometerSetting = NO;
        }
        else {
            node.texture = [SKTexture textureWithImageNamed:@"checkbuttonon"];
            _accelerometerSetting = YES;
        }
    }
}

- (void)presentStartScene {
    
    [soundsSettingsScene playClickSound];
    
    SKView * skView = (SKView *)self.view;
    GameStart *scene = [GameStart nodeWithFileNamed:@"GameStart"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}

@end
