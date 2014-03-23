//
//  ScoreDisplayNode.m
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 7/2/13.
//
//

#import "ScoreDisplayNode.h"

@implementation ScoreDisplayNode

@synthesize score = _score;

- (id)initWithScoreImage:(NSString *)scoreImage fontFile:(NSString *)fontFile {

	if ((self = [super init])) {
		self.scoreStringFormat = @"%d";
		scoreLabel = [CCLabelBMFont labelWithString:@"Score: 0 points" fntFile:fontFile];
		[self addChild:scoreLabel];
		
		if (scoreImage)
		{
			CCSprite *scoreIcon = [CCSprite spriteWithSpriteFrameName:scoreImage];
			[self addChild:scoreIcon];
			
			// move the score label to the right of the icon
			scoreLabel.position = ccp(scoreLabel.position.x + scoreIcon.contentSize.width, scoreLabel.position.y);
			//scoreIcon.position = ccp(scoreIcon.position.x, scoreIcon.contentSize.height);
		}
		[self setContentSize:scoreLabel.contentSize];
	}

return self;
}

- (void)setScore:(int)score
{
	
	_score= score;
	scoreLabel.string = [NSString stringWithFormat:@"Score: %@", [NSString stringWithFormat:_scoreStringFormat, _score]];
}

@end
