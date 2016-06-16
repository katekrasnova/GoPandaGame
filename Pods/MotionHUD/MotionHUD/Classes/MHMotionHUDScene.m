//
//  MHMotionHUDScene.m
//  MotionHUD
//
//  Created by Sam Kaufman on 5/15/16.
//
//

@import CoreMotion.CMMotionManager;
#import "MHMotionHUDScene.h"
#import "MHDirectionIndicator.h"
#import "MHProgressBarNode.h"


@interface MHMotionHUDScene ()

@property (strong, nonatomic) NSArray<MHDirectionIndicator *> *directionIndicators;
@property (strong, nonatomic) NSArray<MHProgressBarNode *> *progressBars;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end


@implementation MHMotionHUDScene

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
}

- (void)update:(CFTimeInterval)currentTime {
    
    [super update:currentTime];

    /* Set up the motion manager if necessary */
    if (!self.motionManager) {
        self.motionManager = [CMMotionManager new];
        self.motionManager.deviceMotionUpdateInterval = 0.1;
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
    }
    
    // Rebuild every frame to keep position correct even as, for
    // instance, cameras move. It's cheap.
    [self buildDisplayNodes];

    /* Update the pitch bar */
    CMDeviceMotion *motion = self.motionManager.deviceMotion;
    if (motion) {
        CMAttitude *attitude = motion.attitude;
        self.progressBars[0].completion = attitude.pitch / M_PI;
        self.progressBars[1].completion = attitude.roll / (2.0 * M_PI);
        self.directionIndicators[0].rotation = attitude.yaw;
    } else {
        for (MHProgressBarNode *bar in self.progressBars)
            bar.completion = 0.0;
    }
}

- (void)buildDisplayNodes {
    [self removeChildrenInArray:self.progressBars ?: @[]];
    [self removeChildrenInArray:self.directionIndicators ?: @[]];
    self.progressBars = [self createProgressBarStackOfSize:2];
    self.directionIndicators = [self createDirectionIndicators:1 fromRightEdge:CGRectGetMinX(self.progressBars.firstObject.calculateAccumulatedFrame)];
}

- (NSArray<MHDirectionIndicator *> *)createDirectionIndicators:(NSUInteger)cnt
                                                 fromRightEdge:(CGFloat)rightX
{
    static const CGFloat kDiameterInPx = 12;
    static const CGFloat kPaddingInPx = 2;
    static const CGFloat kBtmMarginInPx = 3;

    CGPoint btmCtrInView = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height - kBtmMarginInPx);
    CGPoint btmCtr = [self convertPointFromView:btmCtrInView];
    CGPoint topOfBtmCtr = [self convertPointFromView:CGPointMake(btmCtrInView.x, btmCtrInView.y - kDiameterInPx)];
    CGFloat diameter = ABS(topOfBtmCtr.y - btmCtr.y);
    CGFloat padding = kPaddingInPx * (diameter / kDiameterInPx);

    NSMutableArray *a = [NSMutableArray arrayWithCapacity:cnt];
    for (int i = 0; i < cnt; i++) {
        MHDirectionIndicator *node = [MHDirectionIndicator directionIndicatorWithSize:CGSizeMake(topOfBtmCtr.y - btmCtr.y, topOfBtmCtr.y - btmCtr.y)];
        node.position = CGPointMake(rightX - ((diameter + padding) * (i + 1)), (diameter / 2.0) + btmCtr.y);
        [self addChild:node];
        [a addObject:node];
    }
    return a;
}

- (NSArray<MHProgressBarNode *> *)createProgressBarStackOfSize:(NSUInteger)cnt {

    static const CGFloat kHeightInPx = 10;
    static const CGFloat kPaddingInPx = 3;
    static const CGFloat kBtmMarginInPx = 3;

    CGPoint btmCtrInView = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height - kBtmMarginInPx);
    CGPoint btmCtr = [self convertPointFromView:btmCtrInView];
    CGPoint topOfBtmCtr = [self convertPointFromView:CGPointMake(btmCtrInView.x, btmCtrInView.y - kHeightInPx)];
    CGFloat heightInScene = topOfBtmCtr.y - btmCtr.y;
    CGFloat paddingInScene = kPaddingInPx * (kHeightInPx / heightInScene);

    NSMutableArray *a = [NSMutableArray arrayWithCapacity:cnt];
    for (int i = 0; i < cnt; i++) {
        MHProgressBarNode *progressBar = [MHProgressBarNode progressBarWithSize:CGSizeMake(50, topOfBtmCtr.y - btmCtr.y)];
        progressBar.position = CGPointMake(btmCtr.x, ((paddingInScene + heightInScene) * i) + (heightInScene / 2.0) + btmCtr.y);
        progressBar.centerOffset = 0.5;
        [self addChild:progressBar];
        [a addObject:progressBar];
    }
    return a;
}

@end
