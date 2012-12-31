//
//  ClassicDifGameLayer.m
//  HappyDifference
//
//  Created by zzyy on 11-10-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "ClassicDifGameLayer.h"

#import "UserData.h"
#import "LevelPassLayer.h"
#import "StageCompletedLayer.h"
#import "PauseLayer.h"
#import "LevelFailedLayer.h"
#import "HappyDifferenceAppDelegate.h"

#import "GameCtl.h"
#import "SimpleAudioEngine.h"


@implementation ClassicDifGameLayer


-(void)nextLevel
{
    NSNumber* score;
    CCProgressTimer* bar = (CCProgressTimer*)[self getChildByTag:tag_pbar];
    if(bar.percentage >70)
    {
        score = [NSNumber numberWithInt:3];
    }
    else if(bar.percentage>50)
    {
        score = [NSNumber numberWithInt:2];
        
    }
    else
    {
        score = [NSNumber numberWithInt:1];
        
    }
    //save score
    NSMutableArray* stageAry = [[UserData sharedUserData].m_passScoreAry objectAtIndex:m_iCurStage];
    [stageAry replaceObjectAtIndex:m_iCurLevel withObject:score];
    
    if((m_iCurLevel +1) >= m_itotalLevel)
    {
        //next stage
        int stage = (m_iCurStage+1);
        int level = 0;
        [[GameCtl sharedGameCtl] runClassicDifGameSceneWithStage:stage andLevel:level];
    }
    else
    {
        //next level
        int stage = m_iCurStage;
        int level = m_iCurLevel+1;
        [[GameCtl sharedGameCtl] runClassicDifGameSceneWithStage:stage andLevel:level];
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
        //show failed level
        [self showLevelFailedLayer];
    }
    else
    {
        if(m_openStarNum == [m_starIcon count])
        {
            [self unschedule:@selector(updateBar)];
            //show pass level
            [self nextLevel];
        }
    }
}

- (void) drawPauseBtn
{
    //pause button
    CCMenuItemImage*    pauseImage = [CCMenuItemImage itemFromNormalImage:@"pause.png" 
                                                            selectedImage:@"pause.png" 
                                                            disabledImage:@"" target:self selector:@selector(ToPauseLayer)];
    CCMenu*     selectMenu = [CCMenu menuWithItems:pauseImage, nil];
    [selectMenu setPosition:ccp(0, 0)];
    
    [pauseImage setPosition:ccp(30, 30)];
    [self addChild:selectMenu];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [self removeAllChildrenWithCleanup:YES];
    [self unschedule:@selector(updateBar)];

    [super dealloc];
}
// on "init" you need to initialize your instance
-(id) initWithStage:(int)iStage andLevel:(int) iLevel
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithStage:iStage andLevel:iLevel] )) {
        
        [self drawAnswersWithRandFlag:YES];
        [self drawPauseBtn];
        
	}
	return self;
}
-(id) initWithReadyGo:(int) iCurStage andLevel:(int) iLevel
{
    if( (self=[super initWithReadyGo:iCurStage andLevel:iLevel] )) {
        
        [self drawAnswersWithRandFlag:YES];
        [self drawPauseBtn];
        
	}
	return self;
}
-(void) ToPauseLayer
{

    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    m_pauseLayer = [[[PauseLayer alloc]initWithLayer:self]autorelease];
    
    [self.parent addChild:m_pauseLayer z:2];
}
-(void) pause
{
    if (![HappyDifferenceAppDelegate get].paused) {
		[HappyDifferenceAppDelegate get].paused = YES;
		[super onExit];
	}
}
-(void) resume
{
	if (![HappyDifferenceAppDelegate get].paused) {
		return ;
	}
	
    [self.parent removeChild:m_pauseLayer cleanup:YES];
    
	[HappyDifferenceAppDelegate get].paused = NO;
	[super onEnter];
}

-(void) showLevelFailedLayer
{
    LevelFailedLayer*   levelFailedLayer;
    levelFailedLayer = [[[LevelFailedLayer alloc]initWithLayer:self]autorelease];
    
    [self.parent addChild:levelFailedLayer z:2];
}
-(void) showLevelPassLayer
{
    LevelPassLayer* levelPassLayer;
    levelPassLayer =[[[LevelPassLayer alloc]initWithLayer:self]autorelease];
    
    [self.parent addChild:levelPassLayer z:2];
}
-(void) showStageCompletedLayer
{
    StageCompletedLayer*    stageCompletedLayer;
    stageCompletedLayer =[[[StageCompletedLayer alloc]initWithLayer:self]autorelease];
    
    [self.parent addChild:stageCompletedLayer z:2];
}

@end
