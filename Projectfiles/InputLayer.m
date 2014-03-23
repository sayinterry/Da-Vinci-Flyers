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

#import "InputLayer.h"
#import "GameLayer.h"
#import "PlayerEntity.h"
#import "Bullet.h"
#import "BulletCache.h"
#import "MainLayer.h"
#import "GenericMenuLayer.h"
#import "RecapScreenScene.h"

#import "SimpleAudioEngine.h"

#define M_PI_180 0.01745329f

@interface InputLayer (PrivateMethods)
@end

@implementation InputLayer

-(id) init
{
	if ((self = [super init]))
	{
		skillShot = [[CCSprite alloc] initWithSpriteFrameName:@"bomb.png"];
        [self addChild:skillShot z:5];
        skillShot.scale = 2.6;
        skillShot.position = ccp([GameLayer screenRect].size.width*0.9f, [GameLayer screenRect].size.height*0.07f);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameResumed) name:@"GameResumed" object:nil];
		
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) gameResumed {
	[self resumeSchedulerAndActions];
}

-(void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) update:(ccTime)delta
{
	totalTime += delta;
    GameLayer* game = [GameLayer sharedGameLayer];
	PlayerEntity* player = [game defaultShip];
    KKInput* _input = [KKInput sharedInput];
    CGPoint _pos = [_input locationOfAnyTouchInPhase:KKTouchPhaseAny];
	if (_pos.x != 0 && _pos.y != 0) {
		if ([_input anyTouchBeganThisFrame]) {
			if (![game gameIsOver]) {
				if ([_input isAnyTouchOnNode:skillShot touchPhase:KKTouchPhaseBegan]) {
					MainLayer* main = [MainLayer sharedLayer];
					if (game.isBombed == FALSE && player.visible && main.bombsLeft > 0) {
						game.isBombed = TRUE;
						game.bombType = @"skill";
						[main loseBomb];
						[game performSelector:@selector(setIsBombed:) withObject:FALSE afterDelay:5];
					}
				} else if ([_input isAnyTouchOnNode:[[MainLayer sharedLayer] getPauseNode] touchPhase:KKTouchPhaseBegan]) {
					[self pauseSchedulerAndActions];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"GamePaused" object:nil];
				} else if (_pos.x != 0 && _pos.y != 0 && playerDragTouch == nil) {
					playerDragTouch = [[_input touches] lastObject];
					player.dragging = true;
					player.dx = _pos.x-player.position.x;
					player.dy = _pos.y-player.position.y;
				}
			} else {
				[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.7f scene:[[RecapScreenScene alloc] init]]];
			}
		} else if ([_input anyTouchEndedThisFrame]) {
			if ([playerDragTouch phase] == KKTouchPhaseEnded) {
				playerDragTouch = nil;
				player.dragging = false;
				player.dx = 0;
				player.dy = 0;
			}
		}
		
		float nDx = playerDragTouch.location.x - player.dx - player.position.x;
		float nDy = playerDragTouch.location.y - player.dy - player.position.y;
		
		if (player.dragging == true) {
			if (player.getShipType == 1) {
				if (nDx*nDx+nDy*nDy < 81) {
					[player setPosition:ccp(playerDragTouch.location.x-player.dx, playerDragTouch.location.y-player.dy)];
				} else {
					[player moveTowards:ccpSub(playerDragTouch.location,ccp(player.dx,player.dy)) withSpeed:9];
				}
			} else if (player.getShipType == 2) {
				if (nDx*nDx+nDy*nDy < 49) {
					[player setPosition:ccp(playerDragTouch.location.x-player.dx, playerDragTouch.location.y-player.dy)];
				} else {
					[player moveTowards:ccpSub(playerDragTouch.location,ccp(player.dx,player.dy)) withSpeed:7];
				}
			} else if (player.getShipType == 3) {
				if (nDx*nDx+nDy*nDy < 121) {
					[player setPosition:ccp(playerDragTouch.location.x-player.dx, playerDragTouch.location.y-player.dy)];
				} else {
					[player moveTowards:ccpSub(playerDragTouch.location,ccp(player.dx,player.dy)) withSpeed:11];
				}
			}
		}
	}
    
    if ([player checkHitpoints] >= 0) {
		if ([player getShipType] == 1) {
			if (totalTime > nextShotTime) {
				nextShotTime = totalTime + 0.07f;
			
				BulletCache* bulletCache = [game bulletCache];

				// Set the position, velocity and spriteframe before shooting
				CGPoint shotPos = CGPointMake(player.position.x + 2, player.position.y-5);
				CGPoint shotPos2 = CGPointMake(player.position.x + 2, player.position.y+5);
				
				CGPoint velocity = CGPointMake(466, 0);
				[bulletCache shootBulletFrom:shotPos velocity:velocity frameName:@"pBullet.png" isPlayerBullet:YES];
				[bulletCache shootBulletFrom:shotPos2 velocity:velocity frameName:@"pBullet.png" isPlayerBullet:YES];
			}
		} else if ([player getShipType] == 2) {
			if (totalTime > nextShotTime) {
				nextShotTime = totalTime + 0.115f;
				
				BulletCache* bulletCache = [game bulletCache];
				
				// Set the position, velocity and spriteframe before shooting
				CGPoint shotPos = CGPointMake(player.position.x + 2, player.position.y);
				
				int	bSpeed = 500;
				for (int i=0; i<3; i++) {
					float theta = i*55-55;
					float veloX = bSpeed*cosf(theta*M_PI_180);
					float veloY = bSpeed*sinf(theta*M_PI_180);
					if (i == 1) {
						[bulletCache shootBulletFrom:shotPos velocity:ccp(veloX, veloY) frameName:@"pBullet.png" isPlayerBullet:YES];
					} else {
						[bulletCache shootBouncingBulletFrom:shotPos velocity:ccp(veloX, veloY) frameName:@"pBullet.png" isPlayerBullet:YES];
					}
				}
			}
		} else if ([player getShipType] == 3) {
			if (totalTime > nextShotTime) {
				nextShotTime = totalTime + 0.17f;
				
				BulletCache* bulletCache = [game bulletCache];
				
				// Set the position, velocity and spriteframe before shooting
				CGPoint shotPos = CGPointMake(player.position.x + 2, player.position.y);
				
				int	bSpeed = 485;
				for (int i=0; i<5; i++) {
					float theta = i*5-10;
					float veloX = bSpeed*cosf(theta*M_PI_180);
					float veloY = bSpeed*sinf(theta*M_PI_180);
					[bulletCache shootBulletFrom:shotPos velocity:ccp(veloX, veloY) frameName:@"pBullet.png" isPlayerBullet:YES];
				}
			}
		}
    }
    
    [player checkForBulletCollisions];
	[player checkForEnemyCollisions];
}

@end
