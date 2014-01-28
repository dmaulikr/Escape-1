//
//  SVGMonster.m
//  Escape
//
//  Created by Steven Veshkini on 9/25/13.
//  Copyright (c) 2013 Steven Veshkini. All rights reserved.
//  This is a semi-intelligent monster subclassed from SKSpriteNode

#import "SVGMonster.h"
#import "Vector.h"

#define ARC4_RNG_UPPERBOUND 4294967296

@interface SVGMonster()
@end

#pragma mark Monster Methods
@implementation SVGMonster
-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size];
    if (self){
        _currentState = SVGMonsterStateIdle;
    }
    return self;
}

-(void)moveToSpriteNode:(SKSpriteNode *)target withTimeInterval:(NSTimeInterval)time
{
    
   //Make sure this method is only called when the monster is not currently seeking
    if (_currentState == SVGMonsterStateIdle)
    {
        
        //Get vector from monster to target
        CGPoint vectorToTarget = [Vector vectorSubtract:target.position : self.position];
   
        //Make unit vector
        CGPoint unitizedVector = [Vector vectorNormalize:vectorToTarget];
        
        CGPoint shootAmt = [Vector vectorMultiplyByScalar:unitizedVector : self.screenSize.height+self.screenSize.width];
    
        CGPoint actualDistance = [Vector vectorAdd:shootAmt : self.position];

        SKAction *actionMove = [SKAction moveTo:actualDistance duration:time];
    
        [self runAction:actionMove];
        
        _currentState = SVGMonsterStateSeek;
    }
    
}

-(void)endSeek
{
    //This method is called after monster makes contact with wall
    
    [self removeAllActions];
    [self chooseNextAction];
}

-(void)chooseNextAction
{
    if (arc4random_uniform(3) <= 1) //67% chance to walk
    {
         _currentState = SVGMonsterStateWalk;
        [self monsterWalk];
    }
    else //33% chance
    {
        if (self.score.intValue >= 0)
            if (arc4random_uniform(1) == 0) // 100% chance to throw projectile (33% overall)
                [self shootProjectile];
    }
}

-(void)resetState
{
    //Reset monster's state
    _currentState = SVGMonsterStateIdle;
    
}

-(void)shootProjectile
{
    _currentState = SVGMonsterStateThrow;
    
    //Once this method is called, the main scene handles shooting the projectiles
}

-(void)monsterWalk
{
    if (_currentState == (SVGMonsterStateWalk))
    {
    
        const double RAND_MULTIPLIER = 1.5;
        double randomInterval = (((double)arc4random()/ARC4_RNG_UPPERBOUND)*RAND_MULTIPLIER); //Time between 0 and 1.5s
    
        //Decide magnitude of walk
        int walkDistance = (8 * (int)arc4random_uniform(21) - 10); //Number between -80 and 80 pixels
        
        //Decide direction of walk depending on the current wall
        if ([self.wallIdentifier isEqualToString:@"leftWall"] || [self.wallIdentifier isEqualToString:@"rightWall"])
        {
            SKAction *walkVertical = [SKAction moveByX:0 y:(walkDistance) duration:randomInterval];
            SKAction *resetState = [SKAction performSelector:@selector(resetState) onTarget:self];
            [self runAction:[SKAction sequence:@[walkVertical, resetState]]];
            
        }
        else if ([self.wallIdentifier isEqualToString:@"bottomWall"] || [self.wallIdentifier isEqualToString:@"topWall"])
        {
            SKAction *walkHorizontal = [SKAction moveByX:(walkDistance) y:0 duration:randomInterval];
            SKAction *resetState = [SKAction performSelector:@selector(resetState) onTarget:self];
            [self runAction:[SKAction sequence:@[walkHorizontal, resetState]]];
        }
    
    }
}

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    //Methods that should update every second
    //Making the moveToSpriteNode method update every second makes monster response time much better
    
    if (self.score.intValue > 100) //Introduce a small delay so that the monster does not immediately seek after the user
    {
        if (self.score.intValue <= 1000)
        {
            double time = ((double)arc4random()/ARC4_RNG_UPPERBOUND) + 2;
            
            if (_currentState == SVGMonsterStateIdle)
                [self moveToSpriteNode:self.target withTimeInterval:time];
        }
        else if (self.score.intValue > 1000 && self.score.intValue <= 3000)
        {
            double time = ((double)arc4random()/ARC4_RNG_UPPERBOUND) + 1.5;
            
            if (_currentState == SVGMonsterStateIdle)
                [self moveToSpriteNode:self.target withTimeInterval:time];
        }
        else if (self.score.intValue > 3000 && self.score.intValue <= 5000)
        {
            double time = ((double)arc4random()/ARC4_RNG_UPPERBOUND) + 1;
            
            if (_currentState == SVGMonsterStateIdle)
                [self moveToSpriteNode:self.target withTimeInterval:time];
        }
        else
        {
            double time = ((double)arc4random()/ARC4_RNG_UPPERBOUND) + 0.7;
            
            if (_currentState == SVGMonsterStateIdle)
                [self moveToSpriteNode:self.target withTimeInterval:time];
            
        }
    }

}

@end
