//
//  MHDirectionIndicator.h
//  MotionHUD
//
//  Created by Sam Kaufman on 4/27/16.
//  Copyright © 2016 Sam Kaufman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MHDirectionIndicator : SKNode

@property (assign, nonatomic) double rotation;

+ (MHDirectionIndicator *)directionIndicatorWithSize:(CGSize)size;

@end
