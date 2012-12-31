//
//  PauseLayer.m
//  HappyDifference
//
//  Created by zzyy on 11-11-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PauseLayer.h"
#import "GameCtl.h"
#import "ClassicDifGameLayer.h"
#import "HappyDifferenceAppDelegate.h"
#import "SimpleAudioEngine.h"
#import "UserData.h"



@implementation PauseLayer

-(void) drawBtn
{
    //sound
    m_soundOpen = [CCMenuItemImage itemFromNormalImage:@"open.png" selectedImage:@"open.png"];
    m_soundOff = [CCMenuItemImage itemFromNormalImage:@"shut.png" selectedImage:@"shut.png"];
    CCMenuItemToggle*   soundToggle;
    if([UserData sharedUserData].m_isSound)
    {
        soundToggle = [CCMenuItemToggle itemWithTarget:self 
                                              selector:@selector(onSoundButton:) 
                                                 items:m_soundOpen,m_soundOff, nil];
    }
    else
    {
        soundToggle = [CCMenuItemToggle itemWithTarget:self 
                                              selector:@selector(onSoundButton:) 
                                                 items:m_soundOff,m_soundOpen, nil];
    }
    [soundToggle setPosition:ccp(47, 722)];
    CCMenu*     soundMenu = [CCMenu menuWithItems:soundToggle, nil];
    [self addChild:soundMenu];
    [soundMenu setPosition:ccp(0, 0)];
}
-(void) onSoundButton:(id) sender
{
    CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    if (toggleItem.selectedItem == m_soundOpen) {
        
        [[GameCtl sharedGameCtl]openBkMusic];
        
    } else if (toggleItem.selectedItem == m_soundOff) {
        
        [[GameCtl sharedGameCtl]closeBkMusic];
        
    }
}
-(id) initWithLayer:(ClassicDifGameLayer*) layer
{
    if((self = [super initWithColor:ccc4(51,51,51,128)]))
    {
        
        [layer retain];
        m_layer = layer;
        
        //bk
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite*  pausebk = [[[CCSprite alloc]initWithFile:@"passlevel.png"]autorelease];
        [pausebk setPosition:CGPointMake(winSize.width/2, 350)];
        [self addChild:pausebk];
        
        //button
        CCMenuItemImage*    listItemImage = [CCMenuItemImage itemFromNormalImage:@"list.png" 
                                                                   selectedImage:@"list.png" 
                                                                   disabledImage:@"" target:self selector:@selector(ToList)];
        
        CCMenuItemImage*    goItemImage = [CCMenuItemImage itemFromNormalImage:@"go.png" 
                                                                selectedImage:@"go.png" 
                                                                 disabledImage:@"" target:self selector:@selector(ToGo)];
        
        CCMenuItemImage*    replayItemImage = [CCMenuItemImage itemFromNormalImage:@"replay.png" 
                                                                     selectedImage:@"replay.png" 
                                                                     disabledImage:@"" target:self selector:@selector(ToReplay)];
        CCMenu*     selectMenu = [CCMenu menuWithItems:listItemImage, goItemImage, replayItemImage, nil];
        [self addChild:selectMenu];
        [selectMenu setPosition:ccp(0, 0)];
        
        [listItemImage setPosition:ccp(332, 347)];
        [replayItemImage setPosition:ccp(528, 347)];
        [goItemImage setPosition:ccp(737, 347)];
        
        [m_layer pause];
    }
    return  self;
}
-(void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    [m_layer release];
    [super dealloc];
}
-(void) ToGo
{
    [m_layer resume];
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];
}
-(void) ToList
{

    [HappyDifferenceAppDelegate get].paused = NO;
    
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    int stage = m_layer.m_iCurStage;
    [[GameCtl sharedGameCtl] runSelectLevelScene:stage];
}

-(void) ToReplay
{

    [HappyDifferenceAppDelegate get].paused = NO;
    
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    int stage = m_layer.m_iCurStage;
    int level = m_layer.m_iCurLevel;
    [[GameCtl sharedGameCtl] runClassicDifGameSceneWithStage:stage andLevel:level];
}
@end
