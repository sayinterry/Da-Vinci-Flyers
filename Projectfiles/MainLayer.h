//
//  MainLayer.h
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 6/28/13.
//
//

#import "CCScene.h"
#import "HealthDisplayNode.h"
#import "ScoreDisplayNode.h"
#import "DistanceDisplayNode.h"
#import "BombDisplayNode.h"
#import "PauseScreen.h"

@interface MainLayer : CCScene
{
    HealthDisplayNode *healthDisplayNode;
    ScoreDisplayNode *pointsDisplayNode;
    DistanceDisplayNode *distanceDisplayNode;
	BombDisplayNode *bombDisplayNode;
    // groups health, coins and points display
    CCSprite *hudNode;
	CCSprite *pauseNode;
	PauseScreen *pauseScreen;
	int shipType;
}

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int IACurrency;
@property (nonatomic, assign) float distanceTraveled;
@property (nonatomic) int bombsLeft;

+(CGRect) screenRect;
+(MainLayer*) sharedLayer;
-(void) setHealth:(int)health;
-(void) addScore:(int)_score;
-(void) setDistance:(float)_distance;
-(id) getPauseNode;
-(void) loseBomb;
-(void) resetGame;
-(void) pauseButtonPressed;
-(void) writeToIACurrency;
-(int) getIACurrency;
-(void) syncIACurrency;
-(void) setShipType:(int)shipID;
-(void) startTutorial;
-(int) getShipType;

@end