//
//  Vector.m
//  Escape
//
//  Created by Steven Veshkini on 12/22/13.
//  Copyright (c) 2013 Steven Veshkini. All rights reserved.
//

#import "Vector.h"

@implementation Vector

#pragma mark Vector Math Methods

+(CGPoint)vectorAdd:(CGPoint)a :(CGPoint)b
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

+(CGPoint)vectorSubtract:(CGPoint)a :(CGPoint)b
{
    return CGPointMake(a.x - b.x, a.y - b.y);
}

+(CGPoint)vectorMultiplyByScalar:(CGPoint)a :(float)b
{
    return CGPointMake(a.x* b, a.y * b);
}

static float resultantVectorLength(CGPoint a)
{
    return sqrtf(a.x * a.x + a.y * a.y);
}

+(CGPoint)vectorNormalize:(CGPoint)a
{
    float length = resultantVectorLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

@end
