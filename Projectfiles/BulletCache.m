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

#import "BulletCache.h"
#import "Bullet.h"
#import "GameLayer.h"
#import "PlayerEntity.h"

@implementation BulletCache

-(id) init
{
	if ((self = [super init]))
	{
		// get any bullet image from the Texture Atlas we're using
		CCSpriteFrame* bulletFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pBullet.png"];
		// use the bullet's texture (which will be the Texture Atlas used by the game)
		batch = [CCSpriteBatchNode batchNodeWithTexture:bulletFrame.texture];
		pBulletVisible = [[CCArray alloc] init];
		eBulletVisible = [[CCArray alloc] init];
		[self addChild:batch z:1 tag:15];
		
		// Create a number of bullets up front and re-use them whenever necessary.
		for (int i = 0; i < 3000; i++)
		{
			Bullet* bullet = [Bullet bullet];
			bullet.visible = NO;
			[batch addChild:bullet];
		}
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamePaused) name:@"GamePaused" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameResumed) name:@"GameResumed" object:nil];
	}
	
	return self;
}

-(void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
#ifndef KK_ARC_ENABLED
	[pBulletVisible release];
	[eBulletVisible release];
	[super dealloc];
#endif
}

-(void) gamePaused {
	[self pauseSchedulerAndActions];
	
	Bullet *bullet;
	CCARRAY_FOREACH(pBulletVisible, bullet) {
		[bullet pauseSchedulerAndActions];
	}
	CCARRAY_FOREACH(eBulletVisible, bullet) {
		[bullet pauseSchedulerAndActions];
	}
}

-(void) gameResumed {
	[self resumeSchedulerAndActions];
	
	Bullet *bullet;
	CCARRAY_FOREACH(pBulletVisible, bullet) {
		[bullet resumeSchedulerAndActions];
	}
	CCARRAY_FOREACH(eBulletVisible, bullet) {
		[bullet resumeSchedulerAndActions];
	}
}

-(void) remove:(Bullet*)object isPlayerBullet:(bool)isPBullet {
	if (isPBullet) {
		[pBulletVisible removeObject:object];
	} else {
		[eBulletVisible removeObject:object];
	}
}

-(void) shootBulletFrom:(CGPoint)startPosition velocity:(CGPoint)velocity frameName:(NSString*)frameName isPlayerBullet:(bool)isPlayerBullet
{
	CCArray* bullets = [batch children];
	CCNode* node = [bullets objectAtIndex:nextInactiveBullet];
	NSAssert([node isKindOfClass:[Bullet class]], @"not a Bullet!");
	
	Bullet* bullet = (Bullet*)node;
	[bullet shootBulletAt:startPosition velocity:velocity frameName:frameName isPlayerBullet:isPlayerBullet];
	if (isPlayerBullet) {
		[pBulletVisible addObject:bullet];
	} else {
		[eBulletVisible addObject:bullet];
	}
	
	nextInactiveBullet++;
	if (nextInactiveBullet >= [bullets count])
	{
		nextInactiveBullet = 0;
	}
}

-(void) shootLaserSpawningBulletFrom:(CGPoint)startPosition velocity:(CGPoint)velocity frameName:(NSString*)frameName {
	CCArray* bullets = [batch children];
	CCNode* node = [bullets objectAtIndex:nextInactiveBullet];
	NSAssert([node isKindOfClass:[Bullet class]], @"not a Bullet!");
	
	Bullet* bullet = (Bullet*)node;
	[bullet shootLaserSpawningBulletAt:startPosition velocity:velocity frameName:frameName];
	[eBulletVisible addObject:bullet];
	
	nextInactiveBullet++;
	if (nextInactiveBullet >= [bullets count])
	{
		nextInactiveBullet = 0;
	}
}

-(void) shootBouncingBulletFrom:(CGPoint)startPosition velocity:(CGPoint)velocity frameName:(NSString*)frameName isPlayerBullet:(bool)isPlayerBullet
{
	CCArray* bullets = [batch children];
	CCNode* node = [bullets objectAtIndex:nextInactiveBullet];
	NSAssert([node isKindOfClass:[Bullet class]], @"not a Bullet!");
	
	Bullet* bullet = (Bullet*)node;
	[bullet shootBouncingBulletAt:startPosition velocity:velocity frameName:frameName isPlayerBullet:isPlayerBullet];
	
	if (isPlayerBullet) {
		[pBulletVisible addObject:bullet];
	} else {
		[eBulletVisible addObject:bullet];
	}
	
	nextInactiveBullet++;
	if (nextInactiveBullet >= [bullets count])
	{
		nextInactiveBullet = 0;
	}
}

-(void) shootBossLaserFrom:(CGPoint)startPosition velocity:(CGPoint)velocity {
	CCArray* bullets = [batch children];
	CCNode* node = [bullets objectAtIndex:nextInactiveBullet];
	NSAssert([node isKindOfClass:[Bullet class]], @"not a Bullet!");
	
	Bullet* bullet = (Bullet*)node;
	[bullet shootBossLaserAt:startPosition velocity:velocity];
	[eBulletVisible addObject:bullet];
	
	nextInactiveBullet++;
	if (nextInactiveBullet >= [bullets count])
	{
		nextInactiveBullet = 0;
	}
}

-(void) deleteAllEnemyBullets {
	CCNode *node;
	for (node in eBulletVisible) {
		Bullet *bullet = (Bullet*)node;
		[bullet die];
	}
}

-(void) shootHomingBulletFrom:(CGPoint)startPosition speed:(float)speed frameName:(NSString*)frameName startAngle:(float)theta isPlayerBullet:(bool)isPlayerBullet {
	CCArray* bullets = [batch children];
	CCNode* node = [bullets objectAtIndex:nextInactiveBullet];
	NSAssert([node isKindOfClass:[Bullet class]], @"not a Bullet!");
	
	Bullet* bullet = (Bullet*)node;
	[bullet shootHomingBulletAt:startPosition speed:speed frameName:frameName startAngle:theta isPlayerBullet:isPlayerBullet];
	if (isPlayerBullet) {
		[pBulletVisible addObject:bullet];
	} else {
		[eBulletVisible addObject:bullet];
	}
	
	nextInactiveBullet++;
	if (nextInactiveBullet >= [bullets count])
	{
		nextInactiveBullet = 0;
	}
}

-(void) shootExplodingBulletFrom:(CGPoint)startPosition velocity:(CGPoint)velocity frameName:(NSString*)frameName isPlayerBullet:(bool) isPlayerBullet {
	CCArray* bullets = [batch children];
	CCNode* node = [bullets objectAtIndex:nextInactiveBullet];
	NSAssert([node isKindOfClass:[Bullet class]], @"not a Bullet!");
	
	Bullet* bullet = (Bullet*)node;
	[bullet shootExplodingBulletAt:startPosition velocity:velocity frameName:frameName isPlayerBullet:isPlayerBullet];
	if (isPlayerBullet) {
		[pBulletVisible addObject:bullet];
	} else {
		[eBulletVisible addObject:bullet];
	}
	
	nextInactiveBullet++;
	if (nextInactiveBullet >= [bullets count])
	{
		nextInactiveBullet = 0;
	}
}

-(bool) isEnemyBulletCollidingWithPlayer {
	bool isColliding = NO;
	
	Bullet* bullet;
	PlayerEntity* player = [[GameLayer sharedGameLayer] defaultShip];
	float radius = [player getChildByTag:11].contentSize.width*0.5f;
	CGPoint pos = ccpAdd(player.boundingBox.origin, [player getChildByTag:11].boundingBoxCenter);
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"laser1.png"];
	CCSpriteFrame *frame2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"eBullet-fry.png"];
	CCARRAY_FOREACH(eBulletVisible, bullet) {
		if ([bullet isFrameDisplayed:frame] || [bullet isFrameDisplayed:frame2]) {
			if (CGRectContainsPoint(bullet.boundingBox, pos)) {
				isColliding = YES;
				
				// remove the bullet
				[bullet die];
				break;
			}
		} else {
			if (powf(pos.x-bullet.position.x,2)+powf(pos.y-bullet.position.y,2) <= (powf(radius+bullet.contentSize.width*0.46f,2))) {
				isColliding = YES;
				
				// remove the bullet
				[bullet die];
				break;
			}
		}
	}
	return isColliding;
}

-(bool) isPlayerBulletCollidingWithRect:(CGRect)rect {
	bool isColliding = NO;
	
	Bullet* bullet;
	CCARRAY_FOREACH(pBulletVisible, bullet) {
		CGRect bbox = [bullet boundingBox];
			
		if (CGRectIntersectsRect(bbox, rect)) {
			isColliding = YES;
				
			// remove the bullet
			[bullet die];
			break;
		}
	}
	return isColliding;
}

-(int) getEBulletCount {
	int count = [eBulletVisible count];
	return count;
}
@end
