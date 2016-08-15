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
#import "GameViewController.h"
@import AVFoundation;

@interface MenuScenesController ()

@property (nonatomic) BOOL accelerometerSetting;
@property (assign) SystemSoundID clickSound;

@end

@implementation MenuScenesController


- (void) didMoveToView:(SKView *)view {
    
    [self configureClickSound];
    
    //For Game Start Scene
    SKSpriteNode *musicbutton = (SKSpriteNode *)[self childNodeWithName:@"musicbutton"];
    if ([KKGameData sharedGameData].isMusicON == NO) {
        musicbutton.texture = [SKTexture textureWithImageNamed:@"musicbutton_off"];
    }
    else {
        musicbutton.texture = [SKTexture textureWithImageNamed:@"musicbutton_on"];
    }
    
    //For game settings scene - accelerometer /////////////////////////////////////////////////////////////////////////////
    //NSLog(@"%i", [KKGameData sharedGameData].isAccelerometerON);
    
    SKSpriteNode *accelButton = (SKSpriteNode *)[self childNodeWithName:@"checkbutton"];
    if ([KKGameData sharedGameData].isAccelerometerON == YES) {
        accelButton.texture = [SKTexture textureWithImageNamed:@"checkbuttonon"];
    }
    else {
        accelButton.texture = [SKTexture textureWithImageNamed:@"checkbuttonoff"];
    }
    
    //For game levels scene - number open levels //////////////////////////////////////////////////////////////////////////
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

- (void)configureClickSound {
    NSString *clickPath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
    NSURL *clickURL = [NSURL fileURLWithPath:clickPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)clickURL, &_clickSound);
    
}

- (void)playClickSound {
    AudioServicesPlaySystemSound(self.clickSound);
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    SKView * skView = (SKView *)self.view;
    
    //for GameStart scene /////////////////////////////////////////////////////////////////////////////////////////////////
    if ([node.name isEqualToString:@"playbutton"]) {
        [self playClickSound];
        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameLevels"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"settingsbutton"]) {
        [self playClickSound];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameSettings"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"achievementsbutton"]) {
        [self playClickSound];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameAchievement"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"infobutton"]) {
        [self playClickSound];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameInfo"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    else if ([node.name isEqualToString:@"musicbutton"]) {
//        NSLog(@"%@", node.texture.description);
//        NSLog(@"%@", [SKTexture textureWithImageNamed:@"musicbutton_on"]);
        
        if ([self image:[UIImage imageWithCGImage:node.texture.CGImage] isEqualTo:[UIImage imageNamed:@"musicbutton_on"]]) {
            [KKGameData sharedGameData].musicVolume = 0;
            [KKGameData sharedGameData].isMusicON = NO;
            node.texture = [SKTexture textureWithImageNamed:@"musicbutton_off"];
        }

        else {
            [KKGameData sharedGameData].musicVolume = 1;
            [KKGameData sharedGameData].isMusicON = YES;
            node.texture = [SKTexture textureWithImageNamed:@"musicbutton_on"];
        }
        [[KKGameData sharedGameData]save];
        [[[GameViewController alloc]init] setVolumeOfMenuBackgroundSound:[KKGameData sharedGameData].musicVolume];
    }
    
    
    //for GameSettings scene //////////////////////////////////////////////////////////////////////////////////////////////
    else if ([node.name isEqualToString:@"cancelsettingsbutton"]) {
        [self playClickSound];

        [self presentStartScene];
    }
    
    else if ([node.name isEqualToString:@"oksettingsbutton"]) {
        [self playClickSound];

        [KKGameData sharedGameData].isAccelerometerON = _accelerometerSetting;
        [[KKGameData sharedGameData]save];
        [self presentStartScene];
    }
    
    else if ([node.name isEqualToString:@"checkbutton"]) {

        if ([KKGameData sharedGameData].isAccelerometerON == YES) {
            node.texture =  [SKTexture textureWithImageNamed:@"checkbuttonoff"];
            _accelerometerSetting = NO;
        }
        else {
            node.texture = [SKTexture textureWithImageNamed:@"checkbuttonon"];
            _accelerometerSetting = YES;
        }
    }
    
    //for GameAchievement scene ///////////////////////////////////////////////////////////////////////////////////////////
    else if ([node.name isEqualToString:@"okachievementsbutton"]) {
        [self playClickSound];

        [self presentStartScene];

    }
    
    //for GameLevels scene ////////////////////////////////////////////////////////////////////////////////////////////////
    else if ([node.name isEqualToString:@"levelHomeButton"]) {
        [self playClickSound];

        [self presentStartScene];
    }
    
    else if ([node.name isEqualToString:@"levelSettingsButton"]) {
        [self playClickSound];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameSettings"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    else if ([node.name isEqualToString:@"levelPlayButton"]) {
        [self playClickSound];

        GameScene *scene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", [KKGameData sharedGameData].completeLevels + 1]];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [[[GameViewController alloc]init]stopMenuBackgroundMusic];
        
        [skView presentScene:scene];
    }
    
    for (int i = 1; i <= [KKGameData sharedGameData].completeLevels + 1; i++) {
        if ([node.name isEqualToString:[NSString stringWithFormat:@"level%i", i]]) {
            [self playClickSound];

            GameScene *scene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", i]];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            [[[GameViewController alloc]init]stopMenuBackgroundMusic];

            
            [skView presentScene:scene];
        }
    }
    
    //for Game Info scene ////////////////////////////////////////////////////////////////////////////////////////////////
    if ([node.name isEqualToString:@"okinfobutton"]) {
        [self playClickSound];

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
