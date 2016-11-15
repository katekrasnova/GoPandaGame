//
//  SoundController.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 15/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "SoundController.h"

@implementation SoundController

- (void)setupBackgroundGameMusic {
    self.soundsArray = [NSMutableArray new];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mainTheme" ofType:@"mp3"];
    self.backgroundGameMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    self.backgroundGameMusic.numberOfLoops = -1;
    self.backgroundGameMusic.volume = [KKGameData sharedGameData].musicVolume;
}

- (void)playSoundNamed:(NSString *)soundName ofType:(NSString *)soundType {
    for (int i = 0; i < [self.soundsArray count]; i++) {
        if (![self.soundsArray[i] isPlaying]) {
            [self.soundsArray removeObject:self.soundsArray[i]];
        }
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:soundName ofType:soundType];
    self.sound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    self.sound.volume = [KKGameData sharedGameData].soundVolume;
    self.sound.numberOfLoops = 0;
    [self.sound prepareToPlay];
    [self.sound play];
    [self.soundsArray addObject:self.sound];
}

@end
