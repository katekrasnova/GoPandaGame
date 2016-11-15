//
//  SoundController.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 15/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

@import AVFoundation;
#import <Foundation/Foundation.h>
#import "KKGameData.h"
#import <SpriteKit/SpriteKit.h>

@interface SoundController : NSObject 

@property (strong, nonatomic) AVAudioPlayer *backgroundGameMusic;
@property (strong, nonatomic) AVAudioPlayer *sound;
@property (strong, nonatomic) NSMutableArray *soundsArray;

- (void)setupBackgroundGameMusic;
- (void)playSoundNamed:(NSString *)soundName ofType:(NSString *)soundType;

@end
