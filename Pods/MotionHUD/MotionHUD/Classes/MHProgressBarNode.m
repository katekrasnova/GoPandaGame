//
//  MHProgressBarNode.m
//  MotionHUD
//
//  Created by Sam Kaufman on 4/26/16.
//  Copyright © 2016 Sam Kaufman. All rights reserved.
//

#import "MHProgressBarNode.h"


static const double kInitialCompletion = 0.70;


@interface MHProgressBarNode ()

@property (strong, nonatomic, nonnull) SKShapeNode *bgRect;
@property (strong, nonatomic, nonnull) SKShapeNode *fgRect;

@end


@implementation MHProgressBarNode

+ (MHProgressBarNode *)progressBarWithSize:(CGSize)size {
    MHProgressBarNode *node = [[self alloc] init];
    node.size = size;
    return node;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _centerOffset = 0.0;
        _completion = kInitialCompletion;
        
        /* Add the two rects which comprise this bad boy */
        [self rebuildFBRect];
        [self rebuildBGRect];
    }
    return self;
}

- (void)setSize:(CGSize)size {
    _size = size;
    [self rebuildBGRect];
    [self rebuildFBRect];
}

- (void)setCenterOffset:(double)centerOffset {
    _centerOffset = centerOffset;
    [self rebuildFBRect];
}

- (void)setCompletion:(double)completion {
    _completion = completion;
    [self rebuildFBRect];
}


# pragma mark - React

- (void)rebuildFBRect {
    [self.fgRect removeFromParent];
    self.fgRect = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.size.width * self.completion, self.size.height)];
    self.fgRect.position = CGPointMake(0.5 * self.size.width * (self.completion + (self.centerOffset * 2.0) - 1.0), 0.0);
    self.fgRect.fillColor = [UIColor whiteColor];
    self.fgRect.lineWidth = 0;
    self.fgRect.zPosition = CGFLOAT_MAX - 1;
    [self addChild:self.fgRect];
}

- (void)rebuildBGRect {
    [self.bgRect removeFromParent];
    self.bgRect = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.size.width, self.size.height)];
    self.bgRect.fillColor = [UIColor blackColor];
    self.bgRect.alpha = 0.3;
    self.bgRect.lineWidth = 0.0;
    self.bgRect.zPosition = CGFLOAT_MAX - 2;
    [self addChild:self.bgRect];
}

@end
