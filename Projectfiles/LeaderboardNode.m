//
//  LeaderboardNode.m
//  Fastfood Mayhem
//
//  Created by Interns on 8/12/13.
//
//

#import "LeaderboardNode.h"

@implementation LeaderboardNode


-(id)init {
    if (self = [super init]) {
        [self structureScoreboardEntries:nil];
		CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"leaderboard-back.png"];
		[self addChild:backgroundSprite z:-1 tag:1];
    }
    
    return self;
}

- (void)reloadWithScoreBoard:(NSDictionary *)scoreboardArg
{
    [self structureScoreboardEntries:scoreboardArg];
    
    [self removeChild:globalLeaderBoardNode];
    
    [self createLeaderboardNodes];
    [self createLeaderboardEntriesForLeaderboard:globalScoreboard amountOfEntries:20 node:globalLeaderBoardNode];
}

- (void)structureScoreboardEntries:(NSDictionary *)scoreboardArg
{
    scoreboard = scoreboardArg;
    globalScoreboard = [scoreboard objectForKey:@"all"];
}

-(void) createLeaderboardNodes {
    globalLeaderBoardNode = [CCNode node];
    globalLeaderBoardNode.contentSize = CGSizeMake([self getChildByTag:1].contentSize.width, [self getChildByTag:1].contentSize.height*0.8f);
	layoutingYPosition = globalLeaderBoardNode.contentSize.height*0.28f;
    [self addChild:globalLeaderBoardNode z:2];
}

- (void)createLeaderboardEntriesForLeaderboard:(NSArray *)leaderboard amountOfEntries:(unsigned int)amountOfEntries node:(CCNode *)node {
    unsigned int displayAmount = MIN(amountOfEntries, [leaderboard count]);
	
    if (displayAmount == 0)
    {
		[self addLeaderboardEntryToNode:node withString:@"Currently no entries available."];
        return;
    }
    
    // add global entries
    for (unsigned int i = 0; i < displayAmount; i++)
    {
        // get the leaderboard entry for the current rank
        NSDictionary *leaderboardEntry = [leaderboard objectAtIndex:i];
        
        NSString *name = [[leaderboardEntry objectForKey:@"name"] stringByDeletingPathExtension];
        NSString *nameSuffix = @"";
        NSNumber *score = [leaderboardEntry objectForKey:@"score"];
		NSString *shipID = [[leaderboardEntry objectForKey:@"name"] pathExtension];
        
        int rank = i+1;
        
        [self addLeaderboardEntryToNode:node withName:name nameSuffix:nameSuffix rank:rank score:[score intValue] shipID:shipID];
    }
}

- (void)addLeaderboardEntryToNode:(CCNode *)node withName:(NSString *)name nameSuffix:(NSString *)nameSuffix rank:(int)rank score:(int)score shipID:(NSString *)shipID
{
    // TODO: Make sure name and score fit on to the leaderboard
    NSString *highscoreString = [NSString stringWithFormat:@"%d. %@%@: %d", rank, name, nameSuffix, score];
	CCSprite *shipImage;
	if ([shipID isEqualToString:@"1"]) {
		shipImage = [CCSprite spriteWithSpriteFrameName:@"lives.png"];
	} else if ([shipID isEqualToString:@"2"]) {
		shipImage = [CCSprite spriteWithSpriteFrameName:@"lives2.png"];
	} else if ([shipID isEqualToString:@"3"]) {
		shipImage = [CCSprite spriteWithSpriteFrameName:@"lives3.png"];
	}
    
    CCLabelTTF *leaderboardEntryLabel = [CCLabelTTF labelWithString:highscoreString
                                                           fontName:@"arial"
                                                           fontSize:15];
    leaderboardEntryLabel.color = ccBLACK;
	leaderboardEntryLabel.anchorPoint = ccp(0, 1);
	leaderboardEntryLabel.position = ccp(-100, layoutingYPosition);
    [node addChild:leaderboardEntryLabel];
	[leaderboardEntryLabel addChild:shipImage];
	shipImage.position = ccp(leaderboardEntryLabel.contentSize.width+shipImage.contentSize.width, leaderboardEntryLabel.contentSize.height*0.5f);
    layoutingYPosition -= leaderboardEntryLabel.contentSize.height;
}

- (void)addLeaderboardEntryToNode:(CCNode *)node withString:(NSString *)string
{
	CCLabelTTF *leaderboardEntryLabel = [CCLabelTTF labelWithString:string
                                                           fontName:@"arial"
                                                           fontSize:15];
    leaderboardEntryLabel.color = ccBLACK;
    leaderboardEntryLabel.anchorPoint = ccp(0, 1);
    leaderboardEntryLabel.position = ccp(-100, layoutingYPosition);
    [node addChild:leaderboardEntryLabel];
    layoutingYPosition -= leaderboardEntryLabel.contentSize.height;
}

@end
