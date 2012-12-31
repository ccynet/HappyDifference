//
//  SplashLayer.m
//  Chuzzle-iphone
//
//  Created by zzyy on 11-3-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "SplashLayer.h"



@implementation SplashLayer
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		[self fadeStart];
	}
	return self;
}

- (void) fadeStart
{
	CGSize	winSize = [[CCDirector sharedDirector] winSize];
    NSArray* photoAry  = [NSArray arrayWithObjects:@"1.png",@"2.png",@"3.png",@"4.png",@"5.png", nil];
	m_splashImages = [[NSMutableArray alloc] init];
	for (int iCount =0; iCount < [photoAry count]; iCount++) {
		CCSprite* splashImage = [CCSprite spriteWithFile:[photoAry objectAtIndex:iCount]];
		[splashImage setPosition:ccp(winSize.width/2,winSize.height/2)];
		[self addChild:splashImage];
		if (iCount !=0) {
			[splashImage setOpacity:0];
		}
		[m_splashImages addObject:splashImage];
	}
	[self fadeAndShow];
}

- (void) fadeAndShow
{
	if ([m_splashImages count] ==0) {
		
		[self fadeStart];
		return;
	}
	if([m_splashImages count] ==1){
		CCSprite* icurrent = (CCSprite*)[m_splashImages objectAtIndex:0];
		[m_splashImages removeObjectAtIndex:0];
		[icurrent runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2],
							 [CCFadeOut actionWithDuration:1],
							 [CCCallFuncN actionWithTarget:self selector:@selector(remove:)],
							 [CCCallFunc actionWithTarget:self selector:@selector(cFadeAndShow)],nil]];

		
	 }
	 else{
		 CCSprite* icurrent = (CCSprite*)[m_splashImages objectAtIndex:0];
		 [m_splashImages removeObjectAtIndex:0];
		 CCSprite* next =  (CCSprite*)[m_splashImages objectAtIndex:0];
		 [icurrent runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2],//显示2s时间
							[CCFadeOut actionWithDuration:1],
							[CCCallFuncN actionWithTarget:self selector:@selector(remove:)],nil]];
		 [next runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2],
						  [CCFadeIn actionWithDuration:1],
						  //[CCDelayTime actionWithDuration:2],//显示2s时间
						  [CCCallFunc actionWithTarget:self selector:@selector(cFadeAndShow)],nil]];
	 }
}

- (void) cFadeAndShow
{
	[self fadeAndShow];
}

- (void)remove:(CCSprite*)s
{
	[s.parent removeChild:s cleanup:YES];
	[self removeChild:s cleanup:YES];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[m_splashImages release];
	m_splashImages = NULL;
    [self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}
@end
