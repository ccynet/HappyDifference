//
//  GameCtl.m
//  HappyDifference
//
//  Created by zzyy on 11-10-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameCtl.h"
#import "MainMenuScene.h"
#import "ClassicDifGameScene.h"
#import "SelectStageScene.h"
#import "SelectLevelScene.h"
#import "SimpleAudioEngine.h"
#import "UserData.h"
#import "StartSuccessScene.h"
#import "ChallengeModeScene.h"
#import "OnlineDifGameModeScene.h"

@implementation GameCtl


@synthesize m_difGameSceneDic,m_resRoot,m_stageFolderAry,m_iCurChallengeLevel;

#define scene_transform_time 0.5

static GameCtl*  _sharedGameCtl = nil;

+(GameCtl*) sharedGameCtl
{
	if (!_sharedGameCtl) 
    {
        _sharedGameCtl = [[GameCtl alloc]init];
        
	}
    
	return _sharedGameCtl;
}
-(void) dealloc
{
    [m_resRoot release];
    [m_difGameSceneDic release];
    [m_stageFolderAry release];
    [super dealloc];
}
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
    if((self = [super init]))
    {
        m_stageFolderAry = [[NSMutableArray alloc]init];
        m_resRoot =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"iPad"];
        [m_resRoot retain];
        
        //get stage folder
        for(int iCnt =0;;iCnt++)
        {
            NSString*   stageNoStr = [NSString stringWithFormat:@"stage%d",iCnt];
            NSString*   stageFloderRoot = [m_resRoot stringByAppendingPathComponent:stageNoStr];
            BOOL isDir = NO;    
            [[NSFileManager defaultManager] fileExistsAtPath:stageFloderRoot isDirectory:(&isDir)];  
            if (isDir) {  
                [m_stageFolderAry addObject:stageNoStr];  
            }  
            if(isDir == NO)
                break;
        }
        
        NSString*   difGameScenePath = [m_resRoot stringByAppendingPathComponent:@"GameCtl.plist"];
        m_difGameSceneDic = [NSDictionary dictionaryWithContentsOfFile:difGameScenePath];
        [m_difGameSceneDic retain];
        

    }
	return self;
}
-(void)setupMusic
{
    if([UserData sharedUserData].m_isSound)
    {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.3f];
    }
    else
    {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f];
    }
    
    [self playBkMusic:@"merry christmas.mp3"];
    [[SimpleAudioEngine sharedEngine]preloadEffect:@"ding_add.mp3"];
    [[SimpleAudioEngine sharedEngine]setEffectsVolume:1.0f];
    [[SimpleAudioEngine sharedEngine]preloadEffect:BTN_MUSIC];
}
-(void)playBkMusic:(NSString*) filename
{
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:filename loop:YES];
}
-(void)openBkMusic
{
    //bkmusic
    [UserData sharedUserData].m_isSound =1;

    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.3f];

}
-(void)closeBkMusic
{
    //bkmusic
    [UserData sharedUserData].m_isSound =0;

    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f];

}
-(void) transitionScene:(CCScene*) gameScene
{
    CCTransitionSlideInR *transitionScene = [CCTransitionSlideInR transitionWithDuration:scene_transform_time scene:gameScene]; 
    [[CCDirector sharedDirector] replaceScene:transitionScene];
}
-(void) runOnlineDifGameScene
{
    OnlineDifGameModeScene* gameScene = [OnlineDifGameModeScene node];
    [[CCDirector sharedDirector] replaceScene:gameScene];

}
-(void) runChallengeDifGameSceneWithReadyGo
{
    m_iCurChallengeLevel =0;
    ChallengeModeScene* gameScene = [[[ChallengeModeScene alloc] initWithReadyGo]autorelease];

    [[CCDirector sharedDirector] replaceScene:gameScene];

}
-(void)runChallengeNextLevelScene
{
    m_iCurChallengeLevel++;
    ChallengeModeScene* gameScene = [ChallengeModeScene node];

    [[CCDirector sharedDirector] replaceScene:gameScene];
}
-(void) replaseMainMenuScene
{
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];

}
-(void) runMainMenuScene
{
    [[CCDirector sharedDirector] runWithScene:[MainMenuScene scene]];

}
-(void) backMainMenuScene
{
    MainMenuScene* mainScene = [MainMenuScene scene];

    [[CCDirector sharedDirector] replaceScene:mainScene];

}
-(void) runClassicDifGameSceneWithReadyGo:(int) iSelectStage andLevel:(int) iLevel
{
    ClassicDifGameScene* gameScene = [[[ClassicDifGameScene alloc]initWithReadyGo:iSelectStage andLevel:iLevel]autorelease];
    
    [[CCDirector sharedDirector] replaceScene:gameScene];
    
}
-(void) runClassicDifGameSceneWithStage:(int) iSelectStage andLevel:(int) iLevel
{
    ClassicDifGameScene* gameScene = [[[ClassicDifGameScene alloc]initWithStage:iSelectStage andLevel:iLevel]autorelease];

    [[CCDirector sharedDirector] replaceScene:gameScene];

}
-(void) runSelectLevelScene:(int) iSelectStage
{
    SelectLevelScene* selLevelScene =[[[SelectLevelScene alloc]initWithStage:iSelectStage]autorelease];

    [[CCDirector sharedDirector] replaceScene:selLevelScene];
}
-(void) runSelectStageScene
{
    SelectStageScene* selStageScene =[SelectStageScene node];

    [[CCDirector sharedDirector] replaceScene:selStageScene];

}
@end