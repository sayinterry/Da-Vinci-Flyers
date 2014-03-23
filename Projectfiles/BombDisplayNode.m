//
//  BombDisplayNode.m
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 8/2/13.
//
//

#import "BombDisplayNode.h"

@implementation BombDisplayNode

@synthesize bombs = _bombs;

- (id)initWithBombImage:(NSString*)bombImg maxBombs:(int)mBombs
{
    self = [super init];
    
    if (self) {
        maxBombs = mBombs;
		CCLabelTTF* bombsLeftLabel = [CCLabelTTF labelWithString:@"Bombs Left" fontName:@"arial" fontSize:15.0f];
		bombsLeftLabel.color = ccc3(255, 255, 255);
        bombSprites = [[NSMutableArray alloc] init];
        
        // create Sprites for the total available health
        int xPos = 0;
        for (int i = 0; i < maxBombs; i++) {
            CCSprite *bombSprite = [CCSprite spriteWithSpriteFrameName:bombImg];
            bombSprite.anchorPoint = ccp(0,1);
            bombSprite.position = ccp(xPos,bombSprite.contentSize.height);
            xPos += bombSprite.contentSize.width;
            [self addChild:bombSprite z:1 tag:1];
            [bombSprites addObject:bombSprite];
        }
		
		[self addChild:bombsLeftLabel];
		[bombsLeftLabel setPosition:ccp(bombsLeftLabel.contentSize.width*0.4f, [self getChildByTag:1].contentSize.height+bombsLeftLabel.contentSize.height*0.5f)];
        
        self.anchorPoint = ccp(0.5, 0.5);
        self.contentSize = CGSizeMake(xPos, [self getChildByTag:1].contentSize.height+bombsLeftLabel.contentSize.height);
    }
    
    return self;
}

- (void)setBombs:(int)bomb
{
    //update UI according to the new amount of health
    if (bomb != _bombs)
    {
        _bombs = bomb;
        
        for (int i = 0; i < maxBombs; i++)
        {
            CCSprite *bombSprite = [bombSprites objectAtIndex:i];
            
            if (i < bomb)
            {
                // activate all health images for the available health
                bombSprite.visible = true;
            } else {
                // deactivate health images for lost healthes
                bombSprite.visible = false;;
            }
        }
    }
}

@end
