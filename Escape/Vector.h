//
//  Vector.h
//  Escape
//
//  Created by Steven Veshkini on 12/22/13.
//  Copyright (c) 2013 Steven Veshkini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector : NSObject
+(CGPoint)vectorAdd:(CGPoint)a :(CGPoint)b;
+(CGPoint)vectorSubtract:(CGPoint)a :(CGPoint)b;
+(CGPoint)vectorMultiplyByScalar:(CGPoint)a :(float)b;
+(CGPoint)vectorNormalize:(CGPoint)a;
@end
