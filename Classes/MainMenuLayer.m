//
//  MainMenuLayer.m
//  Gameproject
//
//  Created by easystudio on 11/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "UserData.h"
#import "AboutScene.h"
#import "SplashLayer.h"
#import "GameCtl.h"
#import "SimpleAudioEngine.h"


@implementation MainMenuLayer

-(void) bkground
{
    CGSize	winSize = [[CCDirector sharedDirector] winSize];
    //Cover top
    CCSprite* bgsprite = [CCSprite spriteWithFile:@"CoverTop.png"];
    [bgsprite setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
    [self addChild:bgsprite];
}
-(void) button
{
    CGSize	winSize = [[CCDirector sharedDirector] winSize];

    //facebook&twitter
    CCMenuItemImage* facebookBtn = [CCMenuItemImage itemFromNormalImage:@"FacebookClick.png" selectedImage:@"FacebookClick.png" disabledImage:@"" target:self selector:@selector(facebook)];
    [facebookBtn setPosition:ccp(915-512, 355-384)];

    CCMenuItemImage* twitterBtn = [CCMenuItemImage itemFromNormalImage:@"TwitterClick.png" selectedImage:@"TwitterClick.png" disabledImage:@"" target:self selector:@selector(twitter)];
    [twitterBtn setPosition:ccp(838-512, 400-384)];
    
    //classic
    CCMenuItemImage* classicBtn = [CCMenuItemImage itemFromNormalImage:@"classic.png" selectedImage:@"classic.png" disabledImage:@"" target:self selector:@selector(classic)];
    [classicBtn setPosition:CGPointMake(860, 300)];
    
    //challenge
    CCMenuItemImage* challengeBtn = [CCMenuItemImage itemFromNormalImage:@"challenge.png" selectedImage:@"challenge.png" disabledImage:@"" target:self selector:@selector(challenge)];
    [challengeBtn setPosition:CGPointMake(860, 300-80)];
    
    //online
    CCMenuItemImage* onlineBtn = [CCMenuItemImage itemFromNormalImage:@"online.png" selectedImage:@"online.png" disabledImage:@"" target:self selector:@selector(online)];
    [onlineBtn setPosition:CGPointMake(860, 300-2*80)];
    
    //help
    CCMenuItemImage* helpBtn = [CCMenuItemImage itemFromNormalImage:@"help.png" selectedImage:@"help.png" disabledImage:@"" target:self selector:@selector(help)];
    [helpBtn setPosition:CGPointMake(860, 300-3*80)];
    
    //ring
    CCMenuItemImage* ringBtn;
    if([UserData sharedUserData].m_isSound)
    {
        ringBtn = [CCMenuItemImage itemFromNormalImage:@"ring.png" selectedImage:@"ringstop.png" disabledImage:@"" target:self selector:@selector(ring:)];
    }
    else
    {
        ringBtn = [CCMenuItemImage itemFromNormalImage:@"ringstop.png" selectedImage:@"ring.png" disabledImage:@"" target:self selector:@selector(ring:)];
    }
    [ringBtn setPosition:ccp(400, 645-384)];//ccp(155-512, 645-384)];
    

    
    
    CCMenu * menu = [CCMenu menuWithItems:facebookBtn, twitterBtn, classicBtn, challengeBtn, onlineBtn, helpBtn, ringBtn, nil];
    [menu setPosition:CGPointMake(0, 0)];
    [self addChild:menu];
}

-(void) flash
{
    //flash animation
    CGSize	winSize = [[CCDirector sharedDirector] winSize];
    CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"Flash.png"];
    [self addChild:batch];
#define flash_num 3
    CGPoint poitAry[flash_num]={ccp(winSize.width*3/4, winSize.height*3/4),ccp(winSize.width*1/4, winSize.height*1/2),
                                ccp(winSize.width*3/4+50, winSize.height*3/4-50),};
    for(int iCnt=0; iCnt < flash_num; iCnt++)
    {
        CCSprite* flash1 = [CCSprite spriteWithFile:@"Flash.png"];
        [batch addChild:flash1];
        [flash1 setPosition:poitAry[iCnt]];
        CCSequence* flash1Seq = [CCSequence actions:[CCFadeOut actionWithDuration:0.3f],[CCFadeIn actionWithDuration:0.3f], nil];
        //        CCSequence* flash1Seq = [CCSequence actions:[CCScaleTo actionWithDuration:0.3f scale:0.1],[CCScaleTo actionWithDuration:0.3f scale:1], nil];
        CCRepeatForever* flashAction = [CCRepeatForever actionWithAction:flash1Seq];
        [flash1 runAction:flashAction];
    }

}
-(void) snow
{
    //CCParticleSystem *tempSystem = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"snow.plist"];
    //read plist to memory
    NSString* rootpath =[[NSBundle mainBundle] pathForResource:@"snowDic" ofType:@"plist"];
    NSDictionary* snowDic = [NSDictionary dictionaryWithContentsOfFile:rootpath];
    CCTexture2D* snowTexture = [[CCTextureCache sharedTextureCache] addImage:@"snow.png"];
    CCParticleSystem *tempSystem = [[ARCH_OPTIMAL_PARTICLE_SYSTEM alloc ]initWithDictionary:snowDic withTexture:snowTexture];
    //tempSystem.positionType=kCCPositionTypeFree;
    tempSystem.positionType=kCCPositionTypeRelative;
    tempSystem.position=ccp(512,768);   
    [self addChild:tempSystem];
    [tempSystem release];
}
-(void)doReatAction1:(CCSprite*) titleWord
{
#define title_x 520
#define title_y 600

	CCMoveTo* actDown = [CCMoveTo actionWithDuration:2 position:ccp(title_x, title_y)];
	CCMoveTo* actUp = [CCMoveTo actionWithDuration:2 position:ccp(title_x, title_y+30)];
	CCRepeatForever	*repeatAction1 = [CCRepeatForever actionWithAction:
									  [CCSequence actions:
									   actUp,actDown,nil
									   ]
									  ];
	[titleWord runAction:repeatAction1];
}
-(void) tilte
{
#define title_x 520
#define title_y 600
    CCSprite* title = [CCSprite spriteWithFile:@"title.png"];
    CCMoveTo* actDown1 =[CCSequence actions: 
                         [CCMoveTo actionWithDuration:0.5 position:ccp(520,600)]
                         ,[CCDelayTime actionWithDuration:0.5]
                         ,[CCCallFuncN actionWithTarget:self selector:@selector(doReatAction1:)],nil
                         ];
    [title runAction:actDown1];
    [self addChild:title];
    [title setPosition:CGPointMake(title_x, title_y)];
}

-(void)doReatActionWm1:(CCSprite*) titleWord
{
	CCMoveTo* actDown = [CCMoveTo actionWithDuration:2 position:ccp([titleWord position].x, [titleWord position].y)];
	CCMoveTo* actUp = [CCMoveTo actionWithDuration:2 position:ccp([titleWord position].x, [titleWord position].y+30)];
	CCRepeatForever	*repeatAction = [CCRepeatForever actionWithAction:
									  [CCSequence actions:
									   actUp,actDown,nil
									   ]
									  ];
	[titleWord runAction:repeatAction];
}
-(void)doReatActionWm2:(CCSprite*) titleWord
{
	CCMoveTo* actDown = [CCMoveTo actionWithDuration:2 position:ccp([titleWord position].x, [titleWord position].y)];
	CCMoveTo* actUp = [CCMoveTo actionWithDuration:2 position:ccp([titleWord position].x, [titleWord position].y+30)];
	CCRepeatForever	*repeatAction = [CCRepeatForever actionWithAction:
									  [CCSequence actions:
									   actUp,actDown,nil
									   ]
									  ];
	[titleWord runAction:repeatAction];
}
-(void) girlSprite
{
    
    CCSprite*   wm1 = [CCSprite spriteWithFile:@"wm1.png"]; 
    CCSprite*   wm2 = [CCSprite spriteWithFile:@"wm2.png"]; 
    [self addChild:wm1];
    [self addChild:wm2];
    CCSprite*   happy = [CCSprite spriteWithFile:@"happy.png"]; 
    CCSprite*   find = [CCSprite spriteWithFile:@"find.png"]; 
    [wm1 addChild:happy];
    [happy setPosition:ccp(290, 100)];
    [wm2 addChild:find];
    [find setPosition:ccp(-50, 100)];
    
    [wm1 setPosition:ccp(0, 400)];
    [wm2 setPosition:ccp(960, 400)];
    
    CCMoveTo* actDown1 =[CCSequence actions: 
                         [CCMoveTo actionWithDuration:0.8 position:ccp(180+50,400+200)]
                         ,[CCCallFuncN actionWithTarget:self selector:@selector(doReatActionWm1:)],nil
                         ];
    [wm1 runAction:actDown1];
    
    CCMoveTo* actDown2 =[CCSequence actions: 
                         [CCMoveTo actionWithDuration:0.8 position:ccp(870-50,400+200)]
                         ,[CCCallFuncN actionWithTarget:self selector:@selector(doReatActionWm2:)],nil
                         ];
    [wm2 runAction:actDown2];

}
-(id) init
{
	if ((self = [super init])) {

        [self bkground];
        //[self snow];
        [self girlSprite];
        //[self tilte];
        [self button];
        //[self flash];
        
	}
	
	return self;
}
-(void) facebook
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/pages/Freeday/275372309175067"]];
}
-(void) twitter
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/freeday3"]];
}

-(void) classic
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];
    [[GameCtl sharedGameCtl] runSelectStageScene];
}
-(void) challenge
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];
    [[GameCtl sharedGameCtl] runChallengeDifGameSceneWithReadyGo];
}
-(void) online
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];
    [[GameCtl sharedGameCtl] runOnlineDifGameScene];
}
-(void) ring:(CCMenuItemImage*) btn
{

    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

	if ([UserData sharedUserData].m_isSound == 0) {
		CCSprite* ps =[CCSprite spriteWithFile:[NSString stringWithFormat:@"ring.png"]];
		[btn setNormalImage:(CCNode <CCRGBAProtocol>*)ps];
        [[GameCtl sharedGameCtl]openBkMusic];
	}
	else {
		CCSprite* ps =[CCSprite spriteWithFile:[NSString stringWithFormat:@"ringstop.png"]];
		[btn setNormalImage:(CCNode <CCRGBAProtocol>*)ps];
		//[btn setPosition:ccp(100,100)];
		//[btn itemFromNormalImage:MENULAYER_BTNVOICEON selectedImage:MENULAYER_BTNVOICEON disabledImage:MENULAYER_BTNVOICEON target:self selector:@selector(selectBtnVoiceON:)];
        [[GameCtl sharedGameCtl]closeBkMusic];

	}
}

-(void) help
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    [[CCDirector sharedDirector] replaceScene:[AboutScene scene]];
}

-(void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}
@end
