//
//  HealthDisplayNode.h
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 6/28/13.
//
//

#import "CCNode.h"

@interface BombDisplayNode : CCNode
{
    NSString *bombImage;
    int maxBombs;
    NSMutableArray *bombSprites;
}

- (id)initWithBombImage:(NSString*)bombImg maxBombs:(int)mBombs;

@property (nonatomic, assign) int bombs;

@end