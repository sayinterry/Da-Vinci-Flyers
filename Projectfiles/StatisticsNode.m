//
//  CCNode.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/14/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "StatisticsNode.h"

#define STATISTICS_PANEL_MARGIN_LEFT 20

@implementation StatisticsNode

-(id)initWithTitle:(NSString *)t highScoreStrings:(NSArray *)h
{
    self = [super init];
    
    if (self)
    {
        highScoreStrings = h;
		title = t;
    }
    
    return self;
}

#pragma mark - Node Lifecyle

- (void)onExit
{
    [super onExit];
    
    [self removeAllChildren];
    titleLabel = nil;
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    /* title label */
    CCLabelTTF *titleLabelTemp = [CCLabelTTF labelWithString:title
                                                       fontName:@"arial"
                                                       fontSize:28];
    titleLabelTemp.color = ccBLACK;
    titleLabelTemp.position = ccp(titleLabelTemp.contentSize.width*0.5f, self.contentSize.height);
    titleLabelTemp.size = CGSizeMake(self.contentSize.width, titleLabelTemp.size.height);
    titleLabel = titleLabelTemp;

    [self addChild:titleLabel];
    
    int yPosition = self.contentSize.height - (titleLabel.contentSize.height);
    
    for (NSString *highScoreString in highScoreStrings) {
        CCLabelTTF *highScoreLabel = [CCLabelTTF labelWithString:highScoreString
                                                        fontName:@"arial"
                                                        fontSize:20];
        highScoreLabel.color = ccBLACK;
        highScoreLabel.position = ccp(highScoreLabel.contentSize.width*0.5f, yPosition);
        [self addChild:highScoreLabel];
        yPosition -= (5 + highScoreLabel.contentSize.height);
    }
}
@end
