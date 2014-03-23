/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "EnemyCache.h"
#import "EnemyEntity.h"
#import "GameLayer.h"
#import "BulletCache.h"
#import "PlayerEntity.h"
#import "Boss1TriangleNode.h"

@interface EnemyCache (PrivateMethods)
-(void) initEnemies;
@end


@implementation EnemyCache

+(id) cache
{
	id cache = [[self alloc] init];
#ifndef KK_ARC_ENABLED
	[cache autorelease];
#endif // KK_ARC_ENABLED
	return cache;
}

-(id) init
{
	if ((self = [super init]))
	{
		// get any image from the Texture Atlas we're using
		CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy_square.png"];
		batch = [CCSpriteBatchNode batchNodeWithTexture:frame.texture capacity:200];
		updateCount = 0;
		
		visibleEnemies = [[CCArray alloc] init];
		
		[self addChild:batch];

		[self initEnemies];
		[self scheduleUpdate];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamePaused) name:@"GamePaused" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameResumed) name:@"GameResumed" object:nil];
	}
	
	return self;
}

-(void) gamePaused {
	[self pauseSchedulerAndActions];
	
	EnemyEntity *enemy;
	CCARRAY_FOREACH(visibleEnemies, enemy) {
		[enemy pauseAllSchedulersAndActions];
	}
}

-(void) gameResumed {
	[self resumeSchedulerAndActions];
	
	EnemyEntity *enemy;
	CCARRAY_FOREACH(visibleEnemies, enemy) {
		[enemy resumeAllSchedulersAndActions];
	}
}

-(void) initEnemies
{
	// create the enemies array containing further arrays for each type
	//enemies = [[CCArray alloc] initWithCapacity:EnemyType_MAX];
    enemies = [[CCArray alloc] init];
	bossArray = [[CCArray alloc] initWithCapacity:3];
    
    for (int i = 0; i < EnemyType_MAX; i++) {
        int capacity;
        EnemyTypes type;
        switch (i) {
			case EnemyTypeSquare:
				capacity = 60;
				type = EnemyTypeSquare;
				break;
			case EnemyTypeOctagon:
				capacity = 50;
				type = EnemyTypeOctagon;
				break;
			case EnemyTypeHexagon:
				capacity = 120;
				type = EnemyTypeHexagon;
				break;
			case EnemyTypeCross:
				capacity = 30;
				type = EnemyTypeCross;
				break;
			case EnemyTypeBossMinions:
				capacity = 30;
				type = EnemyTypeBossMinions;
				break;
			case EnemyTypeBoss1:
				capacity = 1;
				type = EnemyTypeBoss1;
				break;
			case EnemyTypeBoss2:
				capacity = 1;
				type = EnemyTypeBoss2;
				break;
			case EnemyTypeBoss3:
				capacity = 1;
				type = EnemyTypeBoss3;
				break;
            default:
                [NSException exceptionWithName:@"EnemyCache Exception" reason:@"unhandled pattern type" userInfo:nil];
                break;
        }
		CCArray* enemyArray = [CCArray arrayWithCapacity:capacity];
		for (int j = 0; j < capacity; j++) {
			EnemyEntity* enemy = [EnemyEntity enemyWithType:type];
			[batch addChild:enemy z:0 tag:type];
			[enemyArray addObject:enemy];
		}
		[enemies addObject:enemyArray];
    }
	[self randomizeBossSpawn];
}

-(void) randomizeBossSpawn {
	while ([bossArray count] < [bossArray capacity]) {
		int rand = arc4random_uniform(2)+EnemyTypeBoss1;
		bool contains = false;
		for (NSUInteger i=0; i<[bossArray count]; i++) {
			if ([[bossArray objectAtIndex:i] intValue] == rand) {
				contains = true;
				break;
			}
		}
		if (contains == false) {
			if ([bossArray count] == 0) {
				[bossArray addObject:[NSNumber numberWithInt:EnemyTypeBoss3]];
			} else {
				[bossArray addObject:[NSNumber numberWithInt:rand]];
			}
		}
	}
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
#ifndef KK_ARC_ENABLED
	[enemies release];
    [visibleEnemies release];
	[bossArray release];
	[super dealloc];
#endif // KK_ARC_ENABLED
}

-(void) spawnBoss:(EnemyTypes)bossType {
	CCArray* enemiesOfPattern = [enemies objectAtIndex:bossType];
	
    EnemyEntity* enemy;
    CCARRAY_FOREACH(enemiesOfPattern, enemy) {
        if (enemy.visible == NO) {
            [enemy spawnBossType:bossType];
			[visibleEnemies addObject:enemy];
            break;
        }
    }
}

-(void) spawnHexagonPattern {
	CCArray* enemiesOfPattern = [enemies objectAtIndex:EnemyTypeHexagon];
	EnemyPattern pat = [spawnInt intValue];
    EnemyEntity* enemy;
    CCARRAY_FOREACH(enemiesOfPattern, enemy) {
        if (enemy.visible == NO) {
            [enemy spawnWithPattern:pat];
			[visibleEnemies addObject:enemy];
            break;
        }
    }
}

-(void) spawnEnemyPattern:(NSNumber*)pattern {
	EnemyPattern pat = [pattern intValue];
	EnemyTypes type;
	switch (pat) {
		case Square1P1:
			type = EnemyTypeSquare;
			break;
		case Square1P2:
			type = EnemyTypeSquare;
			break;
		case CrossP1:
			type = EnemyTypeCross;
			break;
		case OctagonP1:
			type = EnemyTypeOctagon;
			break;
		case FryMinionP1:
			type = EnemyTypeBossMinions;
			break;
		case FryMinionP2:
			type = EnemyTypeBossMinions;
			break;
		default:
			type = EnemyTypeHexagon;
			break;
	}
	CCArray* enemiesOfPattern = [enemies objectAtIndex:type];
	
    EnemyEntity* enemy;
    CCARRAY_FOREACH(enemiesOfPattern, enemy) {
        if (enemy.visible == NO) {
            [enemy spawnWithPattern:pat];
			[visibleEnemies addObject:enemy];
            break;
        }
    }
}

-(void)removeFromVisibleEnemyArray:(EnemyEntity*)enemy {
	[visibleEnemies removeObject:enemy];
}

-(bool) isEnemyCollidingWithRect:(CGRect)rect
{
	bool isColliding = NO;
	EnemyEntity *enemy;
	PlayerEntity* player = [[GameLayer sharedGameLayer] defaultShip];
	CCARRAY_FOREACH(visibleEnemies, enemy) {
		if ((player.position.y >= enemy.boundingBox.origin.y && player.position.y <= enemy.boundingBox.origin.y+enemy.contentSize.height) && (enemy.position.x < player.position.x+2*enemy.contentSize.width)) {
			if (CGRectIntersectsRect(enemy.boundingBox, rect)) {
				isColliding = YES;
				break;
			}
		}
	}
	
	return isColliding;
}

-(void) checkForBulletCollisions
{
	EnemyEntity* enemy;
		CCARRAY_FOREACH(visibleEnemies, enemy) {
			BulletCache* bulletCache = [[GameLayer sharedGameLayer] bulletCache];
			if ([bulletCache isPlayerBulletCollidingWithRect:[enemy boundingBox]]) {
				[enemy gotHit];
			}
		}
}

-(void) checkForOffScreen
{
	EnemyEntity* enemy;
	CCARRAY_FOREACH(visibleEnemies, enemy) {
		if (enemy.type < EnemyTypeBoss1) {
			if (enemy.position.x < -enemy.contentSize.width*0.5f|| enemy.position.x > [GameLayer screenRect].size.width + enemy.contentSize.width || enemy.position.y < -enemy.contentSize.height*0.5f || enemy.position.y > [GameLayer screenRect].size.height + 3*enemy.contentSize.height){
				[enemy setVisible:NO];
				[visibleEnemies removeObject:enemy];
			}
		}
	}
}

-(void) update:(ccTime)delta
{
	GameLayer *game = [GameLayer sharedGameLayer];
	float distance = game.distanceTraveled;
	updateCount++;

	if (!game.inBossFight) {
		//regular hexagon spawning
		if (distance > 1) {
			if (updateCount%356 == 0) {
				int limit = 7;
				int randInt = arc4random_uniform(HexagonP13);
				spawnInt = [NSNumber numberWithInt:randInt];
				[self schedule:@selector(spawnHexagonPattern) interval:0.3f repeat:limit delay:0];
			}
			if (distance > 400) {
				if ((updateCount+157)%712 == 0) {
					int limit = 7;
					int randInt = arc4random_uniform(HexagonP13);
					spawnInt = [NSNumber numberWithInt:randInt];
					[self schedule:@selector(spawnHexagonPattern) interval:0.3f repeat:limit delay:0];
				}
				if (distance > 700) {
					if ((updateCount+320)%532 == 0) {
						int limit = 7;
						int randInt = arc4random_uniform(HexagonP13);
						spawnInt = [NSNumber numberWithInt:randInt];
						[self schedule:@selector(spawnHexagonPattern) interval:0.3f repeat:limit delay:0];
					}
				}
			}
		}
		//Unique spawning conditional
		if (distance > 200) {
			if (distance < 600) {
				if (fmodf(distance, 60) <= delta) {
					[self spawnEnemyPattern:[NSNumber numberWithInt:Square1P1]];
				}
			}
			if (distance > 400) {
				if (distance > 480 && distance < 490) {
					if (fmodf(distance, 2) <= delta) {
						[self spawnEnemyPattern:[NSNumber numberWithInt:Square1P1]];
					}
				}
				if (distance > 475) {
					if (fmodf(distance, 115) <= delta) {
						[self spawnEnemyPattern:[NSNumber numberWithInt:OctagonP1]];
					}
				}
			}
		}
		//boss spawning conditional
		if (distance > 100) {
			if ((int)floorf(distance)%400 == 0 && [bossArray count] > 0) {
				int bossInt = [[bossArray lastObject] intValue];
				[self spawnBoss:bossInt];
				[game bossIsSpawned:bossInt];
				[bossArray removeLastObject];
				if ([bossArray count] == 0) {
					[self performSelectorInBackground:@selector(randomizeBossSpawn) withObject:nil];
				}
			}
		}
		
	}
    if ((game.isBombed == TRUE && [game.bombType isEqualToString:@"skill"]) && !game.inBossFight) {
        EnemyEntity *enemy;
        CCARRAY_FOREACH(visibleEnemies, enemy) {
			[enemy gotHit];
        }
	}
	[self checkForOffScreen];
	[self checkForBulletCollisions];
}

@end
