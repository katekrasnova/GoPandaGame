//
//  MHProgressBarNode.h
//  MotionHUD
//
//  Created by Sam Kaufman on 4/26/16.
//  Copyright © 2016 Sam Kaufman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MHProgressBarNode : SKNode

@property (assign, nonatomic) double centerOffset;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) double completion;

+ (MHProgressBarNode *)progressBarWithSize:(CGSize)size;

@end
