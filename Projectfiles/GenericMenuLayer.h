//
//  GenericMenuLayer.h
//  Game Template
//
//  Created by Jeremy Rossmann on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "SelectShipNode.h"
#import "HighscoresScene.h"

@interface GenericMenuLayer : CCScene
{
    HighscoresScene *localScoreBoard;
	SelectShipNode *sShipNode;
	int initialTouchX;
	bool scrollingShip;
	CCLabelBMFont *sShipShipLabel;
}

-(void) startGame;
-(void) setScrollingShip:(bool)scrollShip;
@end
