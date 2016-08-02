//
//  KKSoundEffects.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 02.08.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "KKSoundEffects.h"

@implementation KKSoundEffects

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"mainTheme" ofType:@"mp3"]];
        _backgroundSound = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _backgroundSound.numberOfLoops = -1;
        
        NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"click" ofType:@"wav"]];
        _clickSound = [[AVAudioPlayer alloc]initWithContentsOfURL:url1 error:nil];
        _clickSound.numberOfLoops = 0;
    }
    return self;
}

- (void)playBackgroundSound {
    [_backgroundSound play];
}
- (void)stopBackgroundSound {
    [_backgroundSound stop];
}
- (void)playClickSound {
    [_clickSound play];
}

@end
