//
//  StageCompletedLayer.m
//  HappyDifference
//
//  Created by zzyy on 11-11-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StageCompletedLayer.h"
#import "ClassicDifGameLayer.h"
#import "GameCtl.h"
#import "UserData.h"
#import "HappyDifferenceAppDelegate.h"
#import "SimpleAudioEngine.h"


@implementation StageCompletedLayer
-(void) drawStarResult
{
    //star,include On & Off
#define BIG_STAR @"bigstar.png"
#define BIG_STAR_GRAY @"bigstargray.png"
    CCSpriteBatchNode* starOnbatchNode = [CCSpriteBatchNode batchNodeWithFile:BIG_STAR];
    CCSpriteBatchNode* starOffbatchNode = [CCSpriteBatchNode batchNodeWithFile:BIG_STAR_GRAY];
    [self addChild:starOnbatchNode];
    [self addChild:starOffbatchNode];
    
    for(int iCnt =0; iCnt < 1; iCnt++)
    {
        //buttom star
        NSNumber* nsstarnum = [[[UserData sharedUserData].m_passScoreAry objectAtIndex:m_layer.m_iCurStage]objectAtIndex:m_layer.m_iCurLevel];
        CCSprite* pStar1;
        CCSprite* pStar2;
        CCSprite* pStar3;
        switch ([nsstarnum intValue]) 
        {
            case 0:
            {
                pStar1 = [CCSprite spriteWithFile:BIG_STAR];
                pStar2 = [CCSprite spriteWithFile:BIG_STAR];
                pStar3 = [CCSprite spriteWithFile:BIG_STAR];
                int width = pStar1.textureRect.size.width;
                int heigth = pStar1.textureRect.size.height;
                [starOnbatchNode addChild:pStar1];
                [starOnbatchNode addChild:pStar2];
                [starOnbatchNode addChild:pStar3];
                
            }
                break;
            case 1:
            {
                pStar1 = [CCSprite spriteWithFile:BIG_STAR];
                pStar2 = [CCSprite spriteWithFile:BIG_STAR_GRAY];
                pStar3 = [CCSprite spriteWithFile:BIG_STAR_GRAY];
                int width = pStar1.textureRect.size.width;
                int heigth = pStar1.textureRect.size.height;
                [starOnbatchNode addChild:pStar1];
                [starOffbatchNode addChild:pStar2];
                [starOffbatchNode addChild:pStar3];
            }
                break;
            case 2:
            {
                pStar1 = [CCSprite spriteWithFile:BIG_STAR];
                pStar2 = [CCSprite spriteWithFile:BIG_STAR];
                pStar3 = [CCSprite spriteWithFile:BIG_STAR_GRAY];
                int width = pStar1.textureRect.size.width;
                int heigth = pStar1.textureRect.size.height;
                [starOnbatchNode addChild:pStar1];
                [starOnbatchNode addChild:pStar2];
                [starOffbatchNode addChild:pStar3];
            }
                break;
            case 3:
            {
                pStar1 = [CCSprite spriteWithFile:BIG_STAR];
                pStar2 = [CCSprite spriteWithFile:BIG_STAR];
                pStar3 = [CCSprite spriteWithFile:BIG_STAR];
                int width = pStar1.textureRect.size.width;
                int heigth = pStar1.textureRect.size.height;
                [starOnbatchNode addChild:pStar1];
                [starOnbatchNode addChild:pStar2];
                [starOnbatchNode addChild:pStar3];
            }
                break;
            default:					
                break;
        }
        [pStar1 setPosition:ccp(230, 340)];
        [pStar2 setPosition:ccp(314, 340)];
        [pStar3 setPosition:ccp(398, 340)];
    }

}
-(id) initWithLayer:(ClassicDifGameLayer*) layer
{
    if((self = [super initWithColor:ccc4(51,51,51,128)]))
    {

        [layer retain];
        m_layer = layer;
		
		
        //update user passstage new data
        if(m_layer.m_iCurStage == [UserData sharedUserData].m_iPassStageNo)
        {
            [UserData sharedUserData].m_iPassStageNo = m_layer.m_iCurStage+1;
            [UserData sharedUserData].m_iPassLevel =0;
        }

        //bk
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite*  passStage = [[[CCSprite alloc]initWithFile:@"passstage.png"]autorelease];
        [passStage setPosition:CGPointMake(winSize.width/2, 350)];
        [self addChild:passStage];
        
        //button
        CCMenuItemImage*    listItemImage = [CCMenuItemImage itemFromNormalImage:@"list.png" 
                                                                   selectedImage:@"list.png" 
                                                                   disabledImage:@"" target:self selector:@selector(ToList)];
        
        CCMenuItemImage*    goItemImage = [CCMenuItemImage itemFromNormalImage:@"next.png" 
                                                                 selectedImage:@"next.png" 
                                                                 disabledImage:@"" target:self selector:@selector(ToNextStage)];
        
        CCMenuItemImage*    replayItemImage = [CCMenuItemImage itemFromNormalImage:@"replay.png" 
                                                                     selectedImage:@"replay.png" 
                                                                     disabledImage:@"" target:self selector:@selector(ToReplay)];
        CCMenu*     selectMenu = [CCMenu menuWithItems:listItemImage, goItemImage, replayItemImage, nil];
        [self addChild:selectMenu];
        [selectMenu setPosition:ccp(0, 0)];
        
        [listItemImage setPosition:ccp(522, 340)];
        [goItemImage setPosition:ccp(665, 340)];
        [replayItemImage setPosition:ccp(802, 340)];
		
        [self drawStarResult];
        
        [m_layer pause];
    }
    return self;
}

-(void) dealloc
{
    
    [m_layer release];
    [self removeAllChildrenWithCleanup:YES];

    [super dealloc];
}
-(void) ToList
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];
    
    [HappyDifferenceAppDelegate get].paused = NO;

    int stage = m_layer.m_iCurStage;
    
    [[GameCtl sharedGameCtl] runSelectLevelScene:stage];
}
-(void) ToNextStage
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    [HappyDifferenceAppDelegate get].paused = NO;

    int stage = (m_layer.m_iCurStage+1);
    int level = 0;
    [[GameCtl sharedGameCtl] runClassicDifGameSceneWithStage:stage andLevel:level];
}
-(void) ToReplay
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    [HappyDifferenceAppDelegate get].paused = NO;

    int stage = m_layer.m_iCurStage;
    int level = m_layer.m_iCurLevel;
    [[GameCtl sharedGameCtl] runClassicDifGameSceneWithStage:stage andLevel:level];
}

@end
