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

#import "StandardMoveComponent.h"
#import "Entity.h"
#import "GameLayer.h"
#import "PlayerEntity.h"
#import "EnemyEntity.h"

@implementation StandardMoveComponent

@synthesize type, pattern;

-(id) init
{
	if ((self = [super init]))
	{
		initialX = -1000;
		initialY = -1000;
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) assignPattern:(EnemyPattern)p {
    float w = [GameLayer screenRect].size.width;
    float h = [GameLayer screenRect].size.height;
    pattern = p;
    for (int i=0; i < EnemyPattern_MAX; i++) {
        switch (pattern) {
			case HexagonP1:
                equationAValue = ((0.5f*w)/(0.09f*powf(h, 2)));
                velocity = CGPointMake(0, -52);
                break;
            case HexagonP2:
                equationAValue = ((0.5f*w)/(0.09f*powf(h, 2)));
                velocity = CGPointMake(0, 52);
                break;
            case HexagonP3:
                equationAValue = ((0.5f*w)/(0.027f*powf(h, 3)));
                velocity = CGPointMake(0, -47);
                break;
            case HexagonP4:
                equationAValue = ((-1.f)*((0.5f*w)/(0.027f*powf(h, 3))));
                velocity = CGPointMake(0, 47);
                break;
			case HexagonP5:
				velocity = CGPointMake(-174, 0);
				break;
			case HexagonP6:
				velocity = CGPointMake(-174, 0);
				break;
			case HexagonP7:
				velocity = CGPointMake(-174, 0);
				break;
			case HexagonP8:
				velocity = CGPointMake(0, -100);
				equationAValue = M_PI/([GameLayer screenRect].size.height*0.5f);
				break;
			case HexagonP9:
				velocity = CGPointMake(0, -100);
				equationAValue = M_PI/([GameLayer screenRect].size.height*0.5f);
				break;
			case HexagonP10:
				velocity = CGPointMake(0, 100);
				equationAValue = M_PI/([GameLayer screenRect].size.height*0.5f);
				break;
			case HexagonP11:
				velocity = CGPointMake(0, 100);
				equationAValue = M_PI/([GameLayer screenRect].size.height*0.5f);
				break;
			case HexagonP12:
				velocity = CGPointMake(0,-50);
				equationAValue = (-0.82f*[GameLayer screenRect].size.width)/powf(0.9f*[GameLayer screenRect].size.height,2);
				break;
			case HexagonP13:
				velocity = CGPointMake(0, 50);
				equationAValue = (-0.82f*[GameLayer screenRect].size.width)/(powf((0.1*[GameLayer screenRect].size.height-[GameLayer screenRect].size.height), 2));
				break;
			case Square1P1:
				velocity = CGPointMake(-80,0);
				equationAValue = 0.06f;
				initialX = -1000;
				initialY = -1000;
				break;
			case OctagonP1:
				velocity = CGPointMake(-200,0);
				break;
			case FryMinionP1:
				velocity = CGPointMake(-150, 0);
				break;
			case FryMinionP2:
				velocity = CGPointMake(-150, 0);
				break;
            default:
                break;
        }
    }
}

-(void)bossTypeInit:(EnemyTypes)bossType {
	switch (bossType) {
		case EnemyTypeBoss1:
			velocity = CGPointMake(-20, 0);
			break;
		case EnemyTypeBoss2:
			velocity = CGPointMake(-20,0);
			break;
		case EnemyTypeBoss3:
			velocity = CGPointMake(-20,0);
			break;
		default:
			break;
	}
}

-(void) dealloc {
#ifndef KK_ARC_ENABLED
	[type release];
	[pattern release];
	[super dealloc];
#endif // KK_ARC_ENABLED
}

-(void) update:(ccTime)delta
{
	if (self.parent.visible) {
        
		NSAssert([self.parent isKindOfClass:[Entity class]], @"node is not a Entity");
		
		Entity* entity = (Entity*)self.parent;
        EnemyEntity* eEntity = (EnemyEntity*)self.parent;
        CGRect screenRect = [GameLayer screenRect];
		if (![GameLayer sharedGameLayer].inBossFight || eEntity.type == EnemyTypeBossMinions) {
			if (pattern == HexagonP1 || pattern == HexagonP2) {
				[entity setPosition:ccpAdd(entity.position, ccpMult(velocity, delta))];
				float xVal = equationAValue*powf(entity.position.y - (screenRect.size.height*0.5f),2) + (screenRect.size.width*0.5f);
				[eEntity setInPlace:true];
				[entity setPosition:ccp(xVal, entity.position.y)];
			} else if (pattern == HexagonP3 || pattern == HexagonP4) {
				[entity setPosition:ccpAdd(entity.position, ccpMult(velocity, delta))];
				float xVal = equationAValue*powf(entity.position.y - (screenRect.size.height*0.5f),3) + (screenRect.size.width*0.5f);
				[eEntity setInPlace:true];
				[entity setPosition:ccp(xVal, entity.position.y)];
			} else if (pattern == HexagonP5 || pattern == HexagonP6 || pattern == HexagonP7) {
				[entity setPosition:ccpAdd(entity.position, ccpMult(velocity, delta))];
				[eEntity setInPlace:true];
			} else if (pattern == HexagonP8 || pattern == HexagonP10) {
				[entity setPosition:ccpAdd(entity.position, ccpMult(velocity, delta))];
				float xVal = 50*sinf(equationAValue*entity.position.y) + screenRect.size.width*0.5f;
				[entity setPosition:ccp(xVal, entity.position.y)];
				[eEntity setInPlace:true];
			} else if (pattern == HexagonP9 || pattern == HexagonP11) {
				[entity setPosition:ccpAdd(entity.position, ccpMult(velocity, delta))];
				float xVal = -50*sinf(equationAValue*entity.position.y) + screenRect.size.width*0.74f;
				[entity setPosition:ccp(xVal, entity.position.y)];
				[eEntity setInPlace:true];
			} else if (pattern == HexagonP12) {
				[entity setPosition:ccpAdd(entity.position, ccpMult(velocity, delta))];
				float xVal = equationAValue*powf(entity.position.y,2)+0.82*screenRect.size.width;
				[entity setPosition:ccp(xVal, entity.position.y)];
				[eEntity setInPlace:true];
			} else if (pattern == HexagonP13) {
				[entity setPosition:ccpAdd(entity.position, ccpMult(velocity, delta))];
				float xVal = equationAValue*powf((entity.position.y-screenRect.size.height),2)+0.82*screenRect.size.width;
				[entity setPosition:ccp(xVal, entity.position.y)];
				[eEntity setInPlace:true];
			} else if (pattern == Square1P1) {
				if (entity.position.x > [GameLayer screenRect].size.width*0.78f) {
					[entity setPosition:ccpAdd(entity.position, ccpMult(velocity, delta))];
					[eEntity setInPlace:false];
				} else if ([eEntity.state isEqualToString:@"firing"] && [eEntity inPlace]) {
					if (initialY + initialX < 0) {
						initialX = entity.position.x;
						initialY = entity.position.y;
						if (initialY < screenRect.size.height*0.5f) {
							equationAValue = -equationAValue;
						}
					}
				} else if ([eEntity.state isEqualToString:@"exit"] && [eEntity inPlace]) {
					[entity setPosition:ccpAdd(entity.position, ccpMult(velocity, delta))];
					float yVal = equationAValue*powf(entity.position.x-initialX, 2)+initialY;
					[entity setPosition:ccp(entity.position.x, yVal)];
				} else {
					[eEntity setInPlace:true];
				}
			} else if (pattern == OctagonP1) {
				if (entity.position.x > 0.6f*screenRect.size.width) {
					[entity setPosition:ccpAdd(entity.position, ccpMult(velocity, delta))];
					[eEntity setInPlace:false];
				} else if ([eEntity.state isEqualToString:@"exit"] && [eEntity inPlace]) {
					if (eEntity.position.y > 0.5f*screenRect.size.height) {
						[entity setPosition:ccpAdd(entity.position, ccpMult(ccp(0,280), delta))];
					} else {
						[entity setPosition:ccpAdd(entity.position, ccpMult(ccp(0,-280), delta))];
					}
				} else {
					[eEntity setInPlace:true];
				}
			} else if (pattern == FryMinionP1 || pattern == FryMinionP2) {
				[entity setPosition:ccpAdd(entity.position, ccpMult(velocity, delta))];
				[eEntity setInPlace:true];
			}
		} else if ([GameLayer sharedGameLayer].inBossFight && eEntity.type >= EnemyTypeBoss1) {
			if (eEntity.type == EnemyTypeBoss1) {
				if ([eEntity.state isEqualToString:@"init"]) {
					[eEntity setPosition:ccpAdd(eEntity.position, ccpMult(velocity, delta))];
					if (eEntity.position.x <= screenRect.size.width*0.78f) {
						[eEntity setInPlace:true];
						velocity = ccp(0,-100);
						[eEntity reset];
					}
				} else {
					if ([eEntity.state isEqualToString:@"standby"]) {
						if (eEntity.inPlace) {
							if (eEntity.position.y < screenRect.size.height*0.25f) {
								velocity = ccp(0,100);
							} else if (eEntity.position.y > screenRect.size.height*0.75f) {
								velocity = ccp(0,-100);
							}
							[eEntity setPosition:ccpAdd(eEntity.position, ccpMult(velocity, CCRANDOM_0_1()*0.5f*delta+delta*0.8f))];
						}
					} else if ([eEntity.state isEqualToString:@"rush"]) {
						if ([eEntity numberOfRunningActions] == 0 && !eEntity.inPlace) {
							id moveAction = [CCMoveTo actionWithDuration:0.6f position:ccp(eEntity.position.x, screenRect.size.height*0.8f)];
							id delayAction = [CCDelayTime actionWithDuration:2.0f];
							id setInPlace = [CCCallBlock actionWithBlock:^{
								[eEntity setInPlace:true];
							}];
							[eEntity runAction:[CCSequence actions:moveAction,delayAction,setInPlace, nil]];
							velocity = ccp(-50,0);
						} else if (eEntity.inPlace) {
							if (eEntity.position.x < screenRect.size.width+[eEntity contentSize].width*0.5f) {
								velocity = ccpAdd(velocity, ccp(velocity.x*0.1f,0));
								[eEntity setPosition:ccpAdd(eEntity.position, ccpMult(velocity, delta))];
							}
							if (eEntity.position.x <= -[eEntity contentSize].width) {
								velocity = ccp(20,0);
								[eEntity setFlipX:true];
								[eEntity setPosition:ccp(-[eEntity contentSize].width*0.5f, screenRect.size.height*0.2f)];
							}
							if (eEntity.position.x >= screenRect.size.width+[eEntity contentSize].width*0.5f && [eEntity numberOfRunningActions] == 0) {
								[eEntity setFlipX:false];
								id moveAction = [CCMoveTo actionWithDuration:0.8f position:ccp(screenRect.size.width*0.78f, screenRect.size.height*0.5f)];
								id resetAction = [CCCallBlock actionWithBlock:^{
									[eEntity reset];
								}];
								velocity = ccp(0,-100);
								[eEntity runAction:[CCSequence actions:moveAction,resetAction, nil]];
							}
						}
					}
				}
			} else if (eEntity.type == EnemyTypeBoss2) {
				if ([eEntity.state isEqualToString:@"init"]) {
					[eEntity setPosition:ccpAdd(eEntity.position, ccpMult(velocity, delta))];
					if (eEntity.position.x <= screenRect.size.width*0.78f) {
						[eEntity setInPlace:true];
						velocity = ccp(0,-100);
						[eEntity reset];
					}
				} else {
					if ([eEntity.state isEqualToString:@"standby"]) {
						if (eEntity.inPlace) {
							if (eEntity.position.y < screenRect.size.height*0.2f) {
								velocity = ccp(0,200);
							} else if (eEntity.position.y > screenRect.size.height*0.8f) {
								velocity = ccp(0,-200);
							}
							[eEntity setPosition:ccpAdd(eEntity.position, ccpMult(velocity, CCRANDOM_0_1()*0.5f*delta+delta*0.8f))];
						}
					} else if ([eEntity.state isEqualToString:@"sesameGatling"] || [eEntity.state isEqualToString:@"sesameGatling-charging"]) {
						if ([eEntity numberOfRunningActions] == 0 && !eEntity.inPlace) {
							id moveAction = [CCMoveTo actionWithDuration:0.6f position:ccp(eEntity.position.x, screenRect.size.height*0.5f)];
							id delayAction = [CCDelayTime actionWithDuration:3.0f];
							id setInPlace = [CCCallBlock actionWithBlock:^{
								[eEntity setInPlace:true];
								[eEntity setState:@"sesameGatling-charging"];
							}];
							[eEntity runAction:[CCSequence actions:moveAction,delayAction,setInPlace, nil]];
						} else if (eEntity.inPlace) {
							if ([eEntity.state isEqualToString:@"sesameGatling-charging"]) {
								id delayAction = [CCDelayTime actionWithDuration:3.0f];
								id setStateFire = [CCCallBlock actionWithBlock:^{
									[eEntity setState:@"sesameGatling-fire"];
								}];
								[eEntity runAction:[CCSequence actions:delayAction,setStateFire, nil]];
							}
						}
					} else if ([eEntity.state isEqualToString:@"ketchupLaser"]) {
						if ([eEntity numberOfRunningActions] == 0 && ![eEntity inPlace]) {
							id moveAction = [CCMoveTo actionWithDuration:0.6f position:ccp(eEntity.position.x, screenRect.size.height*0.15f)];
							id setInPlace = [CCCallBlock actionWithBlock:^{
								[eEntity setInPlace:true];
								[eEntity setState:@"ketchupLaser-charge"];
							}];
							id delayAction = [CCDelayTime actionWithDuration:6];
							id setToFire = [CCCallBlock actionWithBlock:^{
								[eEntity setState:@"ketchupLaser-fire"];
							}];
							[eEntity runAction:[CCSequence actions:moveAction,setInPlace, delayAction,setToFire, nil]];
						}
					} else if ([eEntity inPlace] && [eEntity.state isEqualToString:@"ketchupLaser-charge"]) {
						GameLayer *game = [GameLayer sharedGameLayer];
						float theta = atan2f(([[game defaultShip] boundingBoxCenter].y-eEntity.position.y), ([[game defaultShip]  boundingBoxCenter].x-eEntity.position.x));
						[eEntity setRotation:theta*(-180*M_1_PI)+180];
					}
				}
			} else if (eEntity.type == EnemyTypeBoss3) {
				if ([eEntity.state isEqualToString:@"init"]) {
					[eEntity setPosition:ccpAdd(eEntity.position, ccpMult(velocity, delta))];
					if (eEntity.position.x <= screenRect.size.width*0.78f) {
						[eEntity setInPlace:true];
						[eEntity setState:@"standby"];
					}
				}
			}
		} else {
			velocity = ccp(100,0);
			[eEntity setPosition:ccpAdd(eEntity.position,ccpMult(velocity, delta))];
		}
	} else {
		initialX = -1000;
		initialY = -1000;
		
	}
}


@end
