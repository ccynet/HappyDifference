//
//  SelectStageScene.m
//  HappyDifference
//
//  Created by zzyy on 11-11-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SelectStageScene.h"
#import "SelectStageWithMovingLayer.h"
@implementation SelectStageScene
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        
        // 'layer' is an autorelease object.
        SelectStageWithMovingLayer *layer = [SelectStageWithMovingLayer node];
		
        // add layer as a child to scene
        [self addChild: layer];
        
	}
	
	return self;
}

-(void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];

	[super dealloc];
}
@end
