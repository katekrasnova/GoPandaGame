//
//  GameViewController.h
//  GoPanda
//

//  Copyright (c) 2016 Ekaterina Krasnova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@import AVFoundation;

@interface GameViewController : UIViewController <AVAudioPlayerDelegate>

- (void) playMenuBackgroundMusic;
- (void) stopMenuBackgroundMusic;
- (void) playClickSoundWithVolume:(float)volume;
- (void) setVolumeOfMenuBackgroundSound:(float)volume;
- (void) setVolumeOfSounds:(float)volume;

@end
