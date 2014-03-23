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
#import "EnemyEntity.h"
@class BulletCache;
@class PlayerEntity;
@class EnemyCache;

//This assigns an integer value to an arbitrarily long list, where each has a value 1 greater than the last. So here TouchAvailableLabelTag = 3 and TouchEndedLabelTag = 4

typedef NS_ENUM(NSInteger, GameState) {
    GameStatePaused,
	GameStateTutorial,
    GameStateMenu,
    GameStateRunning
};

@interface GameLayer : CCLayer 
{
	CCLabelBMFont *bossNameLabel;
	CCLabelTTF *tapToContLabel;
	CCLabelTTF *gameOverLabel;
	int bossesKilled;
	CCParticleBatchNode *playerBombParticleBatch;
	CCParticleBatchNode *eBulletParticleBatch;
}

@property (nonatomic) float totaltime;
@property (nonatomic) bool isBombed;
@property PlayerEntity* player;
@property (nonatomic) BulletCache* bulletCache;
@property (nonatomic) EnemyCache* enemyCache;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int intDistance;
@property (nonatomic, assign) float distanceTraveled;
@property (nonatomic, assign) bool inBossFight;
@property (nonatomic, assign) bool battleHasBegun;
@property (nonatomic, assign) bool gameIsOver;
@property (nonatomic) NSString *bombType;

+(CGRect) screenRect;
+(GameLayer*) sharedGameLayer;
-(PlayerEntity*) defaultShip;
-(bool) isBombed;
-(void) bossIsSpawned:(EnemyTypes)bossType;
-(void) gameOver;
-(void) bossKilled;
-(int) getBossesKilled;
-(void) resetGame;
-(void) playerHitBomb;
-(void) eBulletDieParticlePos:(CGPoint)pos;

@end
