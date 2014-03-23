/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim, Andreas Loew 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

//  Updated by Andreas Loew on 20.06.11:
//  * retina display
//  * framerate independency
//  * using TexturePacker http://www.texturepacker.com

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Bullet.h"

@interface BulletCache : CCNode 
{
	CCSpriteBatchNode* batch;
	NSUInteger nextInactiveBullet;
	CCArray* pBulletVisible;
	CCArray* eBulletVisible;
}

-(void) deleteAllEnemyBullets;
-(void) shootBulletFrom:(CGPoint)startPosition velocity:(CGPoint)velocity frameName:(NSString*)frameName isPlayerBullet:(bool)isPlayerBullet;
-(void) shootHomingBulletFrom:(CGPoint)startPosition speed:(float)speed frameName:(NSString*)frameName startAngle:(float)theta isPlayerBullet:(bool)isPlayerBullet;
-(void) shootBossLaserFrom:(CGPoint)startPosition velocity:(CGPoint)velocity;
-(void) shootBouncingBulletFrom:(CGPoint)startPosition velocity:(CGPoint)velocity frameName:(NSString*)frameName isPlayerBullet:(bool)isPlayerBullet;
-(bool) isPlayerBulletCollidingWithRect:(CGRect)rect;
-(bool) isEnemyBulletCollidingWithPlayer;
-(void) remove:(Bullet*)object isPlayerBullet:(bool)isPBullet;
-(void) shootExplodingBulletFrom:(CGPoint)startPosition velocity:(CGPoint)velocity frameName:(NSString*)frameName isPlayerBullet:(bool)isPlayerBullet;
-(void) shootLaserSpawningBulletFrom:(CGPoint)startPosition velocity:(CGPoint)velocity frameName:(NSString*)frameName;
-(int) getEBulletCount;

@end
