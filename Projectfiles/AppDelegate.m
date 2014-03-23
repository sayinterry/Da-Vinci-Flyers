/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "AppDelegate.h"

@implementation AppDelegate

-(void) initializationComplete
{
#ifdef KK_ARC_ENABLED
	CCLOG(@"ARC is enabled");
#else
	CCLOG(@"ARC is either not available or not enabled");
#endif
	[MGWU loadMGWU:@"C9132EA11B8D0E0C240367509E3E02E7800961B708E09A6597F1AE63A5D23DB7"];
	[MGWU preFacebook];
}

-(id) alternateRootViewController
{
	return nil;
}

-(id) alternateView
{
	return nil;
}

@end
