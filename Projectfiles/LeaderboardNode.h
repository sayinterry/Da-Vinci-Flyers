//
//  LeaderboardNode.h
//  Fastfood Mayhem
//
//  Created by Interns on 8/12/13.
//
//

#import "CCNode.h"

@interface LeaderboardNode : CCNode
{
	NSDictionary *scoreboard;
    NSArray *globalScoreboard;
	CCSprite *friendsLeaderBoardNode;
    CCSprite *globalLeaderBoardNode;
	int layoutingYPosition;
}

-(void)reloadWithScoreBoard:(NSDictionary *)scoreboardArg;

@end
