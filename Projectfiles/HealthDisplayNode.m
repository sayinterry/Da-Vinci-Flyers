//
//  HealthDisplayNode.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/16/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "HealthDisplayNode.h"

@implementation HealthDisplayNode

@synthesize health = _health;

- (id)initWithHealthImage:(NSString*)healthImg maxHealth:(int)mHealth
{
    self = [super init];
    
    if (self)
    {
        maxHealth = mHealth;
		CCLabelTTF* livesLeftLabel = [CCLabelTTF labelWithString:@"Shield Guage" fontName:@"arial" fontSize:15.0f];
		livesLeftLabel.color = ccc3(255, 255, 255);
		//livesLeftLabel.anchorPoint = ccp(0,0.5);
        healthSprites = [[NSMutableArray alloc] init];
        
        // create Sprites for the total available health
        int xPos = 0;
        for (int i = 0; i < maxHealth; i++)
        {
            CCSprite *healthSprite = [CCSprite spriteWithSpriteFrameName:healthImg];
            healthSprite.anchorPoint = ccp(0,1);
            healthSprite.position = ccp(xPos,healthSprite.contentSize.height);
            xPos += healthSprite.contentSize.width;
            [self addChild:healthSprite z:1 tag:1];
            [healthSprites addObject:healthSprite];
			[healthSprite unscheduleUpdate];
        }
		
		[self addChild:livesLeftLabel];
		[livesLeftLabel setPosition:ccp(livesLeftLabel.contentSize.width*0.4f, [self getChildByTag:1].contentSize.height+livesLeftLabel.contentSize.height*0.5f)];
        
        self.anchorPoint = ccp(0.5, 0.5);
        self.contentSize = CGSizeMake(livesLeftLabel.contentSize.width, [self getChildByTag:1].contentSize.height+livesLeftLabel.contentSize.height);
    }
    
    return self;
}

-(void) resetHealthWithImage:(NSString *)img {
	int xPos = 0;
	[self removeChildrenInArray:healthSprites cleanup:YES];
	[healthSprites removeAllObjects];
	for (int i = 0; i < maxHealth; i++)
	{
		CCSprite *healthSprite = [CCSprite spriteWithSpriteFrameName:img];
		healthSprite.anchorPoint = ccp(0,1);
		healthSprite.position = ccp(xPos,healthSprite.contentSize.height);
		xPos += healthSprite.contentSize.width;
		[self addChild:healthSprite z:1 tag:1];
		[healthSprites addObject:healthSprite];
		[healthSprite unscheduleUpdate];
	}
}

- (void)setHealth:(int)health
{
    //update UI according to the new amount of health
    if (health != _health)
    {
        _health = health;
        
        for (int i = 0; i < maxHealth; i++)
        {
            CCSprite *healthSprite = [healthSprites objectAtIndex:i];
            
            if (i < health)
            {
                // activate all health images for the available health
                healthSprite.visible = true;
            } else {
                // deactivate health images for lost healthes
                healthSprite.visible = false;
            }
        }
    }
}

@end
