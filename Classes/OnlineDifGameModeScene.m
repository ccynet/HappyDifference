//
//  OnlineDifGameModeScene.m
//  HappyDifference
//
//  Created by zzyy on 12-1-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "OnlineDifGameModeScene.h"
#import "OnlineDifGameLayer.h"

@implementation OnlineDifGameModeScene
- (id) init
{
    if((self = [super init]))
    {
        OnlineDifGameLayer* gameLayer = [OnlineDifGameLayer node];
		[self addChild:gameLayer];
    }
    return self;
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}
@end
