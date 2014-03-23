//
//  Boss1TriangleNode.m
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 7/11/13.
//
//

#import "Boss1TriangleNode.h"
#import "GameLayer.h"
#import "BulletCache.h"
#import "EnemyEntity.h"
#import "PlayerEntity.h"
#import "EnemyCache.h"

@implementation Boss1TriangleNode


-(id) initWithSpriteFrameName:(NSString *)spriteFrameName {
	if (self = [super initWithSpriteFrameName:spriteFrameName]) {
		self.rotation = -90;
		fired = false;
		parentState = @"standby";
	}
	return self;
}

-(void)setUp {
	parentBoss = (EnemyEntity*)self.parent;
	point1 = CGPointMake(-self.contentSize.width*0.5f, parentBoss.contentSize.height*0.5f);
	point2 = CGPointMake(self.contentSize.width*0.5f, parentBoss.contentSize.height*0.5f+self.contentSize.height*0.8f);
	point3 = CGPointMake(self.contentSize.width*0.5f, parentBoss.contentSize.height*0.5f-self.contentSize.height*0.8f);
	rotateCount = mobID;
	[self scheduleUpdate];
}

-(void)setMobID:(int)ID {
	mobID = ID;
	if (mobID == 1) {
		[self setColor:ccc3(255, 0, 0)];
	} else if (mobID == 2) {
		[self setColor:ccc3(0, 255, 0)];
	} else if (mobID == 3) {
		[self setColor:ccc3(0, 0, 255)];
	}
}

-(void)update:(ccTime)delta {
	parentBoss = (EnemyEntity*)self.parent;
	updateCount = parentBoss.updateCount;
	id moveAction;
	parentState = [parentBoss state];
	if (fmodf(updateCount, 60) == 0) {
		rotateCount++;
		if (rotateCount >= 4) {
			rotateCount = 1;
		}
	}
	if ([parentState isEqual: @"standby"]) {
		attackPattern = 0;
		if (rotateCount == 1) {
			moveAction = [CCMoveTo actionWithDuration:0.2f position:point1];
		} else if (rotateCount == 2) {
			moveAction = [CCMoveTo actionWithDuration:0.2f position:point2];
		} else if (rotateCount == 3) {
			moveAction = [CCMoveTo actionWithDuration:0.2f position:point3];
		}
		if ([self numberOfRunningActions] == 0) {
			if ([parentBoss inPlace]) {
				[self shootPattern];
			}
			[self runAction:moveAction];
		}
		[[[GameLayer sharedGameLayer] enemyCache] isEnemyCollidingWithRect:[[GameLayer sharedGameLayer] defaultShip].boundingBox];
	} else if ([parentState isEqualToString:@"fireTriangle"]) {
		if ([self numberOfRunningActions] <= 1) {
			attackPattern = 1;
			repeat = [CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.2 angle:200]];
			[self runAction:repeat];
			if (mobID == 1) {
				nextFireTime = updateCount + 120;
			} else if (mobID == 2) {
				nextFireTime = updateCount + 240;
			} else if (mobID == 3) {
				nextFireTime = updateCount + 360;
			}
		}
		if (updateCount == nextFireTime && !fired) {
			[self runAction:[CCCallFunc actionWithTarget:self selector:@selector(launchAction)]];
		}
		if (fmodf(updateCount, 6) == 0) {
			[self shootPattern];
		}
	} else if ([parentState isEqualToString:@"fireLasers"]) {
		if (nextFireTime == 0) {
			nextFireTime = updateCount+300;
		}
		if (updateCount < nextFireTime && attackPattern != 2) {
			attackPattern = 2;
			id rotateAction;
			id moveAction;
			if (mobID == 2) {
				CGPoint point = ccp([GameLayer screenRect].size.width*0.5f, [GameLayer screenRect].size.height-self.contentSize.height*0.5f);
				parentBoss = (EnemyEntity*)self.parent;
				point = [parentBoss convertToNodeSpace:point];
				rotateAction = [CCRotateTo actionWithDuration:1 angle:-180];
				moveAction = [CCMoveTo actionWithDuration:0.43f position:point];
			} else if (mobID == 3) {
				CGPoint point = ccp([GameLayer screenRect].size.width*0.5f, self.contentSize.height*0.5f);
				parentBoss = (EnemyEntity*)self.parent;
				point = [parentBoss convertToNodeSpace:point];
				rotateAction = [CCRotateTo actionWithDuration:1 angle:0];
				moveAction = [CCMoveTo actionWithDuration:0.43f position:point];
				
			} else if (mobID == 1) {
				CGPoint point = ccp([GameLayer screenRect].size.width-self.contentSize.width*0.5f, [GameLayer screenRect].size.height*0.5f);
				parentBoss = (EnemyEntity*)self.parent;
				point = [parentBoss convertToNodeSpace:point];
				rotateAction = [CCRotateTo actionWithDuration:1 angle:-90];
				moveAction = [CCMoveTo actionWithDuration:0.43f position:point];
			}
			[self runAction:rotateAction];
			[self runAction:moveAction];
		} else if (updateCount < nextFireTime && [self numberOfRunningActions] == 0) {
			count = 0;
			id moveAction;
			if (mobID == 1) {
				CGPoint point = ccp([GameLayer screenRect].size.width-self.contentSize.width*0.5f, [[GameLayer sharedGameLayer] defaultShip].position.y);
				parentBoss = (EnemyEntity*)self.parent;
				point = [parentBoss convertToNodeSpace:point];
				moveAction = [CCMoveTo actionWithDuration:0.01f position:point];
			} else if (mobID == 2) {
				CGPoint point = ccp([[GameLayer sharedGameLayer] defaultShip].position.x, [GameLayer screenRect].size.height-self.contentSize.height*0.5f);
				parentBoss = (EnemyEntity*)self.parent;
				point = [parentBoss convertToNodeSpace:point];
				moveAction = [CCMoveTo actionWithDuration:0.1f position:point];
			} else if (mobID == 3) {
				CGPoint point = ccp([[GameLayer sharedGameLayer] defaultShip].position.x, self.contentSize.height*0.5f);
				parentBoss = (EnemyEntity*)self.parent;
				point = [parentBoss convertToNodeSpace:point];
				moveAction = [CCMoveTo actionWithDuration:0.1f position:point];
			}
			[self runAction:moveAction];
		} else if (updateCount > nextFireTime) {
			[self shootPattern];
			count++;
			if (count > 440) {
				fired = true;
			}
		}
	}
}

-(void)setFireTrue {
	fired = true;
}

-(void) resetToStandby {
	[self stopAllActions];
	id moveAction;
	if (mobID == 1) {
		moveAction = [CCMoveTo actionWithDuration:0.5f position:point1];
	} else if (mobID == 2) {
		moveAction = [CCMoveTo actionWithDuration:0.5f position:point2];
	} else {
		moveAction = [CCMoveTo actionWithDuration:0.5f position:point3];
	}
	fired = false;
	nextFireTime = 0;
	id rotateAction = [CCRotateTo actionWithDuration:0.1f angle:-90];
	count = 0;
	[self runAction:[CCSequence actions:rotateAction,moveAction, nil]];
}

-(bool)getFired {
	return fired;
}

-(void)shootPattern {
	GameLayer *game = [GameLayer sharedGameLayer];
	if (attackPattern == 0) {
		CGPoint startPos = ccp((self.position.x-self.contentSize.width*0.5f)+(parentBoss.position.x-parentBoss.contentSize.width*0.5f), parentBoss.position.y-(self.position.y-self.contentSize.height*0.5f));
		CGPoint velocity = ccp(-200,0);
		NSString *bulletFrameName = @"eBullet1.png";
		[[game bulletCache] shootBulletFrom:startPos velocity:velocity frameName:bulletFrameName isPlayerBullet:NO];
	} else if (attackPattern == 1) {
		CGPoint startPos = ccp(self.position.x+(parentBoss.position.x-parentBoss.contentSize.width*0.5f), (parentBoss.position.y+(self.position.y-self.contentSize.height*0.5f)));
		float veloX = 22*cosf(self.rotation);
		float veloY = 22*sinf(self.rotation);
		CGPoint velocity = CGPointMake(veloX, veloY);
		NSString *bulletFrameName = @"eBullet1.png";
		[[game bulletCache] shootBulletFrom:startPos velocity:velocity frameName:bulletFrameName isPlayerBullet:NO];
	} else if (attackPattern == 2) {
		CGPoint velocity;
		CGPoint startPos;
		bool isCoreTriangle = false;
		if (mobID == 1) {
			velocity = ccp(-600, 0);
			startPos = parentBoss.position;
			isCoreTriangle = true;
		} else if (mobID == 2) {
			velocity = ccp(0, -600);
			startPos = ccp(self.position.x+(parentBoss.position.x-parentBoss.contentSize.width*0.5f), (parentBoss.position.y+(self.position.y-self.contentSize.height*0.5f)));
		} else if (mobID == 3) {
			velocity = ccp(0, 600);
			startPos = ccp(self.position.x+(parentBoss.position.x-parentBoss.contentSize.width*0.5f), (parentBoss.position.y+(self.position.y-self.contentSize.height*0.5f)));
		}
		//[[game bulletCache] shootBossLaserFrom:startPos velocity:velocity rotation:self.rotation+90 coreTriangle:isCoreTriangle];
	}
}

-(id)launchAction {
	CGPoint returnPoint = self.position;
	CGPoint point = [[[GameLayer sharedGameLayer] defaultShip] position];
	parentBoss = (EnemyEntity*)self.parent;
	point = [parentBoss convertToNodeSpace:point];
	id moveAction = [CCMoveTo actionWithDuration:0.64f position:point];
	id moveAction2 = [CCMoveTo actionWithDuration:0.5f position:returnPoint];
	id delayAction = [CCDelayTime actionWithDuration:0.3f];
	id setFireTrue = [CCCallFunc actionWithTarget:self selector:@selector(setFireTrue)];
	return [self runAction:[CCSequence actions:moveAction, delayAction, moveAction2, setFireTrue, nil]];
}

@end
