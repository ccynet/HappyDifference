//
//  SelectStageWithMovingLayer.m
//  HappyDifference
//
//  Created by zzyy on 12-1-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelectStageWithMovingLayer.h"
#import "UserData.h"
#import "SimpleAudioEngine.h"
#import "GameCtl.h"

@implementation SelectStageWithMovingLayer
-(id)init
{
    if((self = [super init]))
    {
        self.isTouchEnabled = YES;
        
        CGSize	screenSize = [CCDirector sharedDirector].winSize;
        CCSprite*    stageBk = [CCSprite spriteWithFile:@"Stagebg.png"];
        [self addChild:stageBk z:-1 tag:stageBk_tag]; 
        [stageBk setAnchorPoint:ccp(0, 0.5)];
        [stageBk setPosition:ccp(0, screenSize.height/2)];
        //menu
        NSArray*  stageLockedNameAry = [[[NSArray alloc]initWithObjects:@"stage_1_locked.png",@"stage_2_locked.png",@"stage_3_locked.png",@"stage_4_locked.png",@"stage_5_locked.png",nil]autorelease];
        NSArray*  stageNameAry = [[[NSArray alloc]initWithObjects:@"stage_1.png",@"stage_2.png",@"stage_3.png",
                                   @"stage_4.png",@"stage_5.png",nil]autorelease];
        CGPoint stagePositonAry[6] ={ccp(560, 490),ccp(850, 400),ccp(290, 530),ccp(870, 640),
            ccp(190, 650),ccp(765, 530)};
        
        for(int iCnt =0; iCnt <[stageNameAry count]; iCnt++)
        {
            CCMenuItemImage* stageItemImage;
            int d = [[UserData sharedUserData] m_iPassStageNo];
            if(iCnt <= [[UserData sharedUserData] m_iPassStageNo])
            {
                stageItemImage = [CCMenuItemImage itemFromNormalImage:[stageNameAry objectAtIndex:iCnt] 
                                                        selectedImage:[stageNameAry objectAtIndex:iCnt]  
                                                        disabledImage:@"" 
                                                               target:self 
                                                             selector:@selector(selectStage:)];
            }
            else
            {
                stageItemImage = [CCMenuItemImage itemFromNormalImage:[stageLockedNameAry objectAtIndex:iCnt] 
                                                        selectedImage:[stageLockedNameAry objectAtIndex:iCnt]  
                                                        disabledImage:@"" 
                                                               target:self 
                                                             selector:@selector(selectStage:)];
            }
            [stageItemImage setTag:iCnt];
            CCMenu* menu = [CCMenu menuWithItems:stageItemImage, nil];
            [stageItemImage setPosition:stagePositonAry[iCnt]];
            [stageBk addChild:menu];
            [menu setPosition:ccp(0, 0)];
        }
    }
    return self;
}
-(void) dealloc
{
    [super dealloc];
}
-(void) selectStage:(CCMenuItemImage*) btn
{
    if([btn tag] <= [[UserData sharedUserData] m_iPassStageNo])
    {

            [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];
            
            [[GameCtl sharedGameCtl] runClassicDifGameSceneWithReadyGo:[btn tag] andLevel:0];
    }
}
-(CGPoint) locationFromTouch:(UITouch*)touch 
{
    CGPoint touchLocation = [touch locationInView: [touch view]]; 
    return [[CCDirector sharedDirector] convertToGL:touchLocation];
}
-(CGPoint) locationFromTouches:(NSSet*)touches 
{
    return [self locationFromTouch:[touches anyObject]];
}
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    // 由触摸位置信息获取相应瓷砖的坐标
    CGPoint touchLocation = [self locationFromTouches:touches]; 
	m_touchBeganPoint = touchLocation;

}
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCNode* node = [self getChildByTag:stageBk_tag]; 
    CCSprite* stageBk = (CCSprite*)node;
    
    CGSize	screenSize = [CCDirector sharedDirector].winSize;
	
	CGPoint location = [self locationFromTouches:touches]; 
	
	int _detlaX = location.x - m_touchBeganPoint.x;
    int _detlaY = location.y - m_touchBeganPoint.y;

    CGPoint scrollPosition;
    scrollPosition.x = stageBk.position.x+_detlaX;
    scrollPosition.y = stageBk.position.y+_detlaY;
    // 确保地图边界和屏幕边界对齐时让地图的移动停止
    scrollPosition.x = MIN(scrollPosition.x, 0);
    scrollPosition.x = MAX(scrollPosition.x, -(stageBk.textureRect.size.width-screenSize.width)); 
    scrollPosition.y = MIN(scrollPosition.y, screenSize.height/2+(stageBk.textureRect.size.height-screenSize.height)/2); 
    scrollPosition.y = MAX(scrollPosition.y, screenSize.height/2-(stageBk.textureRect.size.height-screenSize.height)/2);
    
    
	stageBk.position = ccp(scrollPosition.x, scrollPosition.y);
    
    m_touchBeganPoint = location;
}
@end
