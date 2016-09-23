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
    
    //For Game Start Scene
    SKSpriteNode *musicbutton = (SKSpriteNode *)[self childNodeWithName:@"musicbutton"];
    SKSpriteNode *soundbutton = (SKSpriteNode *)[self childNodeWithName:@"soundbutton"];

    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"numOfLCalls"] == 1 && isFirstCall != YES) {
        [KKGameData sharedGameData].musicVolume = 0.5;
        [KKGameData sharedGameData].soundVolume = 0.75;
        [KKGameData sharedGameData].isMusicON = YES;
        [KKGameData sharedGameData].isSoundON = YES;

        [[[GameViewController alloc]init]setVolumeOfMenuBackgroundSound:[KKGameData sharedGameData].musicVolume];
        //[[[GameViewController alloc]init]setVolumeOfSounds:1.0];
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
    
    
    
    
    //For game settings scene /////////////////////////////////////////////////////////////////////////////////////////////
    //accelerometer
    SKSpriteNode *accelButton = (SKSpriteNode *)[self childNodeWithName:@"checkbutton"];
    if ([KKGameData sharedGameData].isAccelerometerON == YES) {
        accelButton.texture = [SKTexture textureWithImageNamed:@"checkbuttonon"];
    }
    else {
        accelButton.texture = [SKTexture textureWithImageNamed:@"checkbuttonoff"];
    }
    //Volume of music and sounds
    //[self updateVolumeLabels];
    [self updateMusicVolumeLabelWithVolume:[KKGameData sharedGameData].musicVolume*1000];
    [self updateSoundsVolumeLabelWithVolume:[KKGameData sharedGameData].soundVolume*1000];

    //For game levels scene - number open levels //////////////////////////////////////////////////////////////////////////

    NSLog(@"%i", [KKGameData sharedGameData].numberOfLevels);
    NSLog(@"%i", [KKGameData sharedGameData].completeLevels);

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

- (void)updateMusicVolumeLabelWithVolume:(float)volume {
    SKSpriteNode *musiclabel = (SKSpriteNode *)[self childNodeWithName:@"musiclabel"];
    musiclabel.texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"loudlabel%f",volume]];
}
- (void)updateSoundsVolumeLabelWithVolume:(float)volume {
    SKSpriteNode *soundslabel = (SKSpriteNode *)[self childNodeWithName:@"soundslabel"];
    soundslabel.texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"loudlabel%f",volume]];
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

BOOL isMusicVolumeChange;
BOOL isSoundsVolumeChange;
float tempVolumeMusic;
float tempVolumeSounds;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    SKView * skView = (SKView *)self.view;
    
    //for Game Start scene /////////////////////////////////////////////////////////////////////////////////////////////////
    if ([node.name isEqualToString:@"playbutton"]) {
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];
        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameLevels"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"settingsbutton"]) {
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameSettings"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"achievementsbutton"]) {
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameAchievement"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    else if ([node.name isEqualToString:@"infobutton"]) {
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameInfo"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    else if ([node.name isEqualToString:@"musicbutton"]) {
        
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];
        
        if ([self image:[UIImage imageWithCGImage:node.texture.CGImage] isEqualTo:[UIImage imageNamed:@"musicbutton_on"]]) {
            [KKGameData sharedGameData].musicVolume = 0;
            [KKGameData sharedGameData].isMusicON = NO;
            node.texture = [SKTexture textureWithImageNamed:@"musicbutton_off"];
        }

        else {
            [KKGameData sharedGameData].musicVolume = 0.5;
            [KKGameData sharedGameData].isMusicON = YES;
            node.texture = [SKTexture textureWithImageNamed:@"musicbutton_on"];
        }
        [[KKGameData sharedGameData]save];
        [[[GameViewController alloc]init] setVolumeOfMenuBackgroundSound:[KKGameData sharedGameData].musicVolume];
    }
    
    else if ([node.name isEqualToString:@"soundbutton"]) {
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];
        if ([self image:[UIImage imageWithCGImage:node.texture.CGImage] isEqualTo:[UIImage imageNamed:@"soundbutton_on"]]) {
            [KKGameData sharedGameData].soundVolume = 0;
            [KKGameData sharedGameData].isSoundON = NO;
            node.texture = [SKTexture textureWithImageNamed:@"soundbutton_off"];
        }
        
        else {
            [KKGameData sharedGameData].soundVolume = 0.75;
            [KKGameData sharedGameData].isSoundON = YES;
            node.texture = [SKTexture textureWithImageNamed:@"soundbutton_on"];
        }
        [[KKGameData sharedGameData]save];
    }
    
    
    //for Game Settings scene //////////////////////////////////////////////////////////////////////////////////////////////
    //Accelerometer on and off button
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
    //Volume
    if ([node.name isEqualToString:@"musicminus"] || [node.name isEqualToString:@"musicplus"] || [node.name isEqualToString:@"soundsminus"] || [node.name isEqualToString:@"soundsplus"]) {

        if ([node.name isEqualToString:@"musicminus"]) {
            if (isMusicVolumeChange == YES) {
                if (tempVolumeMusic > 0) { tempVolumeMusic -= 0.125; }
                else { tempVolumeMusic = 0.0; }
            }
            else if ([KKGameData sharedGameData].musicVolume > 0) {
                tempVolumeMusic = [KKGameData sharedGameData].musicVolume - 0.125;
            }
            isMusicVolumeChange = YES;
        }
        else if ([node.name isEqualToString:@"musicplus"]) {
            if (isMusicVolumeChange == YES) {
                if (tempVolumeMusic < 1) { tempVolumeMusic += 0.125; }
                else { tempVolumeMusic = 1.0; }
            }
            else if ([KKGameData sharedGameData].musicVolume < 1) {
                tempVolumeMusic = [KKGameData sharedGameData].musicVolume + 0.125;
            }
            isMusicVolumeChange = YES;
        }
        else if ([node.name isEqualToString:@"soundsminus"]) {
            if (isSoundsVolumeChange == YES) {
                if (tempVolumeSounds > 0) { tempVolumeSounds -= 0.125; }
                else { tempVolumeSounds = 0.0; }
            }
            else if ([KKGameData sharedGameData].soundVolume > 0) {
                tempVolumeSounds = [KKGameData sharedGameData].soundVolume - 0.125;
            }
            isSoundsVolumeChange = YES;
        }
        
        else if ([node.name isEqualToString:@"soundsplus"]) {
            if (isSoundsVolumeChange == YES) {
                if (tempVolumeSounds < 1) { tempVolumeSounds += 0.125; }
                else { tempVolumeSounds = 1.0; }
            }
            else if ([KKGameData sharedGameData].soundVolume < 1) {
                tempVolumeSounds = [KKGameData sharedGameData].soundVolume + 0.125;
            }
            isSoundsVolumeChange = YES;
        }
        
        if (isMusicVolumeChange == YES || isSoundsVolumeChange == YES) {
            if (isMusicVolumeChange == YES) {
                [[[GameViewController alloc]init]setVolumeOfMenuBackgroundSound:tempVolumeMusic];
                [self updateMusicVolumeLabelWithVolume:tempVolumeMusic*1000];
                [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];
            }
            if (isSoundsVolumeChange == YES) {
                [self updateSoundsVolumeLabelWithVolume:tempVolumeSounds*1000];
                [[[GameViewController alloc]init]playClickSoundWithVolume:tempVolumeSounds];
                [[[GameViewController alloc]init]playClickSoundWithVolume:tempVolumeSounds];
            }
        }
        else { [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume]; }
    }
    
    //Ok and cancel buttons
    if ([node.name isEqualToString:@"cancelsettingsbutton"] || [node.name isEqualToString:@"oksettingsbutton"]) {
        //Cancel button - settings not saving
        if ([node.name isEqualToString:@"cancelsettingsbutton"]) {
            [[[GameViewController alloc]init]setVolumeOfMenuBackgroundSound:[KKGameData sharedGameData].musicVolume];
            [self updateMusicVolumeLabelWithVolume:[KKGameData sharedGameData].musicVolume*1000];
            [self updateSoundsVolumeLabelWithVolume:[KKGameData sharedGameData].soundVolume*1000];
        }
        
        //OK button - settings saving
        else if ([node.name isEqualToString:@"oksettingsbutton"]) {
            [KKGameData sharedGameData].isMusicON = YES;
            [KKGameData sharedGameData].isSoundON = YES;
            [KKGameData sharedGameData].isAccelerometerON = _accelerometerSetting;
            
            if (isMusicVolumeChange == YES) { [KKGameData sharedGameData].musicVolume = tempVolumeMusic; }
            if (isSoundsVolumeChange == YES) { [KKGameData sharedGameData].soundVolume = tempVolumeSounds; }
            
            if ([KKGameData sharedGameData].musicVolume == 0.0) { [KKGameData sharedGameData].isMusicON = NO; }
            else { [KKGameData sharedGameData].isMusicON = YES; }
            
            if ([KKGameData sharedGameData].soundVolume == 0.0) { [KKGameData sharedGameData].isSoundON = NO; }
            else { [KKGameData sharedGameData].isSoundON = YES; }
            
            [[KKGameData sharedGameData]save];
        }
        
        isMusicVolumeChange = NO;
        isSoundsVolumeChange = NO;
        tempVolumeMusic = 0.0;
        tempVolumeSounds = 0.0;
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];
        [self presentStartScene];
    }
    
    
    
    
    
    //for GameAchievement scene ///////////////////////////////////////////////////////////////////////////////////////////
    else if ([node.name isEqualToString:@"okachievementsbutton"]) {
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];

        [self presentStartScene];

    }
    
    //for GameLevels scene ////////////////////////////////////////////////////////////////////////////////////////////////
    else if ([node.name isEqualToString:@"levelHomeButton"]) {
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];

        [self presentStartScene];
    }
    
    else if ([node.name isEqualToString:@"levelSettingsButton"]) {
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];

        MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameSettings"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
    else if ([node.name isEqualToString:@"levelPlayButton"]) {
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];

        GameScene *scene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", [KKGameData sharedGameData].completeLevels + 1]];
        
        [KKGameData sharedGameData].currentLevel = [KKGameData sharedGameData].completeLevels + 1;
        [[KKGameData sharedGameData] save];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [[[GameViewController alloc]init]stopMenuBackgroundMusic];
        
        [skView presentScene:scene];
    }
    
    for (int i = 1; i <= [KKGameData sharedGameData].completeLevels + 1; i++) {
        if ([node.name isEqualToString:[NSString stringWithFormat:@"level%i", i]]) {
            [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];

            GameScene *scene = [GameScene nodeWithFileNamed:[NSString stringWithFormat:@"Level%iScene", i]];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            [KKGameData sharedGameData].currentLevel = i;
            [[KKGameData sharedGameData] save];
            
            [[[GameViewController alloc]init]stopMenuBackgroundMusic];

            
            [skView presentScene:scene];
        }
    }
    
    //for Game Info scene ////////////////////////////////////////////////////////////////////////////////////////////////
    if ([node.name isEqualToString:@"okinfobutton"]) {
        [[[GameViewController alloc]init]playClickSoundWithVolume:[KKGameData sharedGameData].soundVolume];

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
