//
//  RecapScreenScene.h
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 8/2/13.
//
//

#import "CCScene.h"
#import "LeaderboardNode.h"

@interface RecapScreenScene : CCScene <UIAlertViewDelegate>
{
	CCNode *statisticsNode;
	UIAlertView *usernamePrompt;
	UIAlertView *alertPrompt;
	int score;
	int distance;
	LeaderboardNode *leaderboardNode;
	int shipType;
}



@end
