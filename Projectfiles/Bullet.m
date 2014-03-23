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

#import "Bullet.h"
#import "GameLayer.h"
#import "BulletCache.h"
#import "PlayerEntity.h"

@interface Bullet (PrivateMethods)
-(id) initWithBulletImage;
@end


@implementation Bullet

@synthesize velocity;
@synthesize isPlayerBullet;

+(id) bullet
{
	id bullet = [[self alloc] initWithBulletImage];
#ifndef KK_ARC_ENABLED
	[bullet autorelease];
#endif // KK_ARC_ENABLED
	return bullet;
}

-(id) initWithBulletImage
{
	// Uses the Texture Atlas now.
	if ((self = [super initWithSpriteFrameName:@"eBullet1.png"]))
	{
		self.rotation = 0;
	}
	
	return self;
}

-(void) shootBossLaserAt:(CGPoint)startPosition velocity:(CGPoint)vel {
	self.velocity = vel;
	self.position = startPosition;
	self.isPlayerBullet = false;
	isHomingBullet = false;
	isExplodingBullet = true;
	isBouncingBullet = false;
	isLaserSpawningBullet = false;
	self.visible = YES;
	self.scale = 1;
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"boss1_core.png"];
	CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:CCRANDOM_0_1()*0.25f+0.75f angle:360]];
	[self runAction:repeat];
	[self setDisplayFrame:frame];
	[self unscheduleUpdate];
	[self scheduleUpdate];
	
	
}

-(void) shootExplodingBulletAt:(CGPoint)startPosition velocity:(CGPoint)vel frameName:(NSString *)frameName isPlayerBullet:(bool)playerBullet {
	self.velocity = vel;
	self.position = startPosition;
	self.visible = YES;
	self.isPlayerBullet = playerBullet;
	isHomingBullet = false;
	isExplodingBullet = true;
	isBouncingBullet = false;
	isLaserSpawningBullet = false;
	
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
	[self setDisplayFrame:frame];
	self.rotation = atan2f(velocity.y, velocity.x)*(-180*M_1_PI);
	
	[self unscheduleUpdate];
	[self scheduleUpdate];
}

-(void) shootLaserSpawningBulletAt:(CGPoint)startPosition velocity:(CGPoint)vel frameName:(NSString *)frameName {
	self.velocity = vel;
	self.position = startPosition;
	self.visible = YES;
	self.isPlayerBullet = false;
	isHomingBullet = false;
	isExplodingBullet = false;
	isBouncingBullet = false;
	isLaserSpawningBullet = true;
	
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
	[self setDisplayFrame:frame];
	self.rotation = atan2f(velocity.y, velocity.x)*(-180*M_1_PI);
	
	[self unscheduleUpdate];
	[self scheduleUpdate];
}

-(void) shootBouncingBulletAt:(CGPoint)startPosition velocity:(CGPoint)vel frameName:(NSString*)frameName isPlayerBullet:(bool)playerBullet{
	self.velocity = vel;
	self.position = startPosition;
	self.visible = YES;
	self.isPlayerBullet = playerBullet;
	isHomingBullet = false;
	isExplodingBullet = false;
	isBouncingBullet = true;
	isLaserSpawningBullet = false;
	self.rotation = atan2f(vel.y, vel.x)*(-180*M_1_PI);
	
	// change the bullet's texture by setting a different SpriteFrame to be displayed
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
	[self setDisplayFrame:frame];
	
	[self unscheduleUpdate];
	[self scheduleUpdate];
	
	if ([frameName isEqual:@"boss1_core.png"]) {
		CCRotateBy* rotate = [CCRotateBy actionWithDuration:1 angle:-360];
		CCRepeatForever* repeat = [CCRepeatForever actionWithAction:rotate];
		[self runAction:repeat];
	}
}

// Re-Uses the bullet
-(void) shootBulletAt:(CGPoint)startPosition velocity:(CGPoint)vel frameName:(NSString*)frameName isPlayerBullet:(bool)playerBullet
{
	self.velocity = vel;
	self.position = startPosition;
	self.visible = YES;
	self.isPlayerBullet = playerBullet;
	isHomingBullet = false;
	isExplodingBullet = false;
	isBouncingBullet = false;
	isLaserSpawningBullet = false;
	self.rotation = atan2f(vel.y, vel.x)*(-180*M_1_PI);
	if ([frameName isEqualToString:@"laser1.png"]) {
		self.scaleX = 2.f;
		self.scaleY = 0.5f;
	}

	// change the bullet's texture by setting a different SpriteFrame to be displayed
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
	[self setDisplayFrame:frame];
	
	[self unscheduleUpdate];
	[self scheduleUpdate];
	
	if ([frameName isEqual:@"eBullet1.png"]) {
		CCRotateBy* rotate = [CCRotateBy actionWithDuration:1 angle:-360];
		CCRepeatForever* repeat = [CCRepeatForever actionWithAction:rotate];
		[self runAction:repeat];
	}
	if ([frameName isEqual: @"pBullet.png"] || [frameName isEqual:@"eBullet1.png"]) {
		NSString* fix = [frameName stringByDeletingPathExtension];
		CCAnimation* anim = [CCAnimation animationWithFrames:[NSString stringWithFormat:@"%@_anim", fix] frameCount:2 delay:0.12f];
		
		// run the animation by using the CCAnimate action
		CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
		CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
		[self runAction:repeat];
	}
	if ([frameName isEqual:@"eBullet-corndog.png"]) {
		self.rotation = atan2f(vel.y, vel.x)*(-180*M_1_PI);
	}
}

-(void) shootHomingBulletAt:(CGPoint)startPosition speed:(float)_speed frameName:(NSString*)frameName startAngle:(float)theta isPlayerBullet:(bool)playerBullet
{
	speed = _speed;
	float xVel = speed*cosf(theta);
	float yVel = speed*sinf(theta);
	self.velocity = ccp(xVel, yVel);
	self.position = startPosition;
	self.visible = YES;
	self.isPlayerBullet = playerBullet;
	isHomingBullet = true;
	isExplodingBullet = false;
	isBouncingBullet = false;;
	
	// change the bullet's texture by setting a different SpriteFrame to be displayed
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
	[self setDisplayFrame:frame];
	
	[self unscheduleUpdate];
	[self scheduleUpdate];
	self.rotation = theta*(-180*M_1_PI);
}

-(void) die {
	[self setVisible:NO];
	[self stopAllActions];
	[self unscheduleUpdate];
	self.rotation = 0;
	self.scaleX = 1;
	self.scaleY = 1;
	BulletCache* bCache = [[GameLayer sharedGameLayer] bulletCache];
	[bCache remove:self isPlayerBullet:self.isPlayerBullet];
}

-(void) update:(ccTime)delta
{
	GameLayer* game = [GameLayer sharedGameLayer];
    if ([game isBombed] && !self.isPlayerBullet) {
        [self die];
    } else {
		self.position = ccpAdd(self.position, ccpMult(velocity, 0.01667f));
		if (isHomingBullet) {
			if (powf((self.position.x-[game defaultShip].position.x),2)+powf(self.position.y-[game defaultShip].position.y, 2) >= 100*100) {
				float theta2 = atan2f(([[game defaultShip] boundingBoxCenter].y-self.position.y), ([[game defaultShip]  boundingBoxCenter].x-self.position.x));
				float nTheta = theta2;
				float xVel = speed*cosf(nTheta);
				float yVel = speed*sinf(nTheta);
				velocity = ccp(xVel, yVel);
				self.rotation = nTheta*(-180*M_1_PI);
			} else {
				velocity = ccpAdd(velocity, ccp(velocity.x*0.18f,velocity.y*0.18f));
				if (powf(velocity.x, 2)+powf(velocity.y,2) >= 430*430) {
					isHomingBullet = false;
				}
			}
		} else if (isBouncingBullet) {
			if (self.position.x < self.contentSize.width*0.5f) {
				CGPoint nVel = ccp(-velocity.x, velocity.y);
				velocity = nVel;
				self.rotation = atan2f(velocity.y, velocity.x)*(-180*M_1_PI);
			}
			if (self.position.y < self.contentSize.height*0.5f || self.position.y > [GameLayer screenRect].size.height-self.contentSize.height*0.5f) {
				CGPoint nVel = ccp(velocity.x, -velocity.y);
				velocity = nVel;
				self.rotation = atan2f(velocity.y, velocity.x)*(-180*M_1_PI);
			}
		} else if (isLaserSpawningBullet) {
			if (game.inBossFight) {
				if (self.position.x < self.contentSize.width*0.5f ||  self.position.y < self.contentSize.height*0.5f || self.position.y > [GameLayer screenRect].size.height-self.contentSize.height*0.5f) {
					velocity = ccp(0,0);
					CGPoint vel;
					if (self.position.x < self.contentSize.width*0.5f) {
						vel = ccp(740,0);
						
					} else if (self.position.y < self.contentSize.height*0.5f) {
						vel = ccp(0, 740);
					} else {
						vel = ccp(0,-740);
					}
					updateCount++;
					if (updateCount > nextShotTime) {
						if (laserShotsFired < 40) {
							[[game bulletCache] shootBulletFrom:self.position velocity:vel frameName:@"laser1.png" isPlayerBullet:false];
							laserShotsFired++;
						} else {
							[self die];
						}
					}
				} else {
					updateCount = 0;
					laserShotsFired = 0;
					nextShotTime = 140;
				}
			} else {
				[self die];
			}
		}
		
		// When the bullet leaves the screen, make it invisible
		if (CGRectIntersectsRect([self boundingBox], [GameLayer screenRect]) == NO)
		{
			[self die];
		}
    }
}

@end
