//
//  SVGGameOverScreen.m
//  Escape
//
//  Created by Steven Veshkini on 9/28/13.
//  Copyright (c) 2013 Steven Veshkini. All rights reserved.
//

#import "SVGGameOverScreen.h"
#import "SVGMainGameScreen.h"
@import AVFoundation;

@interface SVGGameOverScreen()
@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic) NSNumber *score;
@property BOOL didTap;
@end
@implementation SVGGameOverScreen

-(id)initWithSize:(CGSize)size userData:(NSMutableDictionary *)userData
{
    if (self = [super initWithSize:size])
    {
        self.view.scene.size = size;
        self.userData = userData;
        _didTap = false;
        [self createScene];
    }
    return self;
}

-(void)createScene
{
    //Start background music
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"8-bit loop (loop)" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
   
    //Configure background color
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    //Display labels
    self.score = [self.userData objectForKey:@"score"];
   
    SKLabelNode *firstLabel = [SKLabelNode labelNodeWithFontNamed:@"BankGothicBold"];
    firstLabel.text = [NSString stringWithFormat:@"GAME OVER"];
    firstLabel.fontSize = 42;
   // firstLabel.fontColor = [SKColor blackColor];
    firstLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 200);

    SKLabelNode *secondLabel = [SKLabelNode labelNodeWithFontNamed:@"BankGothicBold"];
    secondLabel.text = [NSString stringWithFormat:@"SCORE:"];
    secondLabel.fontSize = 28;
    secondLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 35);
    
    SKLabelNode *thirdLabel = [SKLabelNode labelNodeWithFontNamed:@"BankGothicBold"];
    thirdLabel.text = [NSString stringWithFormat:@"TAP TO PLAY AGAIN!"];
    thirdLabel.fontSize = 16;
    thirdLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 175);
    
    SKLabelNode *fourthLabel = [SKLabelNode labelNodeWithFontNamed:@"BankGothicBold"];
    fourthLabel.text = [NSString stringWithFormat:@"%d", self.score.intValue];
    fourthLabel.fontSize = 36;
    fourthLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self addChild:firstLabel];
    [self addChild:secondLabel];
    [self addChild:thirdLabel];
    [self addChild:fourthLabel];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Called when user taps screen
    if (!_didTap)
    {
        SKAction *presentMainScreen = [SKAction runBlock:^
        {
            _didTap = true;
            SVGMainGameScreen *gameScreen = [[SVGMainGameScreen alloc]initWithSize:self.size];
            SKTransition *transition = [SKTransition pushWithDirection:SKTransitionDirectionUp duration:1.0];
            [self.backgroundMusicPlayer stop];
            transition.pausesIncomingScene = YES;
            [self.scene.view presentScene:gameScreen transition:transition];
        }];
            
        [self runAction:presentMainScreen];
    }
}
@end
