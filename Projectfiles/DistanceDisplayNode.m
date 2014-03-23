//
//  DistanceDisplayNode.m
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 7/2/13.
//
//

#import "DistanceDisplayNode.h"
#import "GameLayer.h"
#import "PlayerEntity.h"

@implementation DistanceDisplayNode

@synthesize distanceStringFormat;

- (id)initWithFontFile:(NSString *)fntFile
{
	if ((self = [super init])){
		self.distanceStringFormat = @"%d";
		distanceTraveledLabel = [CCLabelBMFont labelWithString:@"Distance: 0 m" fntFile:fntFile];
		[self setContentSize:distanceTraveledLabel.contentSize];
		[self addChild:distanceTraveledLabel];
	}
	return self;
}

-(void) updateDistance:(float)distance
{
	int distanceTraveled = floorf(distance);
	distanceTraveledLabel.string = [NSString stringWithFormat:self.distanceStringFormat, distanceTraveled];

}

@end
