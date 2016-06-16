//
//  MHDirectionIndicator.m
//  MotionHUD
//
//  Created by Sam Kaufman on 4/27/16.
//  Copyright © 2016 Sam Kaufman. All rights reserved.
//

#import "MHDirectionIndicator.h"

@interface MHDirectionIndicator ()

@property (assign, nonatomic) CGSize size;
@property (strong, nonatomic) SKNode *rotaryNode;
@property (strong, nonatomic) SKShapeNode *boundingCircle;
@property (strong, nonatomic) SKShapeNode *arrow;

@end


@implementation MHDirectionIndicator

+ (MHDirectionIndicator *)directionIndicatorWithSize:(CGSize)size {
    return [[MHDirectionIndicator alloc] initWithSize:size];
}

- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.size = size;
        
        CGFloat smallerDim = MIN(size.width, size.height);
        
        self.rotaryNode = [SKNode node];
        [self addChild:self.rotaryNode];
        
        self.boundingCircle = [SKShapeNode shapeNodeWithCircleOfRadius:(smallerDim/2.0)];
        self.boundingCircle.zPosition = CGFLOAT_MAX - 2;
        self.boundingCircle.lineWidth = 0.5;
        self.boundingCircle.strokeColor = [UIColor whiteColor];
        self.boundingCircle.fillColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [self.rotaryNode addChild:self.boundingCircle];
        
        self.arrow = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(1.0, smallerDim/2.0)];
        self.arrow.zPosition = CGFLOAT_MAX - 1;
        self.arrow.fillColor = [UIColor whiteColor];
        self.arrow.lineWidth = 0.0;
        self.arrow.position = CGPointMake(0, smallerDim/4.0);
        [self.rotaryNode addChild:self.arrow];
        
        [self updateArrowRotation];
    }
    return self;
}

- (void)setRotation:(double)rotation {
    _rotation = rotation;
    [self updateArrowRotation];
};

- (void)updateArrowRotation {
    [self.rotaryNode runAction:[SKAction rotateToAngle:self.rotation duration:0.00]];
}

@end
