//
//  PauseScreen.m
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 8/6/13.
//
//

#import "PauseScreen.h"
#import "MainLayer.h"
#import "GameLayer.h"
#import "GenericMenuLayer.h"
#import "PlayerEntity.h"

@implementation PauseScreen

-(id) init {
	if ((self = [super init])) {
		[self addChild:[CCLayerColor layerWithColor:ccc4(255, 255, 255, 200)] z:-1];
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"RESUME" fontName:@"arial" fontSize:40.0f];
		label.color = ccc3(255, 0, 0);
		CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"ENDGAME" fontName:@"arial" fontSize:40.0f];
		label2.color = ccc3(0, 255, 0);
        
        CCMenuItemLabel *item = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(resumeGame)];
		CCMenuItemLabel *item2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(goToMain)];
		
		CCMenu *menu = [CCMenu menuWithItems:item,item2, nil];
		[menu alignItemsVerticallyWithPadding:10];
		
		[self addChild:menu z:1];
	}
	return self;
}

-(void) resumeGame {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"GameResumed" object:nil];
	[self removeFromParentAndCleanup:YES];
}

-(void) goToMain {
	[[[GameLayer sharedGameLayer] defaultShip] die];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"GameResumed" object:nil];
	[self removeFromParentAndCleanup:YES];
}

@end
