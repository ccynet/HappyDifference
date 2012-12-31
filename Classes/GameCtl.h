//
//  GameCtl.h
//  HappyDifference
//
//  Created by zzyy on 11-10-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define BTN_MUSIC      @"icon_s.mp3"

@class ClassicDifGameScene;

@interface GameCtl:NSObject{
    NSDictionary*   m_difGameSceneDic;
    NSString*       m_resRoot;
    NSMutableArray* m_stageFolderAry;
    
    int             m_iCurChallengeLevel;
}
+(GameCtl*) sharedGameCtl;

-(void)runOnlineDifGameScene;

-(void) runChallengeDifGameSceneWithReadyGo;
-(void) runChallengeNextLevelScene;

-(void) runClassicDifGameSceneWithStage:(int) iSelectStage andLevel:(int) iLevel;
-(void) runClassicDifGameSceneWithReadyGo:(int) iSelectStage andLevel:(int) iLevel;

-(void) runMainMenuScene;

-(void) runSelectStageScene;
-(void) runSelectLevelScene:(int) iSelectStage;

-(void) backMainMenuScene;

-(void)setupMusic;
-(void)playBkMusic:(NSString*) filename;
-(void)openBkMusic;
-(void)closeBkMusic;

@property(assign, readonly) NSDictionary*   m_difGameSceneDic;
@property(assign, readonly) NSString*       m_resRoot;
@property(assign, readonly) NSMutableArray* m_stageFolderAry;
@property(assign, readonly) int m_iCurChallengeLevel;




@end
