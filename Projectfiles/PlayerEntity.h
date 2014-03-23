/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HitBoxNode.h"

//#import "Component.h"
@class Component;

//By subclassing CCSprite you can add attributes like hitpoints and internal logic 
@interface PlayerEntity : CCSprite
{
    //example extra property you can give your new entity
    int hitpoints;
	CCSprite* hitBoxNode;
	CGRect hitBoxBBox;
	CGRect collisionBBox;
	int shipType;
}

@property (nonatomic, assign) bool dragging;
@property (nonatomic, assign) int dx;
@property (nonatomic) bool hit;

@property (nonatomic, assign) int dy;

+(id) createEntity;
-(id) initWithEntityImage:(NSString*)img;
-(void) takeDamage;
-(int) checkHitpoints;
-(BOOL) isOutsideScreenArea;
-(void) setPosition:(CGPoint)position;
-(void) setHit:(bool)hit;
-(void) checkForBulletCollisions;
-(void) checkForEnemyCollisions;
-(void) moveTowards:(CGPoint)point withSpeed:(float)speed;
-(void) die;
-(int) getShipType;
-(void) setShipType:(int)shipID;

@end
