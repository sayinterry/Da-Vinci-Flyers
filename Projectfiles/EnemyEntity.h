/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */


#import <Foundation/Foundation.h>
#import "Entity.h"

typedef enum
{
	EnemyTypeSquare = 0,
	EnemyTypeHexagon,
	EnemyTypeOctagon,
	EnemyTypeCross,
	EnemyTypeBossMinions,
	EnemyTypeBoss1,
	EnemyTypeBoss2,
	EnemyTypeBoss3,
	
	EnemyType_MAX,
} EnemyTypes;

typedef enum {
	HexagonP1 = 0,
    HexagonP2,
    HexagonP3,
    HexagonP4,
	HexagonP5,
    HexagonP6,
    HexagonP7,
	HexagonP8,
    HexagonP9,
    HexagonP10,
	HexagonP11,
	HexagonP12,
	HexagonP13,
    Square1P1,
	Square1P2,
	Square1P3,
	Square1P4,
    Square2P1,
	Square2P2,
	Square2P3,
	OctagonP1,
	CrossP1,
	FryMinionP1,
	FryMinionP2,
    EnemyPattern_MAX,
} EnemyPattern;


@interface EnemyEntity : Entity
{
	int initialHitPoints;
	int hitPoints;
}

@property (readonly, nonatomic) int initialHitPoints;
@property (readonly, nonatomic) int hitPoints;
@property (nonatomic) BOOL inPlace;
@property (nonatomic) BOOL firing;
@property EnemyPattern pattern;
@property (nonatomic) NSString* state;
@property (nonatomic) int updateCount;
@property (nonatomic) EnemyTypes type;

+(id) enemyWithType:(EnemyTypes)enemyType;

-(void) spawnWithPattern:(EnemyPattern)pattern;
-(void) gotHit;
-(void) reset;
-(void) spawnBossType:(EnemyTypes)bossType;
-(void) pauseAllSchedulersAndActions;
-(void) resumeAllSchedulersAndActions;

@end
