//
//  GameViewController.m
//  GoPanda
//
//  Created by Ekaterina Krasnova on 07.06.16.
//  Copyright (c) 2016 Ekaterina Krasnova. All rights reserved.
//

#import "GameViewController.h"
#import "MenuScenesController.h"

@implementation GameViewController

AVAudioPlayer *menuBackgroundSound;

- (void)viewDidLoad
{
    [self configureMenuBackgroundSound];
    [menuBackgroundSound play];
    
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = NO;
    
    // Create and configure the scene.
    MenuScenesController *scene = [MenuScenesController nodeWithFileNamed:@"GameStart"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (void) configureMenuBackgroundSound {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"menuTheme" ofType:@"mp3"];
    menuBackgroundSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    menuBackgroundSound.delegate = self;
    menuBackgroundSound.numberOfLoops = -1;
}

- (void)viewWillDisappear {
    
}

- (void) playMenuBackgroundMusic {
    [self configureMenuBackgroundSound];
    [menuBackgroundSound play];
}

- (void) stopMenuBackgroundMusic {
    [menuBackgroundSound stop];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
