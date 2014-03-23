//
//  SelectShipNode.h
//  Fastfood Mayhem
//
//  Created by Interns on 8/15/13.
//
//

#import "CCNode.h"

@interface SelectShipNode : CCNode
{
	CCSprite *shipChild;
	NSMutableArray *shipArray;
	float t;
	float xRadius;
	float yRadius;
	float thetaMultiple;
	float tMult;
}

-(void) putAllShipsInPositionWithTMultiple:(float)tVal;
-(void) updateShipLocationsPos;
-(void) updateShipLocationsNeg;
-(int) getSelectedShip;

@end
