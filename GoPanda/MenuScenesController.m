//
//  MenuScenesController.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 11.08.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "MenuScenesController.h"
#import "GameScene.h"
#import "KKGameData.h"

@interface MenuScenesController ()

@property (nonatomic) BOOL accelerometerSetting;

@end

@implementation MenuScenesController

- (void) didMoveToView:(SKView *)view {
    
    //For game settings scene - accelerometer /////////////////////////////////////////////////////////////////////////////
    //NSLog(@"%i", [KKGameData sharedGameData].isAccelerometerON);
    
    SKSpriteNode *accelButton = (SKSpriteNode *)[self childNodeWithName:@"checkbutton"];
    if ([KKGameData sharedGameData].isAccelerometerON == YES) {
        accelButton.texture = [SKTexture textureWithImageNamed:@"checkbuttonon"];
    }
    else {
        accelButton.texture = [SKTexture textureWithImageNamed:@"checkbuttonoff"];
    }
    
    //For game levels scene - number open levels /////////////////////////////////////////////////////////////////////////////
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
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    SKView * skView = (SKView *)self.view;
    
    //for GameStart scene ////////////////////////////////////////////////////////////////////////////////////////////////
    if ([node.name isEqualToString:@"playbutton"]) {
        
        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameLevels"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"settingsbutton"]) {
        
        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameSettings"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"achievementsbutton"]) {
        
        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameAchievement"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"infobutton"]) {
        
        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameInfo"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    //for GameSettings scene ////////////////////////////////////////////////////////////////////////////////////////////////
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
    
    //for GameAchievement scene ////////////////////////////////////////////////////////////////////////////////////////////////
    if ([node.name isEqualToString:@"okachievementsbutton"]) {
        
        [self presentStartScene];

    }
    
    //for GameLevels scene ////////////////////////////////////////////////////////////////////////////////////////////////
    if ([node.name isEqualToString:@"levelHomeButton"]) {
        
        [self presentStartScene];
    }
    
    if ([node.name isEqualToString:@"levelSettingsButton"]) {
        
        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameSettings"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    if ([node.name isEqualToString:@"levelPlayButton"]) {
        
        GameScene *scene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", [KKGameData sharedGameData].completeLevels + 1]];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    for (int i = 1; i <= [KKGameData sharedGameData].completeLevels + 1; i++) {
        if ([node.name isEqualToString:[NSString stringWithFormat:@"level%i", i]]) {
            
            GameScene *scene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", i]];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }
    }
    
    //for Game Info scene ////////////////////////////////////////////////////////////////////////////////////////////////
    if ([node.name isEqualToString:@"okinfobutton"]) {
        
        [self presentStartScene];
    }
    
}

- (void)presentStartScene {

    SKView * skView = (SKView *)self.view;
    MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameStart"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}

@end
