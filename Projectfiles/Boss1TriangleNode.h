//
//  Boss1TriangleNode.h
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 7/11/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EnemyEntity.h"

@interface Boss1TriangleNode : CCSprite
{
	EnemyEntity* parentBoss;
	CGPoint point1;
	CGPoint point2;
	CGPoint point3;
	int mobID;
	float updateCount;
	NSString* parentState;
	int rotateCount;
	int attackPattern;
	bool fired;
	int nextFireTime;
	int count;
	CCRepeatForever *repeat;
}

-(void)setMobID:(int)ID;
-(void)setUp;
-(id)initWithSpriteFrameName:(NSString*)SpriteFrameName;
-(void)resetToStandby;
-(bool)getFired;

@end
