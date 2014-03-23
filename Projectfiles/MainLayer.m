//
//  MainLayer.m
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 6/28/13.
//
//

#import "MainLayer.h"
#import "GameLayer.h"
#import "GenericMenuLayer.h"
#import "TutorialLayer.h"

@implementation MainLayer

static CGRect screenRect;

static MainLayer* instanceOfMainLayer;

@synthesize score, bombsLeft, IACurrency;

+(CGRect) screenRect {
    return screenRect;
}

+(MainLayer*) sharedLayer
{
	NSAssert(instanceOfMainLayer != nil, @"MainLayer instance not yet initialized!");
	return instanceOfMainLayer;
}

-(id) init
{
	if ((self = [super init]))
	{
        instanceOfMainLayer = self;
		bombsLeft = 5;
		score = 1537;
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
		screenRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
        
        CGPoint screenCenter = [CCDirector sharedDirector].screenCenter;
        hudNode = [[CCSprite alloc] initWithSpriteFrameName:@"HUD.png"];
        [self addChild:hudNode z:2 tag:151];
        hudNode.position = ccp(screenCenter.x, screenSize.height-hudNode.contentSize.height/2);
        
        healthDisplayNode = [[HealthDisplayNode alloc] initWithHealthImage:@"lives.png" maxHealth:3];
        [hudNode addChild:healthDisplayNode z:3 tag: 33];
        
        pointsDisplayNode = [[ScoreDisplayNode alloc] initWithScoreImage:nil fontFile:@"avenir24.fnt"];
        pointsDisplayNode.scoreStringFormat = @"%d points";
        pointsDisplayNode.score = 0;
        [hudNode addChild:pointsDisplayNode z:2];
        
        distanceDisplayNode = [[DistanceDisplayNode alloc] initWithFontFile:@"avenir24.fnt"];
		distanceDisplayNode.distanceStringFormat = @"Distance: %d m";
        [hudNode addChild:distanceDisplayNode z:2 tag: 335];
		
		bombDisplayNode = [[BombDisplayNode alloc] initWithBombImage:@"bomb.png" maxBombs:5];
		[hudNode addChild:bombDisplayNode z:3 tag: 44];
		[bombDisplayNode setBombs:bombsLeft];
		
		pauseNode = [[CCSprite alloc] initWithSpriteFrameName:@"pause.png"];
		[hudNode addChild:pauseNode z:1 tag:111];
		
		//set positions for each HUD node
		float padding = (hudNode.contentSize.width-(healthDisplayNode.contentSize.width+pointsDisplayNode.contentSize.width+distanceDisplayNode.contentSize.width+bombDisplayNode.contentSize.width+pauseNode.contentSize.width))*(0.16f);
		float nextX = padding;
		healthDisplayNode.position = ccp(nextX+healthDisplayNode.contentSize.width*0.5f, hudNode.contentSize.height*0.5f);
		nextX = healthDisplayNode.position.x+healthDisplayNode.contentSize.width*0.5f+padding;
		pointsDisplayNode.position = ccp(nextX+pointsDisplayNode.contentSize.width*0.5f, hudNode.contentSize.height*0.5f);
		nextX = pointsDisplayNode.position.x+pointsDisplayNode.contentSize.width*0.5f+padding;
		distanceDisplayNode.position = ccp(nextX+distanceDisplayNode.contentSize.width*0.5f, hudNode.contentSize.height*0.5f);
		nextX = distanceDisplayNode.position.x+distanceDisplayNode.contentSize.width*0.5f+padding;
		bombDisplayNode.position = ccp(nextX+bombDisplayNode.contentSize.width*0.5f, hudNode.contentSize.height*0.5f);
		nextX = bombDisplayNode.position.x+bombDisplayNode.contentSize.width*0.5f+padding;
		pauseNode.position = ccp(nextX+pauseNode.contentSize.width*0.5f, hudNode.contentSize.height*0.5f);
        
        [self addChild:[CCLayerColor layerWithColor:ccc4(135, 206, 250, 255)] z:-1];
		
    }
	return self;
}

-(void) onEnterTransitionDidFinish {
	if ([self getChildByTag:10]) {
		
	} else {
		NSString *healthImg = @"lives.png";
		if (shipType == 1) {
			healthImg = @"lives.png";
		} else if (shipType == 2) {
			healthImg = @"lives2.png";
		}
		[healthDisplayNode resetHealthWithImage:healthImg];
		GameLayer* gameLayer = [[GameLayer alloc] init];
		[self addChild:gameLayer z:1 tag:10];
	}
}

-(void) pauseButtonPressed {
	pauseScreen = [[PauseScreen alloc] init];
	pauseScreen.position = screenRect.origin;
	[self addChild:pauseScreen z:10];
}

-(id) getPauseNode {
	return pauseNode;
}

-(void) setHealth:(int) health {
    [healthDisplayNode setHealth:health];
}

-(void) addScore:(int)_score {
	score += _score;
    [pointsDisplayNode setScore:score-1537];
}

-(void) loseBomb{
	bombsLeft--;
	[bombDisplayNode setBombs:bombsLeft];
}

-(void) setDistance:(float)_distance {
	[distanceDisplayNode updateDistance:_distance];
}

-(void) resetGame {
	[[self getChildByTag:10] scheduleUpdate];
	[self setScore:1537];
	[self addScore:0];
	NSString *healthImg = @"lives.png";
	if (shipType == 1) {
		healthImg = @"lives.png";
	} else if (shipType == 2) {
		healthImg = @"lives2.png";
	}
	[healthDisplayNode resetHealthWithImage:healthImg];
	[healthDisplayNode setHealth:3];
	bombsLeft = 5;
	[bombDisplayNode setBombs:bombsLeft];
}

-(void) startTutorial {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"GamePaused" object:nil];
	TutorialLayer *tutorialLayer = [[TutorialLayer alloc] init];
	[self addChild:tutorialLayer z:6];
	
	
}

-(void) setShipType:(int)shipID {
	shipType = shipID;
}

-(int) getShipType {
	return shipType;
}

-(void) dealloc {
	instanceOfMainLayer = nil;
	
#ifndef KK_ARC_ENABLED
	// don't forget to call "super dealloc"
	[super dealloc];
#endif // KK_ARC_ENABLED
}


@end
