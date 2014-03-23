//
//  HighscoresScene.m
//  Fastfood Mayhem
//
//  Created by Interns on 8/13/13.
//
//

#import "HighscoresScene.h"

@implementation HighscoresScene

-(id) initWithScores:(NSArray*)scores {
	
	if (self = [super init]) {
		localScores = scores;
		
		//yOffset = 0;
		
		[self initScoreNodesWithMax:20];
		
		[self addChild:[CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)] z:-1];
		
		//CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"localleaderboard_back.png"];
		
		[self loadScores];
	}
	
	return self;
}

-(void) initScoreNodesWithMax:(int)max {
	
}

-(void) loadScores {
	
}

@end
