//
//  AboutScene.m
//  HappyDifference
//
//  Created by easystudio on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutScene.h"
#import "AboutLayer.h"

@implementation AboutScene
+(id) scene
{
	CCScene* scene = [AboutScene node]; 
	
	return scene;
}

-(id) init
{
	if ((self = [super init])) {

		AboutLayer* pAboutlayer = [AboutLayer node]; 
		[self addChild:pAboutlayer];
	}
	
	return self;
}

-(void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];

	[super dealloc];
}
@end
