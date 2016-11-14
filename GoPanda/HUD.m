//
//  HUD.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 14/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "HUD.h"

@implementation HUD

- (void)addButtonsAndLabelsWithCameraNode:(SKCameraNode *)camera {
    //left move button
    self.leftMoveButton = [SKSpriteNode spriteNodeWithImageNamed:@"leftbutton"];
    self.leftMoveButton.alpha = 0.5;
    self.leftMoveButton.scale = 0.8;
    self.leftMoveButton.position = CGPointMake(-440, -218);
    self.leftMoveButton.zPosition = 20;
    self.leftMoveButton.name = @"leftMoveButton";
    [camera addChild:self.leftMoveButton];
    //right move button
    self.rightMoveButton = [SKSpriteNode spriteNodeWithImageNamed:@"rightbutton"];
    self.rightMoveButton.alpha = 0.5;
    self.rightMoveButton.scale = 0.8;
    self.rightMoveButton.position = CGPointMake(-280, -218);
    self.rightMoveButton.zPosition = 20;
    self.rightMoveButton.name = @"rightMoveButton";
    [camera addChild:self.rightMoveButton];
    //jump button
    self.jumpButton = [SKSpriteNode spriteNodeWithImageNamed:@"jumpbutton"];
    self.jumpButton.alpha = 0.5;
    self.jumpButton.scale = 0.8;
    self.jumpButton.position = CGPointMake(440, -218);
    self.jumpButton.zPosition = 20;
    self.jumpButton.name = @"jumpButton";
    [camera addChild:self.jumpButton];
    
    //Pause Button
    self.pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"pauseButtonOff"];
    self.pauseButton.size = CGSizeMake(91, 95);
    self.pauseButton.position = CGPointMake(460, 230);
    self.pauseButton.alpha = 0.8;
    self.pauseButton.zPosition = 100;
    self.pauseButton.name = @"pauseButton";
    [camera addChild:self.pauseButton];
    
    //Little panda score (image and label)
    SKSpriteNode *littlePanda = [SKSpriteNode spriteNodeWithImageNamed:@"littlePandaEat_02"];
    littlePanda.position = CGPointMake(-280, 265);
    littlePanda.zPosition = 1000;
    littlePanda.name = [NSString stringWithFormat:@"littlePanda"];
    littlePanda.scale = 1;
    [camera addChild:littlePanda];
    self.littlePandaScore = [[SKLabelNode alloc] initWithFontNamed:@"MarkerFelt-Wide"];
    self.littlePandaScore.fontSize = 35.0;
    self.littlePandaScore.position = CGPointMake(-242, 252);
    self.littlePandaScore.fontColor = [SKColor blackColor];
    self.littlePandaScore.zPosition = 1000;
    self.littlePandaScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [camera addChild:self.littlePandaScore];
    
    //Score Label
    self.score = [[SKLabelNode alloc] initWithFontNamed:@"MarkerFelt-Wide"];
    self.score.fontSize = 30.0;
    self.score.position = CGPointMake(-497, 155);
    self.score.fontColor = [SKColor blackColor];
    self.score.zPosition = 1000;
    self.score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [camera addChild:self.score];
    
    //Time score (image and label)
    SKSpriteNode *clock = [SKSpriteNode spriteNodeWithImageNamed:@"clock"];
    clock.position = CGPointMake(-480, 215);
    clock.zPosition = 1000;
    clock.name = [NSString stringWithFormat:@"clock"];
    clock.scale = 0.5;
    [camera addChild:clock];
    self.time = [[SKLabelNode alloc] initWithFontNamed:@"MarkerFelt-Wide"];
    self.time.fontSize = 30.0;
    self.time.position = CGPointMake(-445, 203);
    self.time.zPosition = 1000;
    self.time.fontColor = [SKColor blueColor];
    self.time.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [camera addChild:self.time];
 
    //heart's nodes
    self.hearts = [NSMutableArray new];
    for (int i = 0; i < [KKGameData sharedGameData].numberOfLives; i++) {
        SKSpriteNode *heart = [SKSpriteNode spriteNodeWithImageNamed:@"hud_heartFull"];
        heart.position = CGPointMake(-480 + i*50, 265);
        heart.zPosition = 1000;
        heart.name = [NSString stringWithFormat:@"heart%i",i];
        heart.scale = 0.8;
        [camera addChild:heart];
        [self.hearts insertObject:heart atIndex:i];
    }
}

- (void)updateScoreHUD {
    self.score.text = [NSString stringWithFormat:@"%li", [KKGameData sharedGameData].score + [KKGameData sharedGameData].totalScore];
    SKAction *labelMoveIn = [SKAction scaleTo:1.2 duration:0.2];
    SKAction *labelMoveOut = [SKAction scaleTo:1.0 duration:0.2];
    [self.score runAction:[SKAction sequence:@[labelMoveIn, labelMoveOut]]];
}

- (void)updateHeartsHUD {
    //update hearts
    if ([KKGameData sharedGameData].numberOfLives < [self.hearts count]) {
        [self.hearts[[KKGameData sharedGameData].numberOfLives] setTexture:[SKTexture textureWithImageNamed:@"hud_heartEmpty"]];
    }
}

@end
