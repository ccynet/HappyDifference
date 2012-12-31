//
//  SuccessLayer.m
//  HappyDifference
//
//  Created by zzyy on 11-12-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StartSuccessLayer.h"
#import "GameCtl.h"

@implementation StartSuccessLayer

-(void)dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}
-(id)init
{
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite* bk = [CCSprite spriteWithFile:@"AboutBg.png"];
        [self addChild:bk];
        [bk setPosition:ccp(winSize.width/2, winSize.height/2)];
        
        //level
        NSString* levelStr = @"Level ";
        int levelNo = [GameCtl sharedGameCtl].m_iCurChallengeLevel;
        NSString* levelNoStr = [NSString stringWithFormat:@"%d",levelNo+1];
        levelStr = [levelStr stringByAppendingString:levelNoStr];
        CCLabelTTF* level = [CCLabelTTF labelWithString:levelStr fontName:@"Verdana-Bold" 
                                               fontSize:80];
        [level setColor:ccc3(0, 255, 0)];
        [self addChild:level];
        [level setPosition:ccp(winSize.width/2, winSize.height/2+100)];
        
        
        
        //play
        CCMenuItemImage* startBtn = [CCMenuItemImage itemFromNormalImage:@"play.png" selectedImage:@"play.png" disabledImage:@"" target:self selector:@selector(startChallenge)];
        [startBtn setPosition:ccp(winSize.width/2, winSize.height/2)];
        
        CCMenu * menu = [CCMenu menuWithItems:startBtn, nil];
        [menu setPosition:ccp(0, 0)];
        [self addChild:menu];
    }
        return self;
}
-(void)startChallenge
{
    [[GameCtl sharedGameCtl]runChallengeNextLevelScene];
}
@end
