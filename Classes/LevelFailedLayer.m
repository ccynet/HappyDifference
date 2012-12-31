//
//  LevelFailedLayer.m
//  HappyDifference
//
//  Created by zzyy on 11-11-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LevelFailedLayer.h"
#import "GameCtl.h"
#import "ClassicDifGameLayer.h"
#import "HappyDifferenceAppDelegate.h"
#import "SimpleAudioEngine.h"



@implementation LevelFailedLayer
-(id) initWithLayer:(ClassicDifGameLayer*) layer;
{
    if((self = [super initWithColor:ccc4(51,51,51,128)]))
    {
        [layer retain];
        m_layer = layer;
        
        //bk
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite*  passStage = [[[CCSprite alloc]initWithFile:@"passlevel.png"]autorelease];
        [passStage setPosition:CGPointMake(winSize.width/2, 350)];
        [self addChild:passStage];
        
        //button
        CCMenuItemImage*    listItemImage = [CCMenuItemImage itemFromNormalImage:@"list.png" 
                                                                   selectedImage:@"list.png" 
                                                                   disabledImage:@"" target:self selector:@selector(ToList)];
        
        CCMenuItemImage*    replayItemImage = [CCMenuItemImage itemFromNormalImage:@"replay.png" 
                                                                     selectedImage:@"replay.png" 
                                                                     disabledImage:@"" target:self selector:@selector(ToReplay)];
        CCMenu*     selectMenu = [CCMenu menuWithItems:listItemImage,replayItemImage, nil];
        [self addChild:selectMenu];
        [selectMenu setPosition:ccp(0, 0)];

        [listItemImage setPosition:ccp(332, 347)];
        [replayItemImage setPosition:ccp(528, 347)];
        
        //pasue
        [m_layer pause];

    }
    return  self;
}
-(void) ToList
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    [HappyDifferenceAppDelegate get].paused = NO;
    
    int stage = m_layer.m_iCurStage;
    [[GameCtl sharedGameCtl] runSelectLevelScene:stage];
}
-(void) ToReplay
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];
    
    [HappyDifferenceAppDelegate get].paused = NO;

    int stage = m_layer.m_iCurStage;
    int level = m_layer.m_iCurLevel;
    [[GameCtl sharedGameCtl] runClassicDifGameSceneWithStage:stage andLevel:level];
    
}

-(void) dealloc
{
    
    [m_layer release];
    [self removeAllChildrenWithCleanup:YES];

    [super dealloc];
}
@end
