//
//  HighscoresScene.h
//  Fastfood Mayhem
//
//  Created by Interns on 8/13/13.
//
//

#import "CCScene.h"

@interface HighscoresScene : CCScene
{
	NSArray *localScores;
    NSArray *localScoreBoard;
}

-(id) initWithScores:(NSDictionary*)scores;

@end
