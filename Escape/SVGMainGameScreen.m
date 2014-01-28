//
//  SVGMainGameScreen.m
//  Escape
//
//  Created by Steven Veshkini on 9/25/13.
//  Copyright (c) 2013 Steven Veshkini. All rights reserved.
//

#import "SVGMainGameScreen.h"
#import "SVGMonster.h"
#import "SVGGameOverScreen.h"
#import "SVGProjectile.h"

@import AVFoundation;

@interface SVGMainGameScreen()

@property (nonatomic) SVGMonster *monster;
@property (nonatomic) SKSpriteNode *player;
@property (nonatomic) SKSpriteNode *leftWall;
@property (nonatomic) SKSpriteNode *topWall;
@property (nonatomic) SKSpriteNode *rightWall;
@property (nonatomic) SKSpriteNode *bottomWall;
@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval lastMoveTimeInterval;
@property (nonatomic) CGRect screenWindow;
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic) NSNumber *score;
@end

#define kARC4_RNG_UpperBound 4294967296
#define LEFT_RIGHT_WALL_WIDTH 10
#define TOP_BOTTOM_WALL_HEIGHT 10

typedef enum : uint8_t {
    SVGWallCategory                 = 1,
    SVGMonsterCategory              = 2,
    SVGPlayerCategory               = 4,
    SVGProjectileCategory           = 8
} SVGCategory;

@implementation SVGMainGameScreen
-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size])
    {
         [self createScene];
    }
    return self;
}

-(void)createScene
{
     //Separate method to configure all of the scene to reduce overhead upon initialization
     //Set up physics world and background
  
     self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
     self.physicsWorld.contactDelegate = self;
     self.anchorPoint = CGPointMake(0.0, 0.0);
     self.physicsWorld.gravity = CGVectorMake(0.0, 0.0); //No gravity
     
     //Create and configure monster sprite
     self.monster = [[SVGMonster alloc]initWithImageNamed:@"blockerMad"];
     self.monster.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + self.monster.size.height/2);
     self.monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.monster.size];
     self.monster.physicsBody.categoryBitMask = SVGMonsterCategory;
     self.monster.physicsBody.contactTestBitMask = SVGWallCategory | SVGPlayerCategory;
     self.monster.physicsBody.collisionBitMask = SVGWallCategory;
     
     //Create and configure player sprite
     self.player = [[SKSpriteNode alloc]initWithImageNamed:@"hud_p1_opt"];
     self.player.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
     self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
     self.player.physicsBody.categoryBitMask = SVGPlayerCategory;
     self.player.physicsBody.contactTestBitMask = SVGWallCategory | SVGMonsterCategory;
     self.player.physicsBody.collisionBitMask = SVGWallCategory;
     self.player.physicsBody.dynamic = YES;
     self.player.physicsBody.usesPreciseCollisionDetection = YES;
     self.player.physicsBody.velocity = CGVectorMake(0, 0);
     self.monster.target = self.player;
     
     //Get bounds of device screen
     self.screenWindow = [[UIScreen mainScreen] bounds];
     self.monster.screenSize = self.screenWindow.size;
     
     //Create and configure wall boundaries
     self.leftWall = [[SKSpriteNode alloc]initWithColor:[SKColor blackColor] size:CGSizeMake(10,self.screenWindow.size.height)];
     self.leftWall.position = CGPointMake(CGRectGetMinX(self.frame), (self.leftWall.size.height/2));
     self.leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.leftWall.size];
     self.leftWall.physicsBody.categoryBitMask = SVGWallCategory;
     self.leftWall.physicsBody.contactTestBitMask = SVGMonsterCategory | SVGPlayerCategory;
     self.leftWall.physicsBody.collisionBitMask = SVGPlayerCategory;
     self.leftWall.physicsBody.dynamic = NO;
     self.leftWall.physicsBody.resting = YES;
     self.leftWall.name = @"leftWall";
     
     self.rightWall = [[SKSpriteNode alloc]initWithColor:[SKColor blackColor] size:CGSizeMake(10,self.screenWindow.size.height)];
     self.rightWall.position = CGPointMake(CGRectGetMaxX(self.frame), (self.rightWall.size.height/2));
     self.rightWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.rightWall.size];
     self.rightWall.physicsBody.categoryBitMask = SVGWallCategory;
     self.rightWall.physicsBody.contactTestBitMask = SVGMonsterCategory | SVGPlayerCategory ;
     self.rightWall.physicsBody.collisionBitMask = SVGPlayerCategory;
     self.rightWall.physicsBody.dynamic = NO;
     self.rightWall.physicsBody.resting = YES;
     self.rightWall.name = @"rightWall";
     
     self.topWall = [[SKSpriteNode alloc]initWithColor:[SKColor blackColor] size:CGSizeMake(self.screenWindow.size.width, 10)];
     self.topWall.position = CGPointMake(self.topWall.size.width/2,CGRectGetMaxY(self.frame));
     self.topWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.topWall.size];
     self.topWall.physicsBody.dynamic = NO;
     self.topWall.physicsBody.categoryBitMask = SVGWallCategory;
     self.topWall.physicsBody.contactTestBitMask = SVGMonsterCategory | SVGPlayerCategory ;
     self.topWall.physicsBody.collisionBitMask = SVGPlayerCategory;
     self.topWall.physicsBody.dynamic = NO;
     self.topWall.physicsBody.resting = YES;
     self.topWall.name = @"topWall";
     
     self.bottomWall = [[SKSpriteNode alloc]initWithColor:[SKColor blackColor] size:CGSizeMake(self.screenWindow.size.width, 10)];
     self.bottomWall.position = CGPointMake(self.bottomWall.size.width/2,CGRectGetMinY(self.frame)*2);
     self.bottomWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.bottomWall.size];
     self.bottomWall.physicsBody.categoryBitMask = SVGWallCategory;
     self.bottomWall.physicsBody.contactTestBitMask = SVGMonsterCategory | SVGPlayerCategory ;
     self.bottomWall.physicsBody.collisionBitMask = SVGPlayerCategory;
     self.bottomWall.physicsBody.dynamic = NO;
     self.bottomWall.physicsBody.resting = YES;
     self.bottomWall.name = @"bottomWall";
     
     self.scoreLabel = [[SKLabelNode alloc]initWithFontNamed:@"BankGothicBold"];
    // self.scoreLabel.fontColor = [SKColor blackColor];
     self.scoreLabel.fontSize = 14;
     self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@", self.score];
     self.scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - (self.scoreLabel.frame.size.width - 30), CGRectGetMinY(self.frame) + self.scoreLabel.frame.size.height);
     
     //Add nodes to scene
     [self addChild:self.monster];
     [self addChild:self.player];
     [self addChild:self.leftWall];
     [self addChild:self.topWall];
     [self addChild:self.rightWall];
     [self addChild:self.bottomWall];
     [self addChild:self.scoreLabel];

     //Configure and run background music
     NSError *error;
     NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"Endless Sand" withExtension:@"mp3"];
     self.backgroundMusicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:backgroundMusicURL error:&error];
     self.backgroundMusicPlayer.numberOfLoops = -1;
     [self.backgroundMusicPlayer prepareToPlay];
     [self.backgroundMusicPlayer play];

}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
     //Configure the pan gesture (dragging finger
     // across the screen) to track and drag the player sprite accordingly
     
    if (!self.panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragPlayer:)];
        self.panGesture.minimumNumberOfTouches = 1;
        self.panGesture.delegate = self;
        [self.view addGestureRecognizer:self.panGesture];
    }
     
}

-(CGPoint)checkBounds:(CGPoint)newLocation{
     //This method will make sure the object is not outside of the bounds of the screen
     
     CGSize screenSize = self.size;
     CGPoint returnValue = newLocation;
     
     returnValue.x = MAX(returnValue.x, LEFT_RIGHT_WALL_WIDTH);
     returnValue.x = MIN(returnValue.x, screenSize.width - LEFT_RIGHT_WALL_WIDTH);
     returnValue.y = MAX(returnValue.y, TOP_BOTTOM_WALL_HEIGHT);
     returnValue.y = MIN(returnValue.y, screenSize.height - TOP_BOTTOM_WALL_HEIGHT);

     return returnValue;
}

-(void)dragPlayer: (UIPanGestureRecognizer *)gesture {
    
     if (gesture.state == UIGestureRecognizerStateChanged) {
           
          //Get the (x,y) translation coordinate
          CGPoint translation = [gesture translationInView:self.view];
           
          //Move by -y because moving positive is right and down, we want right and up
          //so that we can match the user's drag location (SKView rectangle y is opp UIView)
          CGPoint newLocation = CGPointMake(self.player.position.x + translation.x, self.player.position.y - translation.y);
    
          //Check if location is in bounds of screen
          self.player.position = [self checkBounds:newLocation];
          
          //Reset the translation point to the origin so that translation does not accumulate
          [gesture setTranslation:CGPointZero inView:self.view];
      
     }
     
}

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastMoveTimeInterval += timeSinceLast;
    if (self.lastMoveTimeInterval > 1){
         self.lastMoveTimeInterval = 0;
    }
     
     //Update score
     self.score = [NSNumber numberWithInt:(self.score.intValue + 1)];
     self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@", self.score];
     self.monster.score = self.score;
     
     //Update the monster's state
     [self.monster updateWithTimeSinceLastUpdate:timeSinceLast];
     
     //Handle projectile throwing
     if (self.score.intValue > 100) {
     if (self.monster.currentState == SVGMonsterStateThrow)
          [self shootProjectile];
     }
}

- (void)update:(NSTimeInterval)currentTime {
    //Handle time change
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
     
     //Decide what to do when nodes make contact with each other
     
     SKPhysicsBody *firstBody, *secondBody;
     if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
          firstBody = contact.bodyA;
          secondBody = contact.bodyB;
     } else {
          firstBody = contact.bodyB;
          secondBody = contact.bodyA;
     }
     
     //Wall and Monster
     if ((firstBody.categoryBitMask & SVGWallCategory) != 0 && (secondBody.categoryBitMask & SVGMonsterCategory) != 0)
     {
          self.monster.wallIdentifier = firstBody.node.name;
          [self.monster endSeek];
     }
     
     //Wall and Player
     if ((firstBody.categoryBitMask & SVGWallCategory) != 0 && (secondBody.categoryBitMask & SVGPlayerCategory) != 0)
     {
          self.score = 0;
     }
     
     //Monster and Player
     if ((firstBody.categoryBitMask & SVGMonsterCategory) != 0 && (secondBody.categoryBitMask & SVGPlayerCategory) != 0)
     {
          [self removeAllActions];
          [self gameOver];
     }
     
     //Wall and Projectile
     if ((firstBody.categoryBitMask & SVGWallCategory) != 0 && (secondBody.categoryBitMask & SVGProjectileCategory) != 0)
     {
          [secondBody.node removeFromParent];
     }
     
     //Player and Projectile
     if ((firstBody.categoryBitMask & SVGPlayerCategory) != 0 && (secondBody.categoryBitMask & SVGProjectileCategory) != 0)
     {
          [self removeAllActions];
          [self gameOver];
     }
     
}

-(void)shootProjectile
{
     //Create and configure a projectile
          SVGProjectile *projectile = [SVGProjectile spriteNodeWithImageNamed:@"blockerBodySmall"];
     
          projectile.position = self.monster.position;
          projectile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:projectile.size];
          projectile.physicsBody.dynamic = YES;
          projectile.physicsBody.usesPreciseCollisionDetection = YES;
          projectile.physicsBody.categoryBitMask = SVGProjectileCategory;
          projectile.physicsBody.contactTestBitMask = SVGWallCategory | SVGPlayerCategory;
          projectile.physicsBody.collisionBitMask = 0;
          [self addChild:projectile];
     
     //Fire the projectile
          [projectile moveToSpriteNode:self.player];
     
     [self.monster resetState];
     
}
-(void)gameOver
{
     //Save the score and pass it to the game over screen
     self.userData = [[NSMutableDictionary alloc]init];
     [self.userData setObject:self.score forKey:@"score"];
     
     SVGGameOverScreen *gameOverScreen = [[SVGGameOverScreen alloc]initWithSize:self.size userData:self.userData];
     
     [self.backgroundMusicPlayer stop];
     
     //Transition to new view
     SKTransition *transition = [SKTransition pushWithDirection:SKTransitionDirectionUp duration:1.0];
     transition.pausesOutgoingScene = YES;
     [self.view presentScene:gameOverScreen transition:transition];
}

@end
