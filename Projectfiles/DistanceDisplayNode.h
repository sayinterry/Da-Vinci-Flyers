//
//  DistanceDisplayNode.h
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 7/2/13.
//
//

#import "CCNode.h"

@interface DistanceDisplayNode: CCNode
{
	float totaltime;
	CCLabelBMFont *distanceTraveledLabel;
}

-(id) initWithFontFile:(NSString*)fntFile;

@property (nonatomic, strong) NSString *distanceStringFormat;

-(void) updateDistance:(float) distance;

@end
