//
//  ChallengeDifGameLayer.m
//  HappyDifference
//
//  Created by zzyy on 11-12-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ChallengeDifGameLayer.h"
#import "UserData.h"
#import "GameCtl.h"
@implementation ChallengeDifGameLayer
- (void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];

    [super dealloc];
}
-(void)nextLevel
{
    [[GameCtl sharedGameCtl] runChallengeNextLevelScene];
}
-(void) quickUpdateBar
{
    CCProgressTimer* bar = (CCProgressTimer*)[self getChildByTag:tag_pbar];
    bar.percentage--;
    if (bar.percentage <0) {
        [self unschedule:@selector(quickUpdateBar)];
        [self nextLevel];
    }
}
-(void) updateBar
{
    CCProgressTimer* bar = (CCProgressTimer*)[self getChildByTag:tag_pbar];
    m_barPercent = bar.percentage--;
    if(bar.percentage <0)//failed
    {
        bar.percentage = 0;
        [self unschedule:@selector(updateBar)];
        //show  nextLevel
        [self nextLevel];
    }
    else
    {
        if(m_openStarNum == [m_starIcon count])//find 5 dif
        {
            [self unschedule:@selector(updateBar)];
            m_iNewScore = m_iNewScore+m_barPercent*10;
            [self schedule:@selector(updateScore) interval:0.000001];
            [self schedule:@selector(quickUpdateBar) interval:0.05];
        }
    }
}
-(void) updateScore
{
    CCLabelBMFont* label = (CCLabelBMFont*)[self getChildByTag:tag_score];
    if(m_iNewScore == m_iOldScore)
    {
        [self unschedule:@selector(updateScore)];
        return;
    }
    m_iOldScore++;
    [label setString:[[NSNumber numberWithInt:m_iOldScore] stringValue]];
}
-(void) setSocre
{
    m_iNewScore = m_iNewScore +10;
    [self schedule:@selector(updateScore) interval:0.000001];
}
-(void) drawScore
{
    //read userdata
    m_iOldScore = 0;
    m_iNewScore = m_iOldScore;
    
    CCLabelBMFont *label = [CCLabelBMFont labelWithString:[[NSNumber numberWithInt:m_iNewScore] stringValue] fntFile:@"about_color.fnt"];
    [self addChild:label z:1 tag:tag_score];
    [label setPosition:ccp(521, 710)];
    [self schedule:@selector(updateScore) interval:0.000001];
}
-(id) initWithStage:(int)iStage andLevel:(int) iLevel
{
    if((self = [super initWithStage:iStage andLevel:iLevel]))
    {
        [self drawAnswersWithRandFlag:YES];

        [self drawScore];
    }
    return self;
}
-(id) initWithReadyGo:(int)iStage andLevel:(int) iLevel
{
    if((self = [super initWithReadyGo:iStage andLevel:iLevel]))
    {
        [self drawAnswersWithRandFlag:YES];
        
        [self drawScore];
    }
    return self;
}
- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event])
    {
        [self setSocre];
    };
}
@end
