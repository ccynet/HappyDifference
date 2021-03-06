//
//  AboutLayer.m
//  HappyDifference
//
//  Created by easystudio on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutLayer.h"
#import "GameCtl.h"
#import "SimpleAudioEngine.h"

@implementation AboutLayer

-(id) init
{
	if ((self = [super init])) {
		m_cgpoint = CGPointMake(0, 0);
	
		CCLayerColor* pclrLayer = [CCColorLayer node];
		[pclrLayer setOpacity:(255,255,255)];
		[self addChild:pclrLayer z:0];
		
		//screen's Size.
		CGSize	winSize = [[CCDirector sharedDirector] winSize];	
		
		CCSprite* pSprite = [CCSprite spriteWithFile:@"AboutBg.png"];
		[self addChild:pSprite];
		[pSprite setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
			
		
		m_labelAbout = [CCLabelBMFont labelWithString:@" Happy Find \n \
															\n \n  \
														Excutive Producer: \n \
															\n \n  \
														Lead Designer: \n \
															\n \n  \
														Designer: \n \
															\n \n \n \
														Programmers: \n \
															\n \n  \n \
														Artists: \n \
															\n \n" fntFile:@"about_color.fnt"];
		
		m_labelAbout2 = [CCLabelBMFont labelWithString:@"  V1.0 \n \
															\n\n \
														 zhangyu \n \
															\n\n \
														 hujunqiang \n \
															\n\n  \
														 hujunqiang  \n  zhangnan \n  \
															\n\n \
														 zhangyu \n  zhangnan \n \
															\n\n \
														 bigbear \n  yoyo" fntFile:@"about.fnt"];
		
		//m_labelAbout.color = ccBLUE;
		
		//title
		title = [CCSprite spriteWithFile:@"title.png"];
        [self addChild:title z:1];
        [title setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
		[title retain];
		
		//label
		m_labelAbout.position = ccp(winSize.width/2,-100);
		[self addChild:m_labelAbout]; 
		
		m_labelAbout2.position = ccp(winSize.width/2,-125);
		[self addChild:m_labelAbout2];
	
        //back
        CCMenuItemImage*    backItemImage = [CCMenuItemImage itemFromNormalImage:@"back_n.png" 
                                                                   selectedImage:@"back_n.png" 
                                                                   disabledImage:@"" target:self selector:@selector(backToMenu)];
        CCMenu*     selectMenu = [CCMenu menuWithItems:backItemImage, nil];
        [backItemImage setAnchorPoint:ccp(0, 0)];
        [backItemImage setPosition:ccp(-winSize.width/2, -winSize.height/2)];
        [self addChild:selectMenu];
		
		[self scheduleUpdate];

	}
	
	return self;
}

-(void) backToMenu//:(CCMenuItemImage*) btn
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];
	
	[self unschedule:@selector(update)];

    [[GameCtl sharedGameCtl] backMainMenuScene];
}
-(void) update:(ccTime)delta
{
	//screen's Size.
	CGSize	winSize = [[CCDirector sharedDirector] winSize];
	
	//title change
	title.position = ccp(winSize.width/2,title.position.y+30*delta);
	
	//label change
	m_labelAbout.position = ccp(winSize.width/2,m_labelAbout.position.y+30*delta);
	m_labelAbout2.position = ccp(winSize.width/2,m_labelAbout2.position.y+30*delta);
	if ((m_labelAbout.position.y + 30*delta) >= 1100) {
		m_labelAbout.position = ccp(winSize.width/2,-500);
		m_labelAbout2.position = ccp(winSize.width/2,-525);
		title.position = ccp(winSize.width/2, -50);
	}
	else if ((m_labelAbout.position.y - 30*delta) < -600 ) 
	{
		m_labelAbout.position = ccp(winSize.width/2,874);
		m_labelAbout2.position = ccp(winSize.width/2,860);
		title.position = ccp(winSize.width/2, 1374);
	}

}

-(void) dealloc
{
    [title release]; 
	[self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

//touch start
- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}
- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}
- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	m_cgpoint = [[CCDirector sharedDirector] convertToGL:location];
	
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGSize	winSize = [CCDirector sharedDirector].winSize;
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	
	m_detlaY = location.y - m_cgpoint.y;

	m_labelAbout.position = ccp(winSize.width/2,m_labelAbout.position.y + m_detlaY);
	m_labelAbout2.position = ccp(winSize.width/2,m_labelAbout2.position.y + m_detlaY); 
	title.position = ccp(winSize.width/2, title.position.y + m_detlaY);
    
    m_cgpoint = location;
	
	return YES;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end
