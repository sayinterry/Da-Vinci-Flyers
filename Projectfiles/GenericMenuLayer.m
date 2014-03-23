//
//  GenericMenuLayer.m
//  Game Template
//
//  Created by Jeremy Rossmann on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GenericMenuLayer.h"
#import "MainLayer.h"
#import "StoreLayer.h"
#import "TutorialLayer.h"

@implementation GenericMenuLayer

-(id) init
{
	if ((self = [super init])) {
		
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"Game-Images2.plist"];
		
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Play Game" fontName:@"arial" fontSize:20.0f];
		CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Shop" fontName:@"arial" fontSize:20.0f];
		CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"Scores" fontName:@"arial" fontSize:20.0f];
		CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"About" fontName:@"arial" fontSize:20.0f];
        
        CCMenuItemLabel *item = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(startGame)];
		CCMenuItemLabel *item2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(goToStore)];
		CCMenuItemLabel *item3 = [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(displayScores)];
		CCMenuItemLabel *item4 = [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(goToAbout)];

                
        //CCMenu *menu = [CCMenu menuWithItems:item, item2, item3, item4, nil];
		CCMenu *menu = [CCMenu menuWithItems:item, nil];
		
		[menu alignItemsVerticallyWithPadding:14];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		[menu setPosition:ccp(screenSize.width*0.8f, screenSize.height*0.3f)];
		
		sShipNode = [[SelectShipNode alloc] init];
		[self addChild:sShipNode];
		sShipNode.scale = 1.3f;
		sShipNode.position = ccp(screenSize.width*0.13f, screenSize.height*0.28f);
		
		sShipShipLabel = [CCLabelTTF labelWithString:@"easy" fontName:@"arial" fontSize:16];
		[self addChild:sShipShipLabel];
		sShipShipLabel.position = ccp(screenSize.width*0.35f, sShipNode.position.y-sShipNode.contentSize.height*0.5f);
		
//		NSDictionary *localScores = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"localScoreboard"];
//		localScoreBoard = [[HighscoresScene alloc] initWithScores:localScores];
        
        [self addChild:menu];
		[self scheduleUpdate];
		
        
    }
    return self;
}

-(void) setScrollingShip:(bool)scrollShip {
	scrollingShip = scrollShip;
}

-(void) update:(ccTime)delta {
	KKInput *input = [KKInput sharedInput];
	if ([input isAnyTouchOnNode:sShipNode touchPhase:KKTouchPhaseAny] && !scrollingShip) {
		CGPoint _pos = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
		if ([input anyTouchBeganThisFrame]) {
			initialTouchX = _pos.x;
		} else if ([input anyTouchEndedThisFrame]) {
			initialTouchX = 0;
		}
		int i = 0;;
		if (initialTouchX != 0) {
			if (initialTouchX-_pos.x < -11) {
				scrollingShip = true;
				i = -1;
			} else if (initialTouchX-_pos.x > 11) {
				scrollingShip = true;
				i = 1;
			}
			if (i > 0) {
				[sShipNode updateShipLocationsPos];
			} else if (i < 0) {
				[sShipNode updateShipLocationsNeg];
			}
		}
	}
	if (fmodf([sShipNode getSelectedShip], 1) == 0) {
		int typeOfShip = [sShipNode getSelectedShip];
		if (typeOfShip == 1) {
			sShipShipLabel.string = @"Normal";
		} else if (typeOfShip == 2) {
			sShipShipLabel.string = @"Hard";
		} else if (typeOfShip == 3) {
			sShipShipLabel.string = @"Easy";
		}
	}
}

-(void) startGame {
	if (scrollingShip == false) {
		[[CCDirector sharedDirector] replaceScene: [[MainLayer alloc] init]];
		[[MainLayer sharedLayer] setShipType:[sShipNode getSelectedShip]];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		if (![prefs boolForKey:@"seenTutorial"]) {
			[[MainLayer sharedLayer] startTutorial];
		}
	}
}

-(void) goToStore {
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInR transitionWithDuration:0.3f scene:[[StoreLayer alloc] init]]];
}

-(void) displayScores {
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInB transitionWithDuration:0.3f scene:localScoreBoard]];
}

-(void) goToAbout {
	
}

@end
