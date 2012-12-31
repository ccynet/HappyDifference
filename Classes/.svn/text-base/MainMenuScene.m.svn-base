//
//  MainMenu.m
//  Gameproject
//
//  Created by easystudio on 11/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "MainMenuLayer.h"

@implementation MainMenuScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [MainMenuScene node];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        
        // 'layer' is an autorelease object.
        MainMenuLayer *layer = [MainMenuLayer node];
		
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
