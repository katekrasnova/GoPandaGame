//
//  PauseWindow.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 14/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "PauseWindow.h"

@implementation PauseWindow

- (void)setupPauseWindowForScene:(SKScene *)scene withCamera:(SKCameraNode *)camera {
    self.pauseWindow = [SKSpriteNode spriteNodeWithImageNamed:@"pausewindow"];
    self.pauseWindow.zPosition = 1000;
    self.pauseWindow.position = CGPointMake(camera.position.x, 385);
    self.pauseWindow.scale = 0.8;
    
    self.pausedLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    self.pausedLabel.fontSize = 55.0;
    self.pausedLabel.position = CGPointMake(camera.position.x, 583);
    self.pausedLabel.zPosition = 1002;
    self.pausedLabel.fontColor = [SKColor whiteColor];
    self.pausedLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    self.pausedLabel.text = @"Paused";
    
    if ([KKGameData sharedGameData].isMusicON == YES) {
        self.pauseMusicButton = [SKSpriteNode spriteNodeWithImageNamed:@"musicbutton_on"];
    }
    else {
        self.pauseMusicButton = [SKSpriteNode spriteNodeWithImageNamed:@"musicbutton_off"];
    }
    self.pauseMusicButton.zPosition = 1001;
    self.pauseMusicButton.position = CGPointMake(camera.position.x - 49, 485);
    self.pauseMusicButton.scale = 0.4;
    self.pauseMusicButton.name = @"pauseMusicButton";
    
    if ([KKGameData sharedGameData].isSoundON == YES) {
        self.pauseSoundButton = [SKSpriteNode spriteNodeWithImageNamed:@"soundbutton_on"];
    }
    else {
        self.pauseSoundButton = [SKSpriteNode spriteNodeWithImageNamed:@"soundbutton_off"];
    }
    self.pauseSoundButton.zPosition = 1001;
    self.pauseSoundButton.position = CGPointMake(camera.position.x + 49, 485);
    self.pauseSoundButton.scale = 0.4;
    self.pauseSoundButton.name = @"pauseSoundButton";
    
    self.pauseResumeButton = [SKSpriteNode spriteNodeWithImageNamed:@"resumeButton"];
    self.pauseResumeButton.zPosition = 1001;
    self.pauseResumeButton.position = CGPointMake(camera.position.x, 404);
    self.pauseResumeButton.scale = 0.4;
    self.pauseResumeButton.name = @"pauseButton";
    
    self.pauseRestartButton = [SKSpriteNode spriteNodeWithImageNamed:@"restartButton"];
    self.pauseRestartButton.zPosition = 1001;
    self.pauseRestartButton.position = CGPointMake(camera.position.x, 324);
    self.pauseRestartButton.scale = 0.4;
    self.pauseRestartButton.name = @"restartbutton";
    
    self.pauseHomeButton = [SKSpriteNode spriteNodeWithImageNamed:@"blueHomeButton"];
    self.pauseHomeButton.zPosition = 1001;
    self.pauseHomeButton.position = CGPointMake(camera.position.x - 49, 244);
    self.pauseHomeButton.scale = 0.4;
    self.pauseHomeButton.name = @"homebutton";
    
    self.pauseLevelsButton = [SKSpriteNode spriteNodeWithImageNamed:@"blueLevelButton"];
    self.pauseLevelsButton.zPosition = 1001;
    self.pauseLevelsButton.position = CGPointMake(camera.position.x + 49, 244);
    self.pauseLevelsButton.scale = 0.4;
    self.pauseLevelsButton.name = @"levelsbutton";
    
    [scene addChild:self.pauseWindow];
    [scene addChild:self.pausedLabel];
    [scene addChild:self.pauseMusicButton];
    [scene addChild:self.pauseSoundButton];
    [scene addChild:self.pauseResumeButton];
    [scene addChild:self.pauseRestartButton];
    [scene addChild:self.pauseHomeButton];
    [scene addChild:self.pauseLevelsButton];
}
- (void)removePauseWindow {
    [self.pauseWindow removeFromParent];
    [self.pausedLabel removeFromParent];
    [self.pauseMusicButton removeFromParent];
    [self.pauseSoundButton removeFromParent];
    [self.pauseResumeButton removeFromParent];
    [self.pauseRestartButton removeFromParent];
    [self.pauseHomeButton removeFromParent];
    [self.pauseLevelsButton removeFromParent];
}

@end

