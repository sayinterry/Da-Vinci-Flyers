//
//  SelectShipNode.m
//  Fastfood Mayhem
//
//  Created by Interns on 8/15/13.
//
//

#import "SelectShipNode.h"
#import "GenericMenuLayer.h"

@implementation SelectShipNode

-(id) init {
	self = [super init];
	if (self) {
		t=0;
		tMult = 0;
		xRadius = 80;
		yRadius = 20;
		self.contentSize = CGSizeMake(xRadius*2, yRadius*2);
		CCSprite *backgroundSprite = [CCSprite spriteWithSpriteFrameName:@"selectship-background.png"];
		backgroundSprite.position = ccp(self.contentSize.width*0.5f, self.contentSize.height*0.7f);
		[self addChild:backgroundSprite];
		shipArray = [[NSMutableArray alloc] init];
		int shipAmount = 3;
		NSString *shipImg;
		for (int i=0; i<shipAmount; i++) {
			if (i == 0) {
				shipImg = @"lives.png";
			} else if (i == 1) {
				shipImg = @"lives2.png";
			} else if (i == 2) {
				shipImg = @"lives3.png";
			} else if (i == 3) {
				shipImg = @"lives.png";
			}
			shipChild = [[CCSprite alloc] initWithSpriteFrameName:shipImg];
			[self addChild:shipChild];
			[shipArray addObject:shipChild];
			
		}
		thetaMultiple = (1/(float)[shipArray count])*2*M_PI;
		[self putAllShipsInPositionWithTMultiple:0];
	}
	return self;
}

-(void) putAllShipsInPositionWithTMultiple:(float)tVal {
	t = tVal*thetaMultiple;
	for (NSUInteger i=0; i<[shipArray count]; i++) {
		shipChild = [shipArray objectAtIndex:i];
		float theta = i*thetaMultiple+t;
//		float theta = i*thetaMultiple+t-(thetaMultiple*0.5f);
		float xVal = xRadius*sinf(theta-M_PI)+self.contentSize.width*0.5f;
		float yVal = yRadius*cosf(theta-M_PI)+yRadius;
		[shipChild setPosition:ccp(xVal, yVal)];
	}
}

-(void) updateShipLocationsPos {
	tMult += 5;
	[self putAllShipsInPositionWithTMultiple:tMult*0.01f];
	if (fmodf(tMult, 100) != 0) {
		[self schedule:@selector(updateShipLocationsPos)];
	}
	if (fmodf(tMult, 100) == 0) {
		[self unschedule:@selector(updateShipLocationsPos)];
		GenericMenuLayer *parent = (GenericMenuLayer*)self.parent;
		[parent setScrollingShip:false];
	}
}

-(void) updateShipLocationsNeg {
	tMult -= 5;
	[self putAllShipsInPositionWithTMultiple:tMult*0.01f];
	if (fmodf(tMult, 100) != 0) {
		[self schedule:@selector(updateShipLocationsNeg)];
	}
	if (fmodf(tMult, 100) == 0) {
		[self unschedule:@selector(updateShipLocationsNeg)];
		GenericMenuLayer *parent = (GenericMenuLayer*)self.parent;
		[parent setScrollingShip:false];
	}
}

-(int) getSelectedShip {
	int selectedShip = 0;
	for (NSUInteger i=0; i<[shipArray count]; i++) {
		CCSprite *ship = [shipArray objectAtIndex:i];
		if ((floorf(ship.position.x) == 80 && floorf(ship.position.y) == 0) || (ceilf(ship.position.x) == 80 && floorf(ship.position.y == 0))) {
			selectedShip = (int)i+1;
			break;
		}
	}
	
	return selectedShip;
}

@end
