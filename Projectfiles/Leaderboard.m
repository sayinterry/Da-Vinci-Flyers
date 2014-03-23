//
//  Leaderboard.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/15/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "Leaderboard.h"
#import "MainLayer.h"
#import "GameLayer.h"

#define USERNAME_KEY @"UserName"

@implementation Leaderboard

+ (void)setUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:USERNAME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userName
{
    // first try using the facebook name, if unavailable, use the locally stored name
    NSString *userName = [MGWU getUsername];
    
    if (userName == nil)
    {
        userName = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME_KEY];
    }
    
    return userName;
}

+ (NSArray *)globalLeaderBoardEntries
{
    return @[@"Entry 1", @"Entry 2", @"Entry 3"];
}

+ (NSArray *)friendsLeaderBoardEntries
{
    return nil;
}

@end
