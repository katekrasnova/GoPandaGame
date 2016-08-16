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

BOOL isFirstCall;

- (void) didMoveToView:(SKView *)view {
    
    //[self configureClickSound];
    
    //For Game Start Scene
    SKSpriteNode *musicbutton = (SKSpriteNode *)[self childNodeWithName:@"musicbutton"];
    SKSpriteNode *soundbutton = (SKSpriteNode *)[self childNodeWithName:@"soundbutton"];

    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"numOfLCalls"] == 1 && isFirstCall != YES) {
        [[[GameViewController alloc]init]setVolumeOfMenuBackgroundSound:1.0];
        [[[GameViewController alloc]init]setVolumeOfSounds:1.0];
        musicbutton.texture = [SKTexture textureWithImageNamed:@"musicbutton_on"];
        soundbutton.texture = [SKTexture textureWithImageNamed:@"soundbutton_on"];
        isFirstCall = YES;
    }
    else {
        if ([KKGameData sharedGameData].isMusicON == YES) {
            musicbutton.texture = [SKTexture textureWithImageNamed:@"musicbutton_on"];
        }
        else {
            musicbutton.texture = [SKTexture textureWithImageNamed:@"musicbutton_off"];
        }
        
        if ([KKGameData sharedGameData].isSoundON == YES) {
            soundbutton.texture = [SKTexture textureWithImageNamed:@"soundbutton_on"];
        }
        else {
            soundbutton.texture = [SKTexture textureWithImageNamed:@"soundbutton_off"];
        }
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
    //[KKGameData sharedGameData].completeLevels = 1;
    
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

//- (void)configureClickSound {
//    NSString *clickPath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
//    NSURL *clickURL = [NSURL fileURLWithPath:clickPath];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)clickURL, &_clickSound);
//    
//}

//- (void)playClickSound {
//    AudioServicesPlaySystemSound(self.clickSound);
//}

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
    
    //for Game Start scene /////////////////////////////////////////////////////////////////////////////////////////////////
    if ([node.name isEqualToString:@"playbutton"]) {
        [[[GameViewController alloc]init]playClickSound];
        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameLevels"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"settingsbutton"]) {
        [[[GameViewController alloc]init]playClickSound];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameSettings"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"achievementsbutton"]) {
        [[[GameViewController alloc]init]playClickSound];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameAchievement"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"infobutton"]) {
        [[[GameViewController alloc]init]playClickSound];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameInfo"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    else if ([node.name isEqualToString:@"musicbutton"]) {
        
        [[[GameViewController alloc]init]playClickSound];
        
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
    
    else if ([node.name isEqualToString:@"soundbutton"]) {
        [[[GameViewController alloc]init]playClickSound];
        if ([self image:[UIImage imageWithCGImage:node.texture.CGImage] isEqualTo:[UIImage imageNamed:@"soundbutton_on"]]) {
            [KKGameData sharedGameData].soundVolume = 0;
            [KKGameData sharedGameData].isSoundON = NO;
            node.texture = [SKTexture textureWithImageNamed:@"soundbutton_off"];
        }
        
        else {
            [KKGameData sharedGameData].soundVolume = 1;
            [KKGameData sharedGameData].isSoundON = YES;
            node.texture = [SKTexture textureWithImageNamed:@"soundbutton_on"];
        }
        [[KKGameData sharedGameData]save];
    }
    
    
    //for GameSettings scene //////////////////////////////////////////////////////////////////////////////////////////////
    else if ([node.name isEqualToString:@"cancelsettingsbutton"]) {
        [[[GameViewController alloc]init]playClickSound];

        [self presentStartScene];
    }
    
    else if ([node.name isEqualToString:@"oksettingsbutton"]) {
        [[[GameViewController alloc]init]playClickSound];

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
        [[[GameViewController alloc]init]playClickSound];

        [self presentStartScene];

    }
    
    //for GameLevels scene ////////////////////////////////////////////////////////////////////////////////////////////////
    else if ([node.name isEqualToString:@"levelHomeButton"]) {
        [[[GameViewController alloc]init]playClickSound];

        [self presentStartScene];
    }
    
    else if ([node.name isEqualToString:@"levelSettingsButton"]) {
        [[[GameViewController alloc]init]playClickSound];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameSettings"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    else if ([node.name isEqualToString:@"levelPlayButton"]) {
        [[[GameViewController alloc]init]playClickSound];

        GameScene *scene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", [KKGameData sharedGameData].completeLevels + 1]];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [[[GameViewController alloc]init]stopMenuBackgroundMusic];
        
        [skView presentScene:scene];
    }
    
    for (int i = 1; i <= [KKGameData sharedGameData].completeLevels + 1; i++) {
        if ([node.name isEqualToString:[NSString stringWithFormat:@"level%i", i]]) {
            [[[GameViewController alloc]init]playClickSound];

            GameScene *scene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", i]];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            [[[GameViewController alloc]init]stopMenuBackgroundMusic];

            
            [skView presentScene:scene];
        }
    }
    
    //for Game Info scene ////////////////////////////////////////////////////////////////////////////////////////////////
    if ([node.name isEqualToString:@"okinfobutton"]) {
        [[[GameViewController alloc]init]playClickSound];

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
