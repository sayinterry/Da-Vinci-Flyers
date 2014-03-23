//
//  StoreLayer.m
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 8/2/13.
//
//

#import "StoreLayer.h"
#import "GenericMenuLayer.h"

@implementation StoreLayer

-(id) init {
	if (self = [super init]) {
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"NOTHING TO DO HERE" fontName:@"arial" fontSize:30];
		
		CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(goBackToMain)];
		CCMenu *menu = [CCMenu menuWithItems:item1, nil];
		[self addChild:menu];
		menu.position = ccp(240,160);
	}
	return self;
}

-(void) goBackToMain {
	[[CCDirector sharedDirector] replaceScene:[[GenericMenuLayer alloc] init]];
}

@end
