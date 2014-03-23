//
//  RecapScreenScene.m
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 8/2/13.
//
//

#import "RecapScreenScene.h"
#import "StatisticsNode.h"
#import "GameLayer.h"
#import "MainLayer.h"
#import "GenericMenuLayer.h"
#import "Leaderboard.h"
#import "LeaderboardNode.h"
#import "PlayerEntity.h"

@implementation RecapScreenScene

-(id) init {
	if (self = [super init]) {
		score = [MainLayer sharedLayer].score-1537;
		distance = (int)floorf([GameLayer sharedGameLayer].distanceTraveled);
		shipType = [[[GameLayer sharedGameLayer] defaultShip] getShipType];
		NSArray *statsArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d points", score],[NSString stringWithFormat:@"%d meters", distance], nil];
		
		statisticsNode = [[StatisticsNode alloc] initWithTitle:@"Game Over" highScoreStrings:statsArray];
		[self addChild:statisticsNode];
		statisticsNode.position = ccp([GameLayer screenRect].size.width*0.15f, [GameLayer screenRect].size.height*0.8f);
		
		leaderboardNode = [[LeaderboardNode alloc] init];
		[self addChild: leaderboardNode];
		[leaderboardNode setPosition:ccp([GameLayer screenRect].size.width*0.75f, [GameLayer screenRect].size.height*0.75f) ];
		
		
		[self addChild:[CCLayerColor layerWithColor:ccc4(0, 255, 255, 255)] z:-1];
		
		CCMenuItemImage *store = [CCMenuItemImage itemWithNormalImage:@"shop.png" selectedImage:@"shop.png" target:self selector:@selector(goToStore)];
		CCMenuItemImage *replay = [CCMenuItemImage itemWithNormalImage:@"replay.png" selectedImage:@"replay.png" target:self selector:@selector(playAgain)];
		CCMenu *menu = [CCMenu menuWithItems:replay, nil];
		//CCMenu *menu = [CCMenu menuWithItems:store,replay, nil];
		[menu alignItemsHorizontallyWithPadding:5];
		[menu setPosition:ccp([MainLayer screenRect].size.width*0.7f, [MainLayer screenRect].size.height*0.07f)];
		[self addChild:menu];
		
		
		CCLabelTTF *sShipLabel = [CCLabelTTF labelWithString:@"Select a ship" fontName:@"arial" fontSize:20];
		sShipLabel.color = ccc3(255, 255, 255);
		CCMenuItemImage *ship1 = [CCMenuItemImage itemWithNormalImage:@"lives3.png" selectedImage:@"ship3.png" target:self selector:@selector(ship3Select)];
		CCMenuItemImage *ship2 = [CCMenuItemImage itemWithNormalImage:@"lives.png" selectedImage:@"ship.png" target:self selector:@selector(ship1Select)];
		CCMenuItemImage *ship3 = [CCMenuItemImage itemWithNormalImage:@"lives2.png" selectedImage:@"ship2.png" target:self selector:@selector(ship2Select)];
		CCMenu *menu2 = [CCMenu menuWithItems:ship1, ship2, ship3, nil];
		[menu2 alignItemsHorizontallyWithPadding:5];
		[menu2 setPosition:ccp([MainLayer screenRect].size.width*0.13f, [MainLayer screenRect].size.height*0.87f)];
		[sShipLabel setPosition:ccp(menu2.position.x, menu2.position.y+sShipLabel.contentSize.height)];
		[self addChild:menu2 z:2];
		[self addChild:sShipLabel z:2];
	}
	return self;
}

-(void) ship1Select {
	[[MainLayer sharedLayer] setShipType:1];
}

-(void) ship2Select {
	[[MainLayer sharedLayer] setShipType:2];
}

-(void) ship3Select {
	[[MainLayer sharedLayer] setShipType:3];
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
        // if no unsername is set yet, prompt dialog and submit highscore then
        [self presentUsernameDialog];
}

-(void) goToStore {
	
}

-(void) playAgain {
	[[MainLayer sharedLayer] resetGame];
	[[GameLayer sharedGameLayer] resetGame];
	[[GameLayer sharedGameLayer] scheduleUpdate]; 
	[[CCDirector sharedDirector] replaceScene:[CCTransitionTurnOffTiles transitionWithDuration:0.48f scene:[MainLayer sharedLayer]]];
	//[[CCDirector sharedDirector] replaceScene:[MainLayer sharedLayer]];
}

- (void)presentUsernameDialog
{
    usernamePrompt = [[UIAlertView alloc] init];
    usernamePrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    usernamePrompt.title = @"Enter your name.";
    [usernamePrompt addButtonWithTitle:@"OK"];
    [usernamePrompt show];
    usernamePrompt.delegate = self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == usernamePrompt) {
        if (buttonIndex == 0) {
            // user name entered
            UITextField *usernameTextField = [alertView textFieldAtIndex:0];
            NSString *username = usernameTextField.text;
			NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789.`"] invertedSet];
			
			if ([username rangeOfCharacterFromSet:set].location != NSNotFound) {
				[self presentErrorDialog:@"This name contains illegal characters."];
			} else if ([username length] == 0) {
				[self presentErrorDialog:@"The name field was left blank!"];
			} else if ([username length] > 10) {
				[self presentErrorDialog:@"The name is too long. Please make it less than 10 characters."];
			} else {
            // save the user name
				[Leaderboard setUserName:username];
				
				NSString *nameWithShip = [username stringByAppendingPathExtension:[NSString stringWithFormat:@"%d", shipType]];
				[MGWU submitHighScore:score byPlayer:nameWithShip forLeaderboard:@"defaultLeaderboard" withCallback:@selector(receivedScores:) onTarget:self];
				[self submitLocalScore:score byPlayer:nameWithShip ];
			}
        }
    } else if (alertView == alertPrompt) {
		if (buttonIndex == 0) {
			[self presentUsernameDialog];
		}
	}
}

-(void) presentErrorDialog:(NSString*)message {
	alertPrompt = [[UIAlertView alloc] init];
    alertPrompt.alertViewStyle = UIAlertViewStyleDefault;
    alertPrompt.title = message;
    [alertPrompt addButtonWithTitle:@"OK"];
    [alertPrompt show];
    alertPrompt.delegate = self;
}

-(void) submitLocalScore:(int)points byPlayer:(NSString*)username {
	NSArray *test = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"localScoreboard"] copy];
	NSMutableArray *localScore = [NSMutableArray arrayWithArray:test];
	NSMutableArray *newScore = [NSMutableArray arrayWithObjects:username, [NSNumber numberWithInt:score], nil];
	if ([localScore count] > 0) {
		for (NSUInteger i=0; i<[localScore count]; i++) {
			if ([[[localScore objectAtIndex:i] objectAtIndex:1] intValue] <= points) {
				[localScore insertObject:newScore atIndex:i];
				break;
			}
		}
	} else {
		[localScore addObject:newScore];
	}
	[[NSUserDefaults standardUserDefaults] setObject:localScore forKey:@"localScoreboard"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) receivedScores:(NSDictionary*)scores {
	[leaderboardNode reloadWithScoreBoard:scores];
}

@end
