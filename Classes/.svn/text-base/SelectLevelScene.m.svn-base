//
//  SelectLevelScene.m
//  HappyDifference
//
//  Created by zzyy on 11-12-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SelectLevelScene.h"
#import "SelectLevelLayer.h"

@implementation SelectLevelScene
-(id) initWithStage:(int) iCurStage
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        
        // 'layer' is an autorelease object.
        SelectLevelLayer *layer = [[[SelectLevelLayer alloc]initWithStage:iCurStage]autorelease];
		
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
