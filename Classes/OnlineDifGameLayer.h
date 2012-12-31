//
//  OnlineDifGameLayer.h
//  HappyDifference
//
//  Created by zzyy on 11-12-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "GameCenterKit.h"

enum OnlineDifGameLayer_tag_name
{
    tag_score,
    tag_pbar,
}OnlineDifGameLayer_tag_name;
//game state
typedef enum {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
} GameState;
//你也需要添加一个游戏结束的新的原因---断开连接。因此，修改EndReason枚举类型，如下所示：

typedef enum {
    kEndReasonWin,
    kEndReasonLose,
    kEndReasonDisconnect
} EndReason;
//每个消息定义相应的结构体类型
typedef enum {
    kMessageTypeFindOutNumber =0,
    kMessageTypePassPhotoNumber,
    kMessageTypeFindOutNumberInCurPhoto,
    kMessageTypeGameBegin,
    kMessageTypeGameOver
} MessageType;

typedef struct {
    MessageType messageType;
} Message;

typedef struct
{
    Message message;
    int     num;
}MessageSendNumber;

typedef struct {
    Message message;
} MessageGameBegin;


typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;


@interface OnlineDifGameLayer : CCLayer <GameCenterKitDelegate>{

    int                m_orgImageWith;
    int                m_midLength;
    
    CGRect             m_touchRectLeft;
    CGRect             m_touchRectright;
    NSMutableArray*    m_answersPointAry;
    
    int                m_itotalStage;
    int                m_itotalLevel;
    int                m_iCurStage;
    int                m_iCurLevel;
    int                m_barPercent;

    NSMutableArray*    m_starIconPlayer1;
    NSMutableArray*    m_starIconPlayer2;

    NSString*          m_levelFolderRoot;
    CCLayerColor*      m_maskedReadyGoLayer;
    CCSprite*          m_leftsprite;
    CCSprite*          m_rightsprite;
    
    int                m_photoNumOnce;
    int                m_player1FindOutNumInCurPhoto;
    int                m_player2FindOutNumInCurPhoto;

    int                m_player1FinishPhotoNum;
    int                m_player1FinishTotalNum;
    int                m_player2FinishTotalNum;
    int                m_player2FinishPhotoNum;
    NSString*          m_player1Name;
    NSString*          m_player2Name;
    
    GameState          m_gameState;

}
@end
