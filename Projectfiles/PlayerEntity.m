/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */


#import "PlayerEntity.h"
#import "GameLayer.h"
#import "BulletCache.h"
#import "EnemyCache.h"
#import "MainLayer.h"
#import "HitBoxNode.h"

@implementation PlayerEntity

//This is the method other classes should call to create an instance of Entity
+(id) createEntity
{
	NSString *img;
	if ([[MainLayer sharedLayer] getShipType] == 1) {
		img = @"ship.png";
	} else if ([[MainLayer sharedLayer] getShipType] == 2) {
		img = @"ship2.png";
	} else if ([[MainLayer sharedLayer] getShipType] == 3) {
		img = @"ship3.png";
	}
	id myEntity = [[self alloc] initWithEntityImage:img];
    
//Don't worry about this, this is memory management stuff that will be handled for you automatically    
#ifndef KK_ARC_ENABLED
	[myEntity autorelease];
#endif // KK_ARC_ENABLED
    return myEntity;
}

-(id) initWithEntityImage:(NSString*)img
{
	// Loading the Entity's sprite using a file, is a ship for now but you can change this
	if ((self = [super initWithSpriteFrameName:img]))
	{
        hitpoints = 3;
        self.hit = false;
		self.dragging = false;
        self.dx = 0;
        self.dy = 0;
		shipType = [[MainLayer sharedLayer] getShipType];
        hitBoxNode = [[CCSprite alloc] initWithSpriteFrameName:@"hitbox.png"];
        [self addChild:hitBoxNode z:2 tag:11];
        hitBoxNode.position = ccp(self.boundingBox.size.width/2-(self.boundingBox.size.width/2*0.07), self.boundingBox.size.height/2);
	}
	return self;
}


// You can override setPosition, a method inherited from CCSprite, to keep entitiy within screen bounds


-(void) setPosition:(CGPoint)pos
{
	// If the current position is (still) outside the screen no adjustments should be made!
	// This allows entities to move into the screen from outside.
	if ([self isOutsideScreenArea])
	{
		CGRect screenRect = [GameLayer screenRect];
		float halfWidth = self.contentSize.width * 0.5f;
		float halfHeight = self.contentSize.height * 0.5f;
		
		// Cap the position so the Ship's sprite stays on the screen
		if (pos.x < halfWidth+1)
		{
			pos.x = halfWidth+1;
		}
		else if (pos.x > (screenRect.size.width - 3*halfWidth))
		{
			pos.x = screenRect.size.width - 3*halfWidth;
		}
		
		if (pos.y < halfHeight)
		{
			pos.y = halfHeight;
		}
		else if (pos.y > (screenRect.size.height - halfHeight))
		{
			pos.y = screenRect.size.height - halfHeight;
		}
	}
	
	[super setPosition:pos];
}

-(int) getShipType {
	return shipType;
}
 
-(BOOL) isOutsideScreenArea
{
	return (CGRectContainsRect([GameLayer screenRect], [self boundingBox]));
}

-(void) toggleVisible {
    if (self.visible == TRUE) {
        [self setVisible:FALSE];
    } else if (self.visible == FALSE) {
        [self setVisible:TRUE];
    }
}

//example methods you can add that a normal CCSprite doesn't have
-(void) takeDamage
{
    hitpoints -= 1;
    [[MainLayer sharedLayer] setHealth:hitpoints];
    if (hitpoints > -1) {
        self.hit = TRUE;
		
		[[GameLayer sharedGameLayer] playerHitBomb];
		[self scheduleOnce:@selector(toggleHit) delay:2];
    } else {
        [self setVisible:FALSE];
        CCParticleSystem* system;
        system = [CCParticleSystemQuad particleWithFile:@"fx-explosion.plist"];
        // Set some parameters that can't be set in Particle Designer
        system.positionType = kCCPositionTypeFree;
        system.autoRemoveOnFinish = YES;
        system.position = self.position;
        [[GameLayer sharedGameLayer] addChild:system];
		[[GameLayer sharedGameLayer] gameOver];
    }
}

-(void) die {
	hitpoints = -1;
	[[MainLayer sharedLayer] setHealth:hitpoints];
	[self setVisible:FALSE];
	CCParticleSystem* system;
	system = [CCParticleSystemQuad particleWithFile:@"fx-explosion.plist"];
	// Set some parameters that can't be set in Particle Designer
	system.positionType = kCCPositionTypeFree;
	system.autoRemoveOnFinish = YES;
	system.position = self.position;
	[[GameLayer sharedGameLayer] addChild:system];
	[[GameLayer sharedGameLayer] gameOver];
}

-(void) toggleHit {
	if (self.hit) {
		self.hit = FALSE;
	} else {
		self.hit = TRUE;
	}
}

-(void) checkForBulletCollisions {
    if (self.visible && self.hit == false) {
        BulletCache* bulletCache = [[GameLayer sharedGameLayer] bulletCache];
        if ([bulletCache isEnemyBulletCollidingWithPlayer]) {
            [self takeDamage];
        }
	}
}

-(void) checkForEnemyCollisions {
    if (self.visible && self.hit == false) {
		EnemyCache* eCache = [[GameLayer sharedGameLayer] enemyCache];
		if ([eCache isEnemyCollidingWithRect:self.boundingBox]) {
			[self takeDamage];
		}
	}
}

-(void) moveTowards:(CGPoint)point withSpeed:(float)speed {
	float theta = atan2f(point.y-self.position.y, point.x-self.position.x);
	float nX = self.position.x+speed*(cosf(theta));
	float nY = self.position.y+speed*(sinf(theta));
	[self setPosition:ccp(nX, nY)];
}

-(void) setShipType:(int)shipID {
	shipType = shipID;
}

-(int) checkHitpoints
{
    return hitpoints;
}

@end
