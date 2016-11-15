//
//  GameSceneWindows.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 14/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameSceneWindows.h"

@implementation GameSceneWindows

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

- (void)setupLoseWindowForScene:(SKScene *)scene withCamera:(SKCameraNode *)camera {
    SKSpriteNode *windowLose = [SKSpriteNode spriteNodeWithImageNamed:@"windowlose"];
    windowLose.zPosition = 1000;
    windowLose.position = CGPointMake(camera.position.x, 385);
    windowLose.scale = 0.8;
    
    SKSpriteNode *tapeLose = [SKSpriteNode spriteNodeWithImageNamed:@"tapelose"];
    tapeLose.zPosition = 1001;
    tapeLose.position = CGPointMake(camera.position.x, 591);
    tapeLose.scale = 0.8;
    
    SKLabelNode *failedLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    failedLabel.fontSize = 39.0;
    failedLabel.position = CGPointMake(camera.position.x, 593);
    failedLabel.zPosition = 1002;
    failedLabel.fontColor = [SKColor whiteColor];
    failedLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    failedLabel.text = @"Level Failed";
    
    SKLabelNode *loseLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    loseLabel.fontSize = 53.0;
    loseLabel.position = CGPointMake(camera.position.x, 394);
    loseLabel.zPosition = 1001;
    loseLabel.fontColor = [SKColor blackColor];
    loseLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    loseLabel.text = @"You Lose";
    
    SKSpriteNode *homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"homebutton"];
    homeButton.zPosition = 1001;
    homeButton.position = CGPointMake(camera.position.x - 112, 183);
    homeButton.scale = 0.6;
    homeButton.name = @"homebutton";
    
    SKSpriteNode *levelsButton = [SKSpriteNode spriteNodeWithImageNamed:@"levelsbutton"];
    levelsButton.zPosition = 1001;
    levelsButton.position = CGPointMake(camera.position.x - 2, 183);
    levelsButton.scale = 0.6;
    levelsButton.name = @"levelsbutton";
    
    SKSpriteNode *restartButton = [SKSpriteNode spriteNodeWithImageNamed:@"restartbutton"];
    restartButton.zPosition = 1001;
    restartButton.position = CGPointMake(camera.position.x + 108, 183);
    restartButton.scale = 0.6;
    restartButton.name = @"restartbutton";
    
    [scene addChild:windowLose];
    [scene addChild:tapeLose];
    [scene addChild:failedLabel];
    [scene addChild:loseLabel];
    [scene addChild:homeButton];
    [scene addChild:levelsButton];
    [scene addChild:restartButton];
}

- (void)setupWinWindowForScene:(SKScene *)scene withCamera:(SKCameraNode *)camera winTime:(long)t winScore:(long)k andPickedUpStars:(NSMutableArray *)stars {
    
    SKSpriteNode *windowWin = [SKSpriteNode spriteNodeWithImageNamed:@"windowwin"];
    windowWin.zPosition = 1000;
    windowWin.position = CGPointMake(camera.position.x, 410);
    windowWin.scale = 0.8;
    
    SKLabelNode *completeLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    completeLabel.fontSize = 30.0;
    completeLabel.position = CGPointMake(camera.position.x, 598);
    completeLabel.zPosition = 1001;
    completeLabel.fontColor = [SKColor whiteColor];
    completeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    completeLabel.text = @"Level Complete";
    
    SKLabelNode *scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    scoreLabel.fontSize = 32.0;
    scoreLabel.position = CGPointMake(camera.position.x - 108, 360);
    scoreLabel.zPosition = 1001;
    scoreLabel.fontColor = [SKColor blueColor];
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    scoreLabel.text = @"Score";
    
    SKLabelNode *totalScoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    totalScoreLabel.fontSize = 32.0;
    totalScoreLabel.position = CGPointMake(camera.position.x + 20, 360);
    totalScoreLabel.zPosition = 1001;
    totalScoreLabel.fontColor = [SKColor whiteColor];
    totalScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    totalScoreLabel.text = [NSString stringWithFormat:@"%ld",k];
    
    SKLabelNode *timeLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    timeLabel.fontSize = 32.0;
    timeLabel.position = CGPointMake(camera.position.x - 108, 280);
    timeLabel.zPosition = 1001;
    timeLabel.fontColor = [SKColor blueColor];
    timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    timeLabel.text = @"Time";
    
    SKSpriteNode *clock = [SKSpriteNode spriteNodeWithImageNamed:@"clock"];
    clock.zPosition = 1000;
    clock.position = CGPointMake(camera.position.x - 14, 290);
    clock.scale = 0.8;
    
    SKLabelNode *timeScoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    timeScoreLabel.fontSize = 32.0;
    timeScoreLabel.position = CGPointMake(camera.position.x + 25, 280);
    timeScoreLabel.zPosition = 1001;
    timeScoreLabel.fontColor = [SKColor whiteColor];
    timeScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:t];
    timeScoreLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    
    SKSpriteNode *homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"homebutton"];
    homeButton.zPosition = 1001;
    homeButton.position = CGPointMake(camera.position.x - 112, 179);
    homeButton.scale = 0.6;
    homeButton.name = @"homebutton";
    
    SKSpriteNode *levelsButton = [SKSpriteNode spriteNodeWithImageNamed:@"levelsbutton"];
    levelsButton.zPosition = 1001;
    levelsButton.position = CGPointMake(camera.position.x - 2, 179);
    levelsButton.scale = 0.6;
    levelsButton.name = @"levelsbutton";
    
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"playbuttonsmall"];
    playButton.zPosition = 1001;
    playButton.position = CGPointMake(camera.position.x + 108, 179);
    playButton.scale = 0.6;
    playButton.name = @"playbutton";
    
    [scene addChild:windowWin];
    [scene addChild:completeLabel];
    [scene addChild:scoreLabel];
    [scene addChild:totalScoreLabel];
    [scene addChild:timeLabel];
    [scene addChild:timeScoreLabel];
    [scene addChild:clock];
    [scene addChild:homeButton];
    [scene addChild:levelsButton];
    [scene addChild:playButton];
    
    
    if ([stars count] < 3) {
        SKSpriteNode *star1 = [SKSpriteNode spriteNodeWithImageNamed:@"starsmall"];
        star1.zPosition = 1001;
        star1.position = CGPointMake(camera.position.x - 104.5, 472);
        [scene addChild:star1];
        
        if ([stars count] < 2) {
            SKSpriteNode *star2 = [SKSpriteNode spriteNodeWithImageNamed:@"starbig"];
            star2.zPosition = 1001;
            star2.position = CGPointMake(camera.position.x - 10, 505);
            [scene addChild:star2];
            
            if ([stars count] < 1) {
                SKSpriteNode *star3 = [SKSpriteNode spriteNodeWithImageNamed:@"starsmall"];
                star3.zPosition = 1001;
                star3.position = CGPointMake(camera.position.x + 89, 472);
                [scene addChild:star3];
            }
        }
    }
}

- (void)addAchievement:(NSString *)achievement forScene:(SKScene *)scene withCamera:(SKCameraNode *)camera{
    
    SKSpriteNode *achievementBadge = [SKSpriteNode spriteNodeWithImageNamed:achievement];
    achievementBadge.zPosition = 1010;
    achievementBadge.position = CGPointMake(camera.position.x + 214.637, 365);
    achievementBadge.scale = 0.5;
    achievementBadge.alpha = 1.0;
    [scene addChild:achievementBadge];
    
    SKLabelNode *newLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    newLabel.fontSize = 40.0;
    newLabel.position = CGPointMake(camera.position.x + 288.602, 484.414);
    newLabel.zPosition = 1010;
    newLabel.fontColor = [SKColor redColor];
    newLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    newLabel.text = @"New";
    newLabel.zRotation = 326;
    newLabel.alpha = 1.0;
    [scene addChild:newLabel];
    
    SKLabelNode *achievementLabel = [[SKLabelNode alloc] initWithFontNamed:@"ChalkboardSE-Bold"];
    achievementLabel.fontSize = 40.0;
    achievementLabel.position = CGPointMake(camera.position.x +  266.253, 446.547);
    achievementLabel.zPosition = 1010;
    achievementLabel.fontColor = [SKColor redColor];
    achievementLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    achievementLabel.text = @"Achievement!";
    achievementLabel.zRotation = 326;
    achievementLabel.alpha = 1.0;
    [scene addChild:achievementLabel];
}



@end

