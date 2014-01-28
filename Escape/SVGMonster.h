//
//  SVGMonster.h
//  Escape
//
//  Created by Steven Veshkini on 9/25/13.
//  Copyright (c) 2013 Steven Veshkini. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum uint8_t {
    SVGMonsterStateIdle = 1,
    SVGMonsterStateWalk = 2,
    SVGMonsterStateSeek = 4,
    SVGMonsterStateThrow = 8
} MonsterState;

@interface SVGMonster : SKSpriteNode
-(void)moveToSpriteNode:(SKSpriteNode *)target withTimeInterval:(NSTimeInterval)time;
-(void)endSeek;
-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast;
-(void)monsterWalk;
-(void)resetState;

@property (nonatomic) CGSize screenSize;
@property (nonatomic) SKSpriteNode *target;
@property (nonatomic) NSNumber *score;
@property (nonatomic) NSString *wallIdentifier;
@property (nonatomic) MonsterState currentState;

@end

