//
//  HealthDisplayNode.h
//  _MGWU-Empty-Game-Landscape-Template_
//
//  Created by Interns on 6/28/13.
//
//

#import "CCNode.h"

@interface HealthDisplayNode : CCNode
{
    NSString *healthImage;
    NSString *lostHealthImage;
    int maxHealth;
    NSMutableArray *healthSprites;
}

- (id)initWithHealthImage:(NSString*)healthImage maxHealth:(int)maxHealth;
-(void) resetHealthWithImage:(NSString*)img;

@property (nonatomic, assign) int health;

@end