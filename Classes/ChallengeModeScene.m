//
//  ChallengeModeScene.m
//  HappyDifference
//
//  Created by zzyy on 11-12-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ChallengeModeScene.h"
#import "GameCtl.h"
#import "ChallengeDifGameLayer.h"
@implementation ChallengeModeScene
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        NSArray*    stageFolderAry = [GameCtl sharedGameCtl].m_stageFolderAry;
        NSString*   resRoot = [GameCtl sharedGameCtl].m_resRoot;
        int randStage = rand()%[GameCtl sharedGameCtl].m_stageFolderAry.count;
        int levelNum =0;
        for(int iCnt =0; ; iCnt++)
        {
            NSString*   stageNoStr = [stageFolderAry objectAtIndex:randStage];
            NSString*   stageFloderRoot = [resRoot stringByAppendingPathComponent:stageNoStr];
            
            NSString*   levelNoStr = [NSString stringWithFormat:@"level%d",iCnt+1];
            NSString*   levelFolderRoot = [stageFloderRoot stringByAppendingPathComponent:levelNoStr];
            
            BOOL isDir = NO;    
            [[NSFileManager defaultManager] fileExistsAtPath:levelFolderRoot isDirectory:(&isDir)];  
            if (isDir) {  
                levelNum++;  
            }  
            if(isDir == NO)
            {
                int i ;
                i =0;
                break;
            }
        }
        int randLevel = rand()%levelNum;
        //temp 
        randStage = 0;
        randLevel =0;
        ChallengeDifGameLayer* gameLayer = [[[ChallengeDifGameLayer alloc]initWithStage:randStage andLevel:randLevel] autorelease];
		[self addChild:gameLayer z:0 tag:ChallengeModeScene_gamelayer];
	}
	return self;
}
-(id) initWithReadyGo
{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        NSArray*    stageFolderAry = [GameCtl sharedGameCtl].m_stageFolderAry;
        NSString*   resRoot = [GameCtl sharedGameCtl].m_resRoot;
        int randStage = rand()%[GameCtl sharedGameCtl].m_stageFolderAry.count;
        int levelNum =0;
        for(int iCnt =0; ; iCnt++)
        {
            NSString*   stageNoStr = [stageFolderAry objectAtIndex:randStage];
            NSString*   stageFloderRoot = [resRoot stringByAppendingPathComponent:stageNoStr];
            
            NSString*   levelNoStr = [NSString stringWithFormat:@"level%d",iCnt+1];
            NSString*   levelFolderRoot = [stageFloderRoot stringByAppendingPathComponent:levelNoStr];
            
            BOOL isDir = NO;    
            [[NSFileManager defaultManager] fileExistsAtPath:levelFolderRoot isDirectory:(&isDir)];  
            if (isDir) {  
                levelNum++;  
            }  
            if(isDir == NO)
            {
                int i ;
                i =0;
                break;
            }
        }
        int randLevel = rand()%levelNum;
        //temp
        randStage = 0;
        randLevel =0;
        ChallengeDifGameLayer* gameLayer = [[[ChallengeDifGameLayer alloc]initWithReadyGo:randStage andLevel:randLevel] autorelease];
		[self addChild:gameLayer z:0 tag:ChallengeModeScene_gamelayer];
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
