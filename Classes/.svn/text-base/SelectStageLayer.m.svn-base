//
//  SelectStageLayer.m
//  HappyDifference
//
//  Created by zzyy on 11-11-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SelectStageLayer.h"
#import "GameCtl.h"
#import "CCScrollLayer.h"
#import "UserData.h"
#import "SimpleAudioEngine.h"

@implementation SelectStageLayer

enum
{
    scroll_layer_tag =0,
}tag;

-(void)dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    [m_bkImages release];
	[m_stageAryNUM release];
    [super dealloc];
}
-(id)init
{
    if((self = [super init]))
    {
        CGSize winSize = [CCDirector sharedDirector].winSize;

        m_bkImages = [[NSMutableArray alloc] init];
		m_stageAryNUM = [[NSMutableArray alloc] init];
//        for (int iCount =0; iCount < [stageAry count]; iCount++) 
		int iCount = 0;
		{            
            NSArray*    stageFolderAry = [GameCtl sharedGameCtl].m_stageFolderAry;
            NSString*   resRoot = [GameCtl sharedGameCtl].m_resRoot;
            NSString*   stage = [stageFolderAry objectAtIndex:0];
            NSString*   stagePath = [resRoot stringByAppendingPathComponent:stage];
            NSString*   coverPath = [stagePath stringByAppendingPathComponent:@"stagebk.png"];
            CCSprite*   splashImage = [CCSprite spriteWithFile:coverPath];
            [splashImage setPosition:ccp(winSize.width/2,winSize.height/2)];
            [self addChild:splashImage];
			NSNumber* num = [NSNumber numberWithInt:0];
			[m_stageAryNUM addObject:num];
            [m_bkImages addObject:splashImage];
        }

        //line
        CCSprite* line = [CCSprite spriteWithFile:@"line.png"];
        [line setPosition:ccp(winSize.width/2, winSize.height/2)];
        [self addChild:line];
        
        //menu
        NSArray*  stageLockedNameAry = [[[NSArray alloc]initWithObjects:@"stage_1_locked.png",@"stage_2_locked.png",@"stage_3_locked.png",@"stage_4_locked.png",@"stage_5_locked.png",nil]autorelease];
        NSArray*  stageNameAry = [[[NSArray alloc]initWithObjects:@"stage_1.png",@"stage_2.png",@"stage_3.png",
                                         @"stage_4.png",@"stage_5.png",nil]autorelease];

        NSMutableArray* layersAry = [[[NSMutableArray alloc]init]autorelease];

        for(int iCnt =0; iCnt <[stageNameAry count]; iCnt++)
        {
            CCLayer* layer = [[[CCLayer alloc]init]autorelease];
            CCMenuItemImage* stageItemImage;
            int d = [[UserData sharedUserData] m_iPassStageNo];
            if(iCnt <= [[UserData sharedUserData] m_iPassStageNo])
            {
                stageItemImage = [CCMenuItemImage itemFromNormalImage:[stageNameAry objectAtIndex:iCnt] 
                                                        selectedImage:[stageNameAry objectAtIndex:iCnt]  
                                                        disabledImage:@"" 
                                                               target:self 
                                                             selector:@selector(selectStage:)];
            }
            else
            {
                stageItemImage = [CCMenuItemImage itemFromNormalImage:[stageLockedNameAry objectAtIndex:iCnt] 
                                                        selectedImage:[stageLockedNameAry objectAtIndex:iCnt]  
                                                        disabledImage:@"" 
                                                               target:self 
                                                             selector:@selector(selectStage:)];
            }
            [stageItemImage setTag:iCnt];
            CCMenu* menu = [CCMenu menuWithItems:stageItemImage, nil];
            [layer addChild:menu];
            [menu setPosition:ccp(0, 0)];
            [stageItemImage setPosition:ccp(winSize.width/2, winSize.height/2)];
            [layersAry addObject:layer];
        }

        // now create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages)
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:layersAry
                                                            widthOffset:0.5f*winSize.width];
        [self addChild:scroller];
        [scroller setTag:scroll_layer_tag];
        
        scroller.pagesIndicatorPosition = ccp(winSize.width * 0.5f, 30.0f);
        
        // New feature: margin offset - to slowdown scrollLayer when scrolling out of it contents.
        // Comment this line or change marginOffset to screenSize.width to disable this effect.
        scroller.marginOffset = 1.5*winSize.width;
        
        [scroller moveToPage: 0];
        m_iCurScrollPage =0;
        scroller.delegate = self;
        [scroller release];
        
        //back btn
        CCMenuItemImage*    backItemImage = [CCMenuItemImage itemFromNormalImage:@"back_n.png" 
                                                                   selectedImage:@"back_n.png" 
                                                                   disabledImage:@"" target:self selector:@selector(backToMenu:)];
        CCMenu*     selectMenu = [CCMenu menuWithItems:backItemImage, nil];
        [selectMenu setPosition:ccp(0, 0)];
        
        [backItemImage setPosition:ccp(30, 30)];
        [self addChild:selectMenu];

    }
    return self;
}
-(void) backToMenu:(CCMenuItemImage*) btn
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    [[GameCtl sharedGameCtl] backMainMenuScene];
}
-(void) selectStage:(CCMenuItemImage*) btn
{
    if([btn tag] <= [[UserData sharedUserData] m_iPassStageNo])
    {
        if([btn tag] == m_iCurScrollPage)
        {
            [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

            [[GameCtl sharedGameCtl] runSelectLevelScene:m_iCurScrollPage];
        }
        else
        {
            CCScrollLayer * scrollLayer = [self getChildByTag:scroll_layer_tag];
            [scrollLayer moveToPage:[btn tag]];
        }
    }
}

// Unselects all selected menu items in node - used in scroll layer callbacks to 
// cancel menu items when scrolling started.
-(void)unselectAllMenusInNode:(CCNode *)node
{
	for (CCNode *child in node.children) 
	{
		if ([child isKindOfClass:[CCMenu class]]) 
		{
			// Child here is CCMenu subclass - unselect.
			//[(CCMenu *)child unselectSelectedItem];
		}
		else
		{
			// Child here is some other CCNode subclass.
			[self unselectAllMenusInNode: child];
		}
	}
}

- (void) scrollLayerScrollingStarted:(CCScrollLayer *) sender
{
	NSLog(@"CCScrollLayerTestLayer#scrollLayerScrollingStarted: %@", sender);
	
	// No buttons can be touched after scroll started.
	[self unselectAllMenusInNode: self];
}

- (void) scrollLayer: (CCScrollLayer *) sender scrolledToPageNumber: (int) page
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

	CGSize winSize = [CCDirector sharedDirector].winSize;
	
    if(m_iCurScrollPage != page)
    {
		BOOL BFlag = NO;
		for (int iCnt =0; iCnt <[m_stageAryNUM count]; iCnt++) {
			int val = [[m_stageAryNUM objectAtIndex:iCnt] intValue];
			if (page == val) {
				BFlag = YES;
			}
		}
		
		if (!BFlag) {
            
            NSArray*    stageFolderAry = [GameCtl sharedGameCtl].m_stageFolderAry;
            NSString*   resRoot = [GameCtl sharedGameCtl].m_resRoot;
            NSString*   stage = [stageFolderAry objectAtIndex:page];
            NSString*   stagePath = [resRoot stringByAppendingPathComponent:stage];
            NSString*   coverPath = [stagePath stringByAppendingPathComponent:@"stagebk.png"];
            CCSprite* splashImage = [CCSprite spriteWithFile:coverPath];
            [splashImage setPosition:ccp(winSize.width/2,winSize.height/2)];
            [self addChild:splashImage z:-1];
          
			[splashImage setOpacity:0];
			NSNumber* num = [NSNumber numberWithInt:page];
			[m_stageAryNUM addObject:num];
			
            [m_bkImages addObject:splashImage];
        }
		
        CCSprite* icurrent = (CCSprite*)[m_bkImages objectAtIndex:m_iCurScrollPage];
        CCSprite* next =  (CCSprite*)[m_bkImages objectAtIndex:page];
        [icurrent runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.3],nil]];
        [next runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.3],nil]];
    }

    m_iCurScrollPage = page;

	NSLog(@"CCScrollLayerTestLayer#scrollLayer:scrolledToPageNumber: %@ %d", sender, page);
}
@end
