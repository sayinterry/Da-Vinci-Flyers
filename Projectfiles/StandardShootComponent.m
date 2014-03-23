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

#import "StandardShootComponent.h"
#import "BulletCache.h"
#import "GameLayer.h"
#import "PlayerEntity.h"
#import "EnemyCache.h"

#import "SimpleAudioEngine.h"

@implementation StandardShootComponent

@synthesize bulletFrameName;
@synthesize pattern;

-(id) init
{
	if ((self = [super init]))
	{
        inCD = false;
		nextShotTime = 0;
		maxShots = 0;
		shotDelay = 0;
		CDDelay = 0;
		bulletSpeed = 0;
		piOver6 = 0.52359877559;
		[self scheduleUpdate];
	}
	
	return self;
}

-(void)bossTypeInit:(EnemyTypes)bossType {
	switch (bossType) {
		case EnemyTypeBoss1:
			maxShots = 5;
            shotDelay = 0.4f;
            CDDelay = 1;
            bulletSpeed = 98;
			break;
		case EnemyTypeBoss2:
			maxShots = 1;
            shotDelay = 0.1f;
            CDDelay = 0;
            velocity = ccp(-180,0);
			break;
		case EnemyTypeBoss3:
			maxShots = 1;
            shotDelay = 1;
            CDDelay = 0;
			break;
			
		default:
			break;
	}
	shotsRemaining = maxShots;
}

-(void) assignPattern:(EnemyPattern)p {
    pattern = p;
    switch (pattern) {
        case Square1P1:
            maxShots = 10;
            shotDelay = 0.05f;
            CDDelay = 5;
            bulletSpeed = 151;
            break;
        case OctagonP1:
            maxShots = 5;
            shotDelay = 0.185f;
            CDDelay = 4.f;
            bulletSpeed = 130;
            break;
        case Square1P2:
            maxShots = 3;
            shotDelay = 0.087f;
            CDDelay = 4.f;
            bulletSpeed = 56;
            break;
		case CrossP1:
			maxShots = 240;
			shotDelay = 0.005f;
			bulletSpeed = -1000;
			CDDelay = 4.f;
			break;
		case FryMinionP1:
			maxShots = 1;
			shotDelay = 0.4f;
			bulletSpeed = 110;
			CDDelay = 0;
			break;
		case FryMinionP2:
			maxShots = 1;
			shotDelay = 0.42f;
			bulletSpeed = 110;
			CDDelay = 0;
			break;
        default:
            shotDelay = CCRANDOM_0_1()*0.8f+1.6f;
            CDDelay = 1.7f;
            maxShots = 1;
            bulletSpeed = 115;
            break;
    }
	shotsRemaining = maxShots;
}

-(void) dealloc
{
#ifndef KK_ARC_ENABLED
	[bulletFrameName release];
	[pattern release];
	[super dealloc];
#endif // KK_ARC_ENABLED
}

-(void) bossAttackPattern:(NSString*)bossState {
	if (self.parent.visible) {
		CGPoint startPos;
		GameLayer* game = [GameLayer sharedGameLayer];
		EnemyEntity *eEntity = (EnemyEntity*)self.parent;
		if (eEntity.type == EnemyTypeBoss1) {
			if ([bossState isEqualToString:@"standby"]) {
				startPos = ccpAdd(eEntity.position, ccp(-eEntity.contentSize.width*0.3f, eEntity.size.height*0.27f));
				float theta = atan2f(([[game defaultShip] boundingBoxCenter].y-startPos.y), ([[game defaultShip]  boundingBoxCenter].x-startPos.x));
				for (int i=0; i<3; i++) {
					float veloY = bulletSpeed*sinf(theta-piOver6*(i-1));
					float veloX = bulletSpeed*cosf(theta-piOver6*(i-1));
					velocity = CGPointMake(veloX, veloY);
					[game.bulletCache shootBulletFrom:startPos velocity:velocity frameName:bulletFrameName isPlayerBullet:NO];
				}
			} else if ([bossState isEqualToString:@"homingDogs"]) {
				startPos = ccpAdd(eEntity.position, ccp(-eEntity.contentSize.width*0.3f, eEntity.size.height*0.27f));
				float theta = atan2f(([[game defaultShip] boundingBoxCenter].y-startPos.y), ([[game defaultShip]  boundingBoxCenter].x-startPos.x));
				[game.bulletCache shootHomingBulletFrom:startPos speed:bulletSpeed frameName:@"eBullet-corndog.png" startAngle:theta isPlayerBullet:false];
			} else if ([bossState isEqualToString:@"rush"]) {
				if (eEntity.inPlace) {
					if (eEntity.position.y > [GameLayer screenRect].size.height*0.5f) {
						startPos = ccpAdd(eEntity.position, ccp(0, -eEntity.size.height*0.27f));
						velocity = ccp(0, -250);
					} else {
						velocity = ccp(0,250);
						startPos = ccpAdd(eEntity.position, ccp(0, eEntity.size.height*0.42f));
					}
					[game.bulletCache shootBulletFrom:startPos velocity:velocity frameName:bulletFrameName isPlayerBullet:NO];
				}
			}
		} else if (eEntity.type == EnemyTypeBoss2) {
			if ([bossState isEqualToString:@"standby"]) {
				startPos = ccpAdd(eEntity.position, ccp(-eEntity.contentSize.width*0.5f, eEntity.contentSize.height*0.4f));
				[game.bulletCache shootBulletFrom:startPos velocity:velocity frameName:bulletFrameName isPlayerBullet:NO];
			} else if ([bossState isEqualToString:@"sesameGatling-fire"]) {
				startPos = ccpAdd(eEntity.position, ccp((-eEntity.contentSize.width*0.5f-2)+(CCRANDOM_0_1()*4), (eEntity.size.height*0.5f-15)+(CCRANDOM_0_1()*7.5f)));
				float theta = atan2f(([[game defaultShip] boundingBoxCenter].y-startPos.y), ([[game defaultShip]  boundingBoxCenter].x-startPos.x));
				theta = (theta-0.2f)+CCRANDOM_0_1()*0.4f;
				float speed = 250;
				CGPoint shootSpeed = ccp(speed*cosf(theta),speed*sinf(theta));
				[game.bulletCache shootBulletFrom:startPos velocity:shootSpeed frameName:@"eBullet1.png" isPlayerBullet:NO];
			} else if ([bossState isEqualToString:@"ketchupLaser-fire"]) {
				float theta = [eEntity rotation]*(M_PI/180);
				startPos = ccpAdd(eEntity.position, ccp(-eEntity.contentSize.width*0.5f*cosf(theta), eEntity.contentSize.width*0.4f*sinf(theta)));
				CGPoint speed = ccp(-400*cosf(theta),400*sinf(theta));
				[game.bulletCache shootBossLaserFrom:startPos velocity:speed];
			}
		} else if (eEntity.type == EnemyTypeBoss3) {
			if ([bossState isEqualToString:@"standby"]) {
				EnemyCache *eCache = [[GameLayer sharedGameLayer] enemyCache];
				BulletCache *bCache = [game bulletCache];
				[eCache spawnEnemyPattern:[NSNumber numberWithInt:FryMinionP1]];
				[eCache spawnEnemyPattern:[NSNumber numberWithInt:FryMinionP2]];
				startPos = ccpAdd(self.parent.position, ccp(-self.contentSize.width*0.5f,0));
				CGPoint vel = ccp(-100,70);
				CGPoint vel2 = ccp(-100, -70);
				[bCache shootBouncingBulletFrom:startPos velocity:vel frameName:@"boss1_core.png" isPlayerBullet:NO];
				[bCache shootBouncingBulletFrom:startPos velocity:vel2 frameName:@"boss1_core.png" isPlayerBullet:NO];
			} else if ([bossState isEqualToString:@"laserHell"]) {
				startPos = ccpAdd(self.parent.position, ccp(-self.contentSize.width*0.5f,0));
				float theta = CCRANDOM_0_1()*2-1;
				float xVel = 130*-cos(theta);
				float yVel = 130*sin(theta);
				
				[game.bulletCache shootLaserSpawningBulletFrom:startPos velocity:ccp(xVel, yVel) frameName:@"boss1_core.png"];
			}
		}
	}
}

-(void) resetCD {
    inCD = false;
	shotsRemaining = maxShots;
	shotsFired = 0;
	EnemyEntity *eEntity = (EnemyEntity*)self.parent;
	if (eEntity.type < EnemyTypeBoss1) {
		[eEntity setState:nil];
	}
}

-(void) ShootPattern:(EnemyPattern)pat {
    if (self.parent.visible) {
        CGPoint startPos;
        GameLayer* game = [GameLayer sharedGameLayer];
        if (!game.inBossFight || pat == FryMinionP1 || pat == FryMinionP2) {
			startPos = ccpSub(self.parent.position, CGPointMake(self.parent.contentSize.width * 0.5f, 0));
			if (pat <= HexagonP13){
				startPos = self.parent.position;
				float theta = atan2f(([[game defaultShip] boundingBoxCenter].y-startPos.y), ([[game defaultShip]  boundingBoxCenter].x-startPos.x));
				float veloY = bulletSpeed*sinf(theta);
				float veloX = bulletSpeed*cosf(theta);
				velocity = CGPointMake(veloX, veloY);
				[game.bulletCache shootBulletFrom:startPos velocity:velocity frameName:bulletFrameName isPlayerBullet:NO];
			} else if (pat == Square1P1) {
				startPos = ccpAdd(self.parent.position, ccp((-self.parent.contentSize.width*0.5f-2)+(CCRANDOM_0_1()*4), 0));
				float theta = atan2f(([[game defaultShip] boundingBoxCenter].y-startPos.y), ([[game defaultShip]  boundingBoxCenter].x-startPos.x));
				theta = (theta-0.2f)+CCRANDOM_0_1()*0.4f;
				CGPoint shootSpeed = ccp(bulletSpeed*cosf(theta),bulletSpeed*sinf(theta));
				[game.bulletCache shootBulletFrom:startPos velocity:shootSpeed frameName:@"eBullet1.png" isPlayerBullet:NO];
				
			} else if (pat == OctagonP1) {
				startPos = ccpSub(self.parent.position, CGPointMake(self.parent.contentSize.width * 0.06f, 0));
				for (int i=0; i<15; i++) {
					if (self.parent.visible == false) {
						break;
					}
					float theta = piOver6*i;
					float veloX = bulletSpeed*cosf(theta);
					float veloY = bulletSpeed*sinf(theta);
					velocity = CGPointMake(veloX, veloY);
					[game.bulletCache shootBulletFrom:startPos velocity:velocity frameName:bulletFrameName isPlayerBullet:NO];
				}
			} else if (pat == FryMinionP1) {
				startPos = ccp(self.parent.position.x, self.parent.position.y+self.parent.size.height*0.5f);
				velocity = ccp(0, bulletSpeed);
				[game.bulletCache shootBulletFrom:startPos velocity:velocity frameName:bulletFrameName isPlayerBullet:NO];
			} else if (pat == FryMinionP2) {
				id block = [CCCallBlock actionWithBlock:^{
					CGPoint startPos = ccp(self.parent.position.x, self.parent.position.y-self.parent.size.height*0.5f);
					velocity = ccp(0, -bulletSpeed);
					[game.bulletCache shootBulletFrom:startPos velocity:velocity frameName:bulletFrameName isPlayerBullet:NO];
				}];
				[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],block, nil]];
			}
		}
    }
}

-(void) update:(ccTime)delta
{
	EnemyEntity* entity = (EnemyEntity*)self.parent;
	if (self.parent.visible) {
		if (![GameLayer sharedGameLayer].inBossFight || entity.type == EnemyTypeBossMinions) {
			totalTime += delta;
			if (totalTime > nextShotTime) {
				nextShotTime = totalTime+shotDelay;
				if (entity.visible) {
					if (inCD == false && [entity inPlace] && shotsRemaining > 0) {
						[self ShootPattern:pattern];
						shotsRemaining -= 1;
						[entity setState:@"firing"];
						if (shotsRemaining <= 0 && inCD == false) {
							inCD = true;
							if (pattern == Square1P1) {
								[entity performSelector:@selector(setState:) withObject:@"exit" afterDelay:2];
							} else if (pattern == OctagonP1) {
								[entity performSelector:@selector(setState:) withObject:@"exit" afterDelay:0.6f];
							}
							[self performSelector:@selector(resetCD) withObject:nil afterDelay:CDDelay];
						}
					}
				} else if (shotsRemaining < maxShots) {
					[self resetCD];
				}
			}
		} else {
			if (self.parent.visible) {
				if (entity.type == EnemyTypeBoss1) {
					if ([entity.state isEqualToString:@"standby"]) {
						totalTime += delta;
						if (totalTime > nextShotTime) {
							nextShotTime = totalTime+shotDelay;
							if (inCD == false && [entity inPlace] && shotsRemaining > 0) {
								[self bossAttackPattern:entity.state];
								shotsRemaining -= 1;
								if (shotsRemaining <= 0 && inCD == false) {
									inCD = true;
									[self performSelector:@selector(resetCD) withObject:nil afterDelay:CDDelay];
								}
							} else if (shotsRemaining <= 0) {
								[self resetCD];
							}
						}
					} else if ([entity.state isEqualToString:@"homingDogs"]) {
						totalTime += delta;
						if (totalTime > nextShotTime) {
							nextShotTime = totalTime+0.21f;
							if (shotsRemaining > 0) {
								[self bossAttackPattern:entity.state];
								shotsFired++;
								if (shotsFired >= 15) {
									[entity reset];
									[self resetCD];
								}
							}
						}
					} else if ([entity.state isEqualToString:@"rush"]) {
						totalTime+= delta;
						if (totalTime > nextShotTime) {
							nextShotTime = totalTime+2*delta;
							if (entity.position.x < 0.78f*[GameLayer screenRect].size.width) {
								[self bossAttackPattern:entity.state];
							}
						}
					}
				} else if (entity.type == EnemyTypeBoss2) {
					if ([entity.state isEqualToString:@"standby"]) {
						totalTime += delta;
						if (totalTime > nextShotTime) {
							nextShotTime = totalTime+shotDelay;
							if ([entity inPlace]) {
								[self bossAttackPattern:entity.state];
							}
						}
					} else if ([entity.state isEqualToString:@"sesameGatling-fire"]) {
						totalTime += delta;
						if (totalTime > nextShotTime) {
							nextShotTime = totalTime+0.05f;
							if (shotsRemaining > 0) {
								[self bossAttackPattern:entity.state];
								shotsFired++;
								if (shotsFired >= 100) {
									[entity reset];
									[self resetCD];
								}
							}
						}
					} else if ([entity.state isEqualToString:@"ketchupLaser-fire"]) {
						totalTime += delta;
						if (totalTime > nextShotTime) {
							nextShotTime = totalTime;
							if (shotsFired < 220) {
								[self bossAttackPattern:entity.state];
								shotsFired++;
							} else {
								[entity reset];
								[self resetCD];
							}
						}
					}
				} else if (entity.type == EnemyTypeBoss3) {
					if ([entity.state isEqualToString:@"standby"]) {
						totalTime += delta;
						if (totalTime > nextShotTime) {
							nextShotTime = totalTime+shotDelay;
							if (entity.inPlace) {
								[self bossAttackPattern:entity.state];
							}
						}
					} else if ([entity.state isEqualToString:@"laserHell"]) {
						totalTime += delta;
						if (totalTime > nextShotTime) {
							nextShotTime = totalTime+1.3f;
							if (shotsFired < 14) {
								[self bossAttackPattern:entity.state];
								[self bossAttackPattern:entity.state];
								shotsFired++;
							} else {
								[entity reset];
								[self resetCD];
								[entity runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3.2f],[CCCallBlock actionWithBlock:^{
									[entity setInPlace:true];
								}], nil]];
							}
						}
					}
				}
			}
		}
	}
}

@end
