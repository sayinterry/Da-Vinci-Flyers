/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EnemyEntity.h"

@interface EnemyCache : CCNode 
{
	CCSpriteBatchNode* batch;
	CCArray* enemies;
	CCArray* visibleEnemies;
	CCArray* bossArray;
	
	NSNumber *spawnInt;
	NSNumber *spawnInt2;
    
    float timepassed;
	
	int updateCount;
	int nextCountTime;
}

-(bool) isEnemyCollidingWithRect:(CGRect)rect;
-(void) removeFromVisibleEnemyArray:(EnemyEntity*)enemy;
-(void) spawnEnemyPattern:(NSNumber*)pattern;

@end
