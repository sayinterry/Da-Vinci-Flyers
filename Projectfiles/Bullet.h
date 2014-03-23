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

@interface Bullet : CCSprite 
{
	CGPoint velocity;
	bool isPlayerBullet;
	bool isHomingBullet;
	bool isExplodingBullet;
	bool isBouncingBullet;
	bool isLaserSpawningBullet;
	float speed;
	bool laserInPlace;
	int updateCount;
	int nextShotTime;
	int laserShotsFired;
}

@property (readwrite, nonatomic) CGPoint velocity;
@property (readwrite, nonatomic) bool isPlayerBullet;

+(id) bullet;

-(void) die;
-(void) shootBossLaserAt:(CGPoint)startPosition velocity:(CGPoint)vel;
-(void) shootBulletAt:(CGPoint)startPosition velocity:(CGPoint)vel frameName:(NSString*)frameName isPlayerBullet:(bool)playerBullet;
-(void) shootBouncingBulletAt:(CGPoint)startPosition velocity:(CGPoint)vel frameName:(NSString*)frameName isPlayerBullet:(bool)playerBullet;
-(void) shootHomingBulletAt:(CGPoint)startPosition speed:(float)_speed frameName:(NSString*)frameName startAngle:(float)theta isPlayerBullet:(bool)playerBullet;
-(void) shootExplodingBulletAt:(CGPoint)startPosition velocity:(CGPoint)vel frameName:(NSString*)frameName isPlayerBullet:(bool)playerBullet;
-(void) shootLaserSpawningBulletAt:(CGPoint)startPosition velocity:(CGPoint)vel frameName:(NSString*)frameName;


@end
