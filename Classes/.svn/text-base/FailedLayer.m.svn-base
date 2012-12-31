//
//  FailedLayer.m
//  HappyDifference
//
//  Created by zzyy on 11-12-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FailedLayer.h"


@implementation FailedLayer
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
    }
    return self;
}
@end
