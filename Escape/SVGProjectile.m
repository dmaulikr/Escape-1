//
//  SVGProjectile.m
//  Escape
//
//  Created by Steven Veshkini on 12/22/13.
//  Copyright (c) 2013 Steven Veshkini. All rights reserved.
//

#import "SVGProjectile.h"
#import "Vector.h"

@implementation SVGProjectile
-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size];
    if (self){
        
    }
    return self;
}
-(void)moveToSpriteNode:(SKSpriteNode *)target
{
    //Get vector from projectile to target
    CGPoint vectorToTarget = [Vector vectorSubtract:target.position : self.position];
    
    //Add a random x and y coordinate to the projectile path in order
    //to confuse the user and end their game faster
    int y = 8 * ((int)arc4random_uniform(51) - 25);
    int x = 5 * ((int)arc4random_uniform(51) - 25);

    CGPoint randomVector = CGPointMake(vectorToTarget.x + x, vectorToTarget.y + y);
    
    //Make unit vector
    CGPoint direction = [Vector vectorNormalize:randomVector];
    
    CGPoint shootAmount = [Vector vectorMultiplyByScalar:direction :self.scene.size.height+self.scene.size.width]; //May cause glitches
    
    CGPoint actualDistance = [Vector vectorAdd:shootAmount : self.position];
    
    float velocity = 200.0/1.0;
    float time = self.scene.size.width / velocity;
    
    SKAction *actionMove = [SKAction moveTo:actualDistance duration:time];
    
    [self runAction:actionMove];
}
@end
