//
//  SelectLevelLayer.m
//  HappyDifference
//
//  Created by zzyy on 11-12-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SelectLevelLayer.h"
#import "GameCtl.h"
#import "UserData.h"
#import "SimpleAudioEngine.h"
@implementation SelectLevelLayer

-(void) drawStarResultForEveryLevel
{
    //minbg
    CCSpriteBatchNode* batchNode = [CCSpriteBatchNode batchNodeWithFile:@"minbg.png"];
    [self addChild:batchNode];
    
    //lock
    CCSpriteBatchNode* batchLockNode = [CCSpriteBatchNode batchNodeWithFile:@"Lock.png"];
    [self addChild:batchLockNode];
    //star,include On & Off
    CCSpriteBatchNode* starOnbatchNode = [CCSpriteBatchNode batchNodeWithFile:@"star2.png"];
    CCSpriteBatchNode* starOffbatchNode = [CCSpriteBatchNode batchNodeWithFile:@"star1.png"];
    [self addChild:starOnbatchNode];
    [self addChild:starOffbatchNode];
    
    for(int iCnt =0; ; iCnt++)
    {
        NSString*   levelNoStr = [NSString stringWithFormat:@"level%d",iCnt+1];
        NSString*   levelFolderRoot = [m_stagePath stringByAppendingPathComponent:levelNoStr];
        
        BOOL isDir = NO;    
        [[NSFileManager defaultManager] fileExistsAtPath:levelFolderRoot isDirectory:(&isDir)];  
        
        if(isDir == NO)
        {
            int i ;
            i =0;
            break;
        }
        
        CCSprite* level = [CCSprite spriteWithFile:@"minbg.png"];
        [batchNode addChild:level];
        int width = level.textureRect.size.width;
        int heigth = level.textureRect.size.height;
        [level setPosition:ccp(165+(iCnt%5)*width, 590-(iCnt/5)*(heigth+20))];
        
        NSString* thumbPath = [levelFolderRoot stringByAppendingPathComponent:@"thumb.png"];
        
        CCMenuItemImage* previewBtn = [CCMenuItemImage itemFromNormalImage:thumbPath selectedImage:thumbPath disabledImage:@"" target:self selector:@selector(selectLevel:)];
        [previewBtn setPosition:ccp(165+(iCnt%5)*width, 590-(iCnt/5)*(heigth+20)+11)];
        [previewBtn setTag:iCnt];
        
        CCMenu * menu = [CCMenu menuWithItems:previewBtn,nil];
        [menu setPosition:ccp(0, 0)];
        [self addChild:menu];
        
        //Add level lock
        if (([UserData sharedUserData].m_iPassStageNo == m_iCurStage && iCnt > [UserData sharedUserData].m_iPassLevel) 
            || ([UserData sharedUserData].m_iPassStageNo < m_iCurStage)) {
            CCSprite* levelLocked = [CCSprite spriteWithFile:@"Lock.png"];
            [batchLockNode addChild:levelLocked];
            //width = levelLocked.textureRect.size.width;
            //heigth = levelLocked.textureRect.size.height;
            [levelLocked setPosition:ccp(165+(iCnt%5)*width, 590-(iCnt/5)*(heigth+20)+11)];
            
            previewBtn.color = ccc3(150, 150, 150);
            
        }
        CCSprite* pStar1;
        CCSprite* pStar2;
        CCSprite* pStar3;
        //buttom star
        NSNumber* nsstarnum = [[[UserData sharedUserData].m_passScoreAry objectAtIndex:m_iCurStage]objectAtIndex:iCnt];
        switch ([nsstarnum intValue]) {
            case 0:
            {
                pStar1 = [CCSprite spriteWithFile:@"star1.png"];
                pStar2 = [CCSprite spriteWithFile:@"star1.png"];
                pStar3 = [CCSprite spriteWithFile:@"star1.png"];
                [starOffbatchNode addChild:pStar1];
                [starOffbatchNode addChild:pStar2];
                [starOffbatchNode addChild:pStar3];
            }
                break;
            case 1:
            {
                pStar1 = [CCSprite spriteWithFile:@"star2.png"];
                pStar2 = [CCSprite spriteWithFile:@"star1.png"];
                pStar3 = [CCSprite spriteWithFile:@"star1.png"];
                [starOnbatchNode addChild:pStar1];
                [starOffbatchNode addChild:pStar2];
                [starOffbatchNode addChild:pStar3];
            }
                break;
            case 2:
            {
                pStar1 = [CCSprite spriteWithFile:@"star2.png"];
                pStar2 = [CCSprite spriteWithFile:@"star2.png"];
                pStar3 = [CCSprite spriteWithFile:@"star1.png"];
                [starOnbatchNode addChild:pStar1];
                [starOnbatchNode addChild:pStar2];
                [starOffbatchNode addChild:pStar3];
            }
                break;
            case 3:
            {
                pStar1 = [CCSprite spriteWithFile:@"star2.png"];
                pStar2 = [CCSprite spriteWithFile:@"star2.png"];
                pStar3 = [CCSprite spriteWithFile:@"star2.png"];
                [starOnbatchNode addChild:pStar1];
                [starOnbatchNode addChild:pStar2];
                [starOnbatchNode addChild:pStar3];
            }
                break;
            default:
                
                break;
        }
        
        [pStar1 setPosition:ccp(165+(iCnt%5)*width-40, 590-(iCnt/5)*(heigth+20)-70)];
        [pStar2 setPosition:ccp(165+(iCnt%5)*width, 590-(iCnt/5)*(heigth+20)-70)];
        [pStar3 setPosition:ccp(165+(iCnt%5)*width+40, 590-(iCnt/5)*(heigth+20)-70)];
    }

}
-(void)dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    
    [super dealloc];
}
-(id) initWithStage:(int)iStage;
{
    if((self = [super init]))
    {
        m_iCurStage = iStage;
        
        NSArray*    stageFolderAry = [GameCtl sharedGameCtl].m_stageFolderAry;
        NSString*   resRoot = [GameCtl sharedGameCtl].m_resRoot;
        NSString*   stage = [stageFolderAry objectAtIndex:m_iCurStage];
        m_stagePath = [resRoot stringByAppendingPathComponent:stage];
        
        NSString*   coverPath = [m_stagePath stringByAppendingPathComponent:@"stagebk.png"];
        CGSize winSize = [[CCDirector sharedDirector]winSize];

        //bk
        CCSprite* bk = [CCSprite spriteWithFile:coverPath];
        [bk setPosition:ccp(winSize.width/2,winSize.height/2)];
        [self addChild:bk];
        


		        
        [self drawStarResultForEveryLevel];
		
        //back btn
        //back
        CCMenuItemImage*    backItemImage = [CCMenuItemImage itemFromNormalImage:@"back_n.png" 
                                                                   selectedImage:@"back_n.png" 
                                                                   disabledImage:@"" target:self selector:@selector(backToMenu:)];
        CCMenu*     selectMenu = [CCMenu menuWithItems:backItemImage, nil];
        [selectMenu setPosition:ccp(0, 0)];
        
        [backItemImage setPosition:ccp(30, 30)];
        [self addChild:selectMenu];
    }
    return  self;
}
-(void) backToMenu:(CCMenuItemImage*) btn
{
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    [[GameCtl sharedGameCtl] runSelectStageScene];
}
-(void) selectLevel:(CCMenuItemImage*) btn
{
	if(([UserData sharedUserData].m_iPassStageNo == m_iCurStage && [btn tag] > [UserData sharedUserData].m_iPassLevel) 
	|| ([UserData sharedUserData].m_iPassStageNo < m_iCurStage))
	{
		return ;
	}
    [[SimpleAudioEngine sharedEngine]playEffect:BTN_MUSIC];

    [[GameCtl sharedGameCtl]runClassicDifGameSceneWithReadyGo:m_iCurStage andLevel:[btn tag]];
}

@end
