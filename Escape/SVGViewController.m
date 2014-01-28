//
//  SVGViewController.m
//  Escape
//
//  Created by Steven Veshkini on 9/25/13.
//  Copyright (c) 2013 Steven Veshkini. All rights reserved.
//

#import "SVGViewController.h"
#import "SVGStartScreen.h"
#import "SVGMainGameScreen.h"
@implementation SVGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    SKScene * scene = [SVGStartScreen sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
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

@end
