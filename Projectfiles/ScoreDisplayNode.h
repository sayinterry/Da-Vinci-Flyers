//
//  ScoreDisplayNode.h
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 7/2/13.
//
//

#import "CCNode.h"

@interface ScoreDisplayNode : CCNode
{
    CCLabelBMFont *scoreLabel;
}

- (id)initWithScoreImage:(NSString *)scoreImage fontFile:(NSString *)fontFile;

@property (nonatomic, assign) int score;
@property (nonatomic, strong) NSString *scoreStringFormat;

@end
