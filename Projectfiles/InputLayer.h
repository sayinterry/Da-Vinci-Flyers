//
//  InputLayer.h
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 6/21/13.
//
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InputLayer : CCLayer
{
	ccTime totalTime;
	ccTime nextShotTime;
	CCSprite *skillShot;
	KKTouch *playerDragTouch;
}

@end
