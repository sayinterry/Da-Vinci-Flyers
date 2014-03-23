/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */


#import "EnemyEntity.h"
#import "GameLayer.h"
#import "StandardMoveComponent.h"
#import "StandardShootComponent.h"
#import "HealthbarComponent.h"
#import "MainLayer.h"
#import "Boss1TriangleNode.h"
#import "PlayerEntity.h"
#import "BulletCache.h"
#import "EnemyCache.h"

#import "SimpleAudioEngine.h"

@interface EnemyEntity (PrivateMethods)
-(void) initSpawnFrequency;
@end

@implementation EnemyEntity

@synthesize initialHitPoints, hitPoints, inPlace, pattern, state, updateCount, type;

-(id) initWithType:(EnemyTypes)enemyType
{
	type = enemyType;
	self.state = nil;
	self.firing = false;
	
	NSString* enemyFrameName;
	NSString* bulletFrameName;
	
	switch (type)
	{
		case EnemyTypeSquare:
			enemyFrameName = @"enemy_square.png";
			bulletFrameName = @"eBullet1.png";
			initialHitPoints = 16;
			break;
		case EnemyTypeHexagon:
			enemyFrameName = @"enemy_hexagon.png";
			bulletFrameName = @"eBullet1.png";
			initialHitPoints = 8;
			break;
		case EnemyTypeOctagon:
			enemyFrameName = @"enemy_octagon.png";
			bulletFrameName = @"eBullet1.png";
			initialHitPoints = 33;
			break;
		case EnemyTypeCross:
			enemyFrameName = @"enemy_cross.png";
			bulletFrameName = @"laser1.png";
			initialHitPoints = 36;
			break;
		case EnemyTypeBossMinions:
			enemyFrameName = @"enemy_FrenchFry.png";
			bulletFrameName = @"eBullet-fry.png";
			initialHitPoints = 36;
			break;
		case EnemyTypeBoss1:
			enemyFrameName = @"CorndogCarl.png";
			bulletFrameName = @"eBullet-corndog.png";
			initialHitPoints = 680;
			break;
		case EnemyTypeBoss2:
			enemyFrameName = @"BillyBurger.png";
			bulletFrameName = @"Burger.png";
			initialHitPoints = 680;
			break;
		case EnemyTypeBoss3:
			enemyFrameName = @"FreddyFrenchFry.png";
			bulletFrameName = @"eBullet-fry.png";
			initialHitPoints = 680;
			break;
			
		default:
			[NSException exceptionWithName:@"EnemyEntity Exception" reason:@"unhandled enemy type" userInfo:nil];
	}
	
	if ((self = [super initWithSpriteFrameName:enemyFrameName]))
	{
		// Create the game logic components
        StandardMoveComponent* moveComponent = [StandardMoveComponent node];
        moveComponent.type = type;
		[self addChild:moveComponent z:nil tag:77];
		
		StandardShootComponent* shootComponent = [StandardShootComponent node];
		shootComponent.bulletFrameName = bulletFrameName;
		[self addChild:shootComponent];

		self.visible = NO;
	}
	
	return self;
}

+(id) enemyWithType:(EnemyTypes)enemyType
{
	id enemy = [[self alloc] initWithType:enemyType];
#ifndef KK_ARC_ENABLED
	[enemy autorelease];
#endif // KK_ARC_ENABLED
	return enemy;
}

-(void) dealloc {
#ifndef KK_ARC_ENABLED
	[super dealloc];
#endif // KK_ARC_ENABLED
}

-(void) spawnBossType:(EnemyTypes)bossType {
	CGRect screenRect = [GameLayer screenRect];
	CGSize spriteSize = [self contentSize];
	float xPos;
	float yPos;
	if (bossType == EnemyTypeBoss1 || bossType == EnemyTypeBoss2 || bossType == EnemyTypeBoss3) {
		xPos = screenRect.size.width+spriteSize.width*0.5f;
		yPos = screenRect.size.height*0.5f;
	}
	self.position = CGPointMake(xPos, yPos);
	self.visible = true;
	hitPoints = 380+(powf(2,[[GameLayer sharedGameLayer] getBossesKilled])*50);
	
	CCNode* node;
	CCARRAY_FOREACH([self children], node) {
		if ([node isKindOfClass:[StandardMoveComponent class]]) {
			StandardMoveComponent* moveComponent = (StandardMoveComponent*)node;
			[moveComponent bossTypeInit:bossType];
		} else if ([node isKindOfClass:[StandardShootComponent class]]) {
			StandardShootComponent* shootComponent = (StandardShootComponent*)node;
			[shootComponent bossTypeInit:bossType];
		}
	}
	
	self.state = @"standby";
	
	[self scheduleUpdate];
}


-(void) spawnWithPattern:(EnemyPattern)enemyPattern {
	//CCLOG(@"spawn enemy");
	
	// Select a spawn location just outside the right side of the screen, with random y position
	CGRect screenRect = [GameLayer screenRect];
	CGSize spriteSize = [self contentSize];
	float xPos = screenRect.size.width + spriteSize.width * 0.5f;
	float yPos;
	self.rotation = 0;
    pattern = enemyPattern;
    if (pattern == HexagonP1 || pattern == HexagonP3 || pattern == HexagonP5) {
        yPos = (screenRect.size.height*0.8f);
    } else if (pattern == HexagonP2 || pattern == HexagonP4 || pattern == HexagonP7) {
        yPos = (screenRect.size.height*0.2f);
    } else if (pattern == HexagonP6) {
		yPos = (screenRect.size.height*0.5f);
	} else if (pattern == HexagonP8) {
		xPos = screenRect.size.width*0.5f;
		yPos = screenRect.size.height+spriteSize.height*0.5f;
	} else if (pattern == HexagonP9) {
		xPos = screenRect.size.width*0.74f;
		yPos = screenRect.size.height+spriteSize.height*0.5f;
	} else if (pattern == HexagonP10) {
		xPos = screenRect.size.width*0.5f;
		yPos = -spriteSize.height*0.5f;
	} else if (pattern == HexagonP11) {
		xPos = screenRect.size.width*0.74f;
		yPos = -spriteSize.height*0.5f;
	} else if (pattern == HexagonP12 || pattern == HexagonP13) {
		xPos = -spriteSize.width*0.5f;
		if (pattern == HexagonP12) {
			yPos = screenRect.size.height*0.9f;
		} else {
			yPos = screenRect.size.height*0.1f;
		}
	} else if (pattern == Square1P1) {
		yPos = CCRANDOM_0_1()*screenRect.size.height*0.6f+0.2f*screenRect.size.height;
	} else if (pattern == OctagonP1) {
		yPos = CCRANDOM_0_1()*screenRect.size.height*0.6f+0.2f*screenRect.size.height;
	} else if (pattern == FryMinionP1) {
		yPos = spriteSize.height*0.5f;
	} else if (pattern == FryMinionP2) {
		yPos = screenRect.size.height-spriteSize.height*0.5f;
		[self setRotation:180];
	}
	
	self.position = CGPointMake(xPos, yPos);
	
	// Finally set yourself to be visible, this also flag the enemy as "in use"
	self.visible = YES;
	
	// reset health
	hitPoints = initialHitPoints;
	
	// reset certain components
	CCNode* node;
	CCARRAY_FOREACH([self children], node) {
		if ([node isKindOfClass:[StandardMoveComponent class]]) {
			StandardMoveComponent* moveComponent = (StandardMoveComponent*)node;
			[moveComponent assignPattern:pattern];
		} else if ([node isKindOfClass:[StandardShootComponent class]]) {
			StandardShootComponent* shootComponent = (StandardShootComponent*)node;
			[shootComponent assignPattern:pattern];
		}
	}
}

-(void) flashWhite {
	[self setColor:ccc3(200, 0, 0)];
	[self performSelector:@selector(returnToNormal) withObject:NULL afterDelay:0.014f];
}
-(void) returnToNormal {
	[self setColor:ccWHITE];
}

-(void) gotHit
{
    
	if (self.type >= EnemyTypeBoss1) {
		if ([GameLayer sharedGameLayer].battleHasBegun) {
			hitPoints--;
			[self flashWhite];
		}
	} else {
		if ([GameLayer sharedGameLayer].isBombed == TRUE && [[GameLayer sharedGameLayer].bombType isEqualToString:@"skill"]) {
			hitPoints = 0;
		}
		hitPoints--;
		[self flashWhite];
	}
	if (hitPoints <= 0)
	{
		self.visible = NO;
        self.inPlace = false;
		self.state = nil;
		EnemyCache *eCache = [[GameLayer sharedGameLayer] enemyCache];
		[eCache removeFromVisibleEnemyArray:self];
		int worth = [self getWorth];
		if (![GameLayer sharedGameLayer].gameIsOver) {
			MainLayer *scoreLayer = [MainLayer sharedLayer];
			[scoreLayer addScore:worth];
		}
		if (self.type >= EnemyTypeBoss1) {
			[[GameLayer sharedGameLayer] bossKilled];
		}
		
	}
}

-(int) getWorth {
	int enemyWorth;
	switch (self.type) {
		case EnemyTypeBoss1:
			enemyWorth = 800;
			break;
		case EnemyTypeBoss2:
			enemyWorth = 1000;
			break;
		case EnemyTypeBoss3:
			enemyWorth = 1200;
			break;
		case EnemyTypeOctagon:
			enemyWorth = 55;
			break;
		default:
			enemyWorth = 25;
			break;
	}
	return enemyWorth;
}

-(void) pauseAllSchedulersAndActions {
	[self pauseSchedulerAndActions];
	
	CCSprite *sprite;
	CCARRAY_FOREACH([self children], sprite) {
		[sprite pauseSchedulerAndActions];
	}
}

-(void) resumeAllSchedulersAndActions {
	[self resumeSchedulerAndActions];
	
	CCSprite *sprite;
	CCARRAY_FOREACH([self children], sprite) {
		[sprite resumeSchedulerAndActions];
	}
}

-(void) reset {
	self.state = @"standby";
	updateCount = 0;
	[self runAction:[CCRotateTo actionWithDuration:0.2f angle:0]];
}

-(void) update:(ccTime)delta {
	if (self.visible) {
		if (!self.inPlace && ![GameLayer sharedGameLayer].battleHasBegun) {
			self.state = @"init";
		}
		if (self.inPlace && self.type >= EnemyTypeBoss1 && self.visible && [self numberOfRunningActions] == 0) {
			updateCount++;
			if (self.type == EnemyTypeBoss1 && [self.state isEqualToString:@"standby"]) {
				if (updateCount >= 320) {
					int rand = arc4random_uniform(2);
					if (rand == 0) {
						self.state = @"homingDogs";
					} else if (rand == 1) {
						self.inPlace = false;
						self.state = @"rush";
					}
				}
			} else if(self.type == EnemyTypeBoss2 && [self.state isEqualToString:@"standby"]) {
				if (updateCount >= 320) {
					int rand = arc4random_uniform(2);
					if (rand == 0) {
						self.state = @"sesameGatling";
						self.inPlace = false;
					} else if (rand == 1) {
						self.state = @"ketchupLaser";
						self.inPlace = false;
					}
				}
			} else if (self.type == EnemyTypeBoss3 && [self.state isEqualToString:@"standby"]) {
				if (updateCount >= 640) {
					self.state = @"laserHell";
					self.inPlace = false;
				}
			}
		}
	} else {
		[self unscheduleAllSelectors];
		[self stopAllActions];
	}
}

//-(void) update:(ccTime)delta {
//	if (self.pattern == BossP1 && self.visible) {
//		if (self.inPlace) {
//			updateCount++;
//			if (updateCount > 600 && [self.state isEqualToString:@"standby"]) {
//				int rand = arc4random_uniform(2);
//				if (rand == 0) {
//					self.state = @"fireTriangle";
//				} else if (rand == 1) {
//					self.state = @"fireLasers";
//				}
//			}
//			if ([self.state isEqualToString:@"fireTriangle"]) {
//				if ([[boss1TriangleSprites objectAtIndex:0] getFired] == true && [[boss1TriangleSprites objectAtIndex:1] getFired] == true && [[boss1TriangleSprites objectAtIndex:2] getFired] == true) {
//					Boss1TriangleNode *triangle;
//					for (triangle in boss1TriangleSprites) {
//						[triangle resetToStandby];
//					}
//					self.state = @"standby";
//					updateCount = 0;
//				}
//			} else if ([self.state isEqualToString:@"fireLasers"]) {
//				BulletCache *bCache = [[GameLayer sharedGameLayer] bulletCache];
//				if ([bCache getEBulletCount] <= 20 && [[GameLayer sharedGameLayer] defaultShip].visible && ![GameLayer sharedGameLayer].isBombed) {
//					[self setPosition:ccp(self.position.x, [[GameLayer sharedGameLayer] defaultShip].position.y)];
//				}
//				if ([[boss1TriangleSprites objectAtIndex:0] getFired] == true && [[boss1TriangleSprites objectAtIndex:1] getFired] == true && [[boss1TriangleSprites objectAtIndex:2] getFired] == true) {
//					Boss1TriangleNode *triangle;
//					for (triangle in boss1TriangleSprites) {
//						[triangle resetToStandby];
//					}
//					self.state = @"standby";
//					updateCount = 0;
//					[self runAction:[CCMoveTo actionWithDuration:0.2f position:ccp([GameLayer screenRect].size.width*0.8f, [GameLayer screenRect].size.height*0.5f)]];
//				}
//			}
//		}
//	} else {
//		[self stopAllActions];
//		[self unscheduleUpdate];
//	}
//}


@end
