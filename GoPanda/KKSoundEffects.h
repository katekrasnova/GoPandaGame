//
//  KKSoundEffects.h
//  GoPanda
//
//  Created by Ekaterina Krasnova on 02.08.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"

@interface KKSoundEffects : NSObject

@property (strong, nonatomic) AVAudioPlayer *backgroundSound;
@property (strong, nonatomic) AVAudioPlayer *clickSound;


- (instancetype)init;
- (void)playBackgroundSound;
- (void)stopBackgroundSound;
- (void)playClickSound;

@end
