//
//  SVGStartScreen.m
//  Escape
//
//  Created by Steven Veshkini on 9/25/13.
//  Copyright (c) 2013 Steven Veshkini. All rights reserved.
//

#import "SVGStartScreen.h"
#import "SVGMainGameScreen.h"

@interface SVGStartScreen()
@property BOOL didTap;
@end

@implementation SVGStartScreen

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //Set-up scene and labels
        
        _didTap = false;
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *gameNameLabel = [SKLabelNode labelNodeWithFontNamed:@"BankGothicBold"];
        gameNameLabel.text = @"ESCAPE";
        gameNameLabel.fontSize = 42;
        gameNameLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)+100);
        
        SKLabelNode *startLabel = [SKLabelNode labelNodeWithFontNamed:@"BankGothicBold"];
        startLabel.text = @"TAP TO START!";
        startLabel.fontSize = 20;
        startLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100);
        
        [self addChild:gameNameLabel];
        [self addChild:startLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (!_didTap) //Eliminate possibility of multiple touches
    {
        SKAction *presentMainScreen = [SKAction runBlock:^
        {
            _didTap = true;
            SVGMainGameScreen *gameScreen = [[SVGMainGameScreen alloc]initWithSize:self.size];
            SKTransition *transition = [SKTransition pushWithDirection:SKTransitionDirectionUp duration:1.0];
            transition.pausesIncomingScene = YES;
            [self.scene.view presentScene:gameScreen transition:transition];
        }];
    
        [self runAction:presentMainScreen];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
