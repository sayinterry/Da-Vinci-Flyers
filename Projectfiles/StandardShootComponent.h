/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim, Andreas Loew 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

//  Updated by Andreas Loew on 20.06.11:
//  * retina display
//  * framerate independency
//  * using TexturePacker http://www.texturepacker.com

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EnemyEntity.h"

// Why is it derived from CCSprite? Because enemies use a SpriteBatch, and CCSpriteBatchNode requires that all
// child nodes added to it are CCSprite. Under other circumstances I would use a CCNode as parent class of course, since
// the components won't have a texture and everything else that a Sprite has.
@interface StandardShootComponent : CCSprite 
{
	NSString* bulletFrameName;
    CGPoint velocity;
    bool inCD;
    int maxShots;
    float shotDelay;
    float CDDelay;
    float bulletSpeed;
	float totalTime;
	float nextShotTime;
	int shotsRemaining;
	float piOver6;
	int shotsFired;
}

@property (nonatomic, copy) NSString* bulletFrameName;
@property (nonatomic, assign) EnemyPattern pattern;

-(void) assignPattern:(EnemyPattern)pattern;
-(void) bossTypeInit:(EnemyTypes)bossType;

@end
