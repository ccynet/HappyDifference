//
//  OnlineDifGameLayer.m
//  HappyDifference
//
//  Created by zzyy on 11-12-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OnlineDifGameLayer.h"
#import "UserData.h"
#import "GameCtl.h"
#import "SimpleAudioEngine.h"

#import "HappyDifferenceAppDelegate.h"
#import "GameCenterKit.h"

@implementation OnlineDifGameLayer
// Add these new methods to the top of the file
- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[GameCenterKit sharedInstance].m_match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        CCLOG(@"Error sending init packet");
        [self matchEnded];
    }
}
- (void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    
    [m_answersPointAry release];
    [m_starIconPlayer1 release];
    [m_starIconPlayer2 release];

    [self unschedule:@selector(updateBar)];
    
    [super dealloc];
}
-(void)initData
{
    m_player1FindOutNumInCurPhoto =0;
    [self deleteStarPlayer1];
    
    [self deletePhoto];
    [self drawPhoto];
    
    [self initProcessBar];
    [self schedule:@selector(updateBar) interval:0.5];
}
-(void)nextLevel
{

    //重新开始
    if((m_player1FinishPhotoNum%m_photoNumOnce) ==0)
    {
        m_player1FinishPhotoNum = 0;
        m_player1FinishTotalNum = 0;
    }
    else
    {
        m_player1FinishPhotoNum++;
        //send data
        [self sendPassPhotoNumber];
        [self initData];

    }
}

-(void) updateBar
{
    CCProgressTimer* bar = (CCProgressTimer*)[self getChildByTag:tag_pbar];
    m_barPercent = bar.percentage--;
    if(bar.percentage <0)//failed
    {
        bar.percentage = 0;
        [self unschedule:@selector(updateBar)];
        [self nextLevel];
    }
    else
    {
        if(m_player1FindOutNumInCurPhoto == [m_starIconPlayer1 count])//find 5 dif
        {
            [self unschedule:@selector(updateBar)];
            [self nextLevel];
        }
    }
}
-(void) initProcessBar
{
    CCProgressTimer* bar = (CCProgressTimer*)[self getChildByTag:tag_pbar];
    m_barPercent = 100;
    [self schedule:@selector(updateBar) interval:0.5];

}
-(void) drawProcessBar
{
    CCSprite*   barBk = [CCSprite spriteWithFile:@"pbarbk.png"];
    [self addChild:barBk];
    [barBk setPosition:CGPointMake(562, 746)];
    
    CCProgressTimer* bar = [CCProgressTimer progressWithFile:@"pbar.png"];
    bar.type = kCCProgressTimerTypeHorizontalBarLR;
    [self addChild:bar z:0 tag:tag_pbar];
    [bar setPosition:CGPointMake(552, 746)];
    bar.percentage =100; 
    
}
-(void) deleteStarPlayer2
{
    for(CCSprite* star in m_starIconPlayer2)
    {
        [self removeChild:star cleanup:YES];
    }
}
-(void) openStarPlayer2
{
    if(m_player2FindOutNumInCurPhoto <[m_starIconPlayer1 count])
    {
        CCSprite* star = [m_starIconPlayer1 objectAtIndex:m_player2FindOutNumInCurPhoto];
        [self addChild:star];
    }
    
}
-(void) deleteStarPlayer1
{
    for(CCSprite* star in m_starIconPlayer1)
    {
        [self removeChild:star cleanup:YES];
    }
}
-(void) openStarPlayer1
{
    if(m_player1FindOutNumInCurPhoto <[m_starIconPlayer1 count])
    {
        CCSprite* star = [m_starIconPlayer1 objectAtIndex:m_player1FindOutNumInCurPhoto];
        [self addChild:star];
    }
    
}
-(void) drawStarPlayer2
{
    //draw star bk
#define SX 46+768
#define SY 723
#define starNum 5
    
    m_player2FindOutNumInCurPhoto = 0;
    
    NSArray*  starNameAry = [[NSArray alloc]initWithObjects:@"lampb.png",@"lampa.png",nil];
    for(int iCnt =0; iCnt < starNum; iCnt++)
    {
        CCSprite* star = [CCSprite spriteWithFile:[starNameAry objectAtIndex:1]];
        [star setPosition:CGPointMake(SX+iCnt*(star.textureRect.size.width+10), SY)];
        [m_starIconPlayer2 addObject:star];
    }
    [starNameAry release];
}
-(void) drawStarPlayer1
{
    //draw star bk
#define SX 46
#define SY 723
#define starNum 5
    
    m_player1FindOutNumInCurPhoto = 0;
    
    NSArray*  starNameAry = [[NSArray alloc]initWithObjects:@"lampb.png",@"lampa.png",nil];
    for(int iCnt =0; iCnt < starNum; iCnt++)
    {
        CCSprite* star = [CCSprite spriteWithFile:[starNameAry objectAtIndex:1]];
        [star setPosition:CGPointMake(SX+iCnt*(star.textureRect.size.width+10), SY)];
        [m_starIconPlayer1 addObject:star];
    }
    [starNameAry release];
}
-(void) drawStarBkPlayer2
{
    m_starIconPlayer2  = [[NSMutableArray alloc]init];
    
#define SX 46+768
#define SY 723
#define starNum 5
    NSArray*  starNameAry = [[NSArray alloc]initWithObjects:@"lampb.png",@"lampa.png",nil];
    for(int iCnt =0; iCnt < starNum; iCnt++)
    {
        CCSprite* starBk = [CCSprite spriteWithFile:[starNameAry objectAtIndex:0]];
        [self addChild:starBk];
        [starBk setPosition:CGPointMake(SX+iCnt*(starBk.textureRect.size.width+10), SY)];
        
    }
    [starNameAry release];
}
-(void) drawStarBkPlayer1
{
    m_starIconPlayer1  = [[NSMutableArray alloc]init];

#define SX 46
#define SY 723
#define starNum 5
    NSArray*  starNameAry = [[NSArray alloc]initWithObjects:@"lampb.png",@"lampa.png",nil];
    for(int iCnt =0; iCnt < starNum; iCnt++)
    {
        CCSprite* starBk = [CCSprite spriteWithFile:[starNameAry objectAtIndex:0]];
        [self addChild:starBk];
        [starBk setPosition:CGPointMake(SX+iCnt*(starBk.textureRect.size.width+10), SY)];

    }
    [starNameAry release];
}

-(void) deletePhoto
{
    [self removeChild:m_leftsprite cleanup:YES];
    [self removeChild:m_rightsprite cleanup:YES];
}
-(void) drawPhoto
{
    
    //rand
    m_iCurStage = rand()%m_itotalStage;
    m_iCurLevel = rand()%m_itotalLevel;
    //draw photo
    //read No.stage answers an No.photo
    
    NSString*   resRoot = [GameCtl sharedGameCtl].m_resRoot;
    NSArray*    stageFolderAry = [GameCtl sharedGameCtl].m_stageFolderAry;
    NSString*   stageNoStr = [stageFolderAry objectAtIndex:m_iCurStage];
    NSString*   stageFloderRoot = [resRoot stringByAppendingPathComponent:stageNoStr];
    
    NSString*   levelNoStr = [NSString stringWithFormat:@"level%d",m_iCurLevel+1];
    m_levelFolderRoot = [stageFloderRoot stringByAppendingPathComponent:levelNoStr];
    NSString*   orgPath = [m_levelFolderRoot stringByAppendingPathComponent:@"a.jpg"];
    
    UIImage*  orgImage = [UIImage imageWithContentsOfFile:orgPath];
    m_orgImageWith = orgImage.size.width;
    int orgImageHeigh = orgImage.size.height;
    m_midLength = 4;
    CCTexture2D* orgTex = [[[CCTexture2D alloc]initWithImage:orgImage]autorelease];
    
    m_leftsprite = [CCSprite spriteWithTexture:orgTex];
    m_rightsprite = [CCSprite spriteWithTexture:orgTex];
    
    [self addChild:m_leftsprite];
    [self addChild:m_rightsprite];
    [m_leftsprite setAnchorPoint:CGPointMake(0, 0)];
    [m_rightsprite setAnchorPoint:CGPointMake(0, 0)];
    
    [m_leftsprite setPosition:CGPointMake(0, 0)];
    [m_rightsprite setPosition:CGPointMake(m_orgImageWith+m_midLength, 0)];
    
    //touch range
    m_touchRectLeft = CGRectMake(0, 0, m_orgImageWith, orgImageHeigh);
    m_touchRectright = CGRectMake(m_orgImageWith+m_midLength, 0, 2*m_orgImageWith+m_midLength, orgImageHeigh);
    
    [self drawAnswersWithRandFlag:YES];

}
-(void) drawbk
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //draw bkg
    CCSprite* bkg = [CCSprite spriteWithFile:@"DifGameBg.png"];
    [self addChild:bkg];
    [bkg setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
}
-(void) drawAnswersWithRandFlag:(BOOL) bFlag
{
    //answers
    //read No.stage answers an No.photo
    NSDictionary* GameCtlRoot = [GameCtl sharedGameCtl].m_difGameSceneDic;
    //photos group stage nums
    NSArray* stageAry = [GameCtlRoot objectForKey:@"stages"];
    m_itotalStage = [stageAry count];
    NSArray* stage = [stageAry objectAtIndex:m_iCurStage];
    m_itotalLevel = [stage count];
    NSDictionary* iCurItem = [stage objectAtIndex:(m_iCurLevel)];
    m_answersPointAry = [[NSMutableArray alloc]init];
    NSArray* answers = [iCurItem objectForKey:@"answers"];
    NSMutableArray* copyAnswers = [NSMutableArray arrayWithArray:answers];
    //get random answer for 5 answers
    for(int iCnt = 0 ;iCnt < 5; iCnt++)
    {
        if([copyAnswers count] >0)
        {
            NSDictionary* item;
            if(bFlag)
            {
                int randIndex = rand()%[copyAnswers count];
                item = [copyAnswers objectAtIndex:randIndex];
                [copyAnswers removeObject:item];
            }
            else
            {
                item = [copyAnswers objectAtIndex:iCnt];
            }
            //draw answer png
            NSString*   name = [item objectForKey:@"name"];
            NSString*   namePath = [m_levelFolderRoot stringByAppendingPathComponent:name];
            CCSprite*   answerSprite = [CCSprite spriteWithFile:namePath];
            NSString*   xStr = [item objectForKey:@"x"];
            NSString*   yStr = [item objectForKey:@"y"];
            CGPoint     point = ccp(xStr.floatValue, yStr.floatValue);
            [answerSprite setPosition:point];
            [self addChild:answerSprite];
            [m_answersPointAry addObject:item];
        }
    }
}
-(void) drawReadyGoLayer
{
    //add color layer
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    m_maskedReadyGoLayer = [CCLayerColor layerWithColor:ccc4(51, 51, 51, 128)];
    [self addChild:m_maskedReadyGoLayer z:1];
    CCSprite*   readySprite = [CCSprite spriteWithFile:@"ready.png"];
    CCSprite*   goSprite = [CCSprite spriteWithFile:@"start.png"];
    [m_maskedReadyGoLayer addChild:readySprite];
    [m_maskedReadyGoLayer addChild:goSprite];
    [readySprite setPosition:ccp(winSize.width/2, winSize.height/2)];
    [goSprite setPosition:ccp(winSize.width/2, winSize.height/2)];
    [goSprite setOpacity:0];
    [readySprite runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:0.5],
                            [CCFadeOut actionWithDuration:0.5],nil]];
    [goSprite runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:0.5],
                         [CCFadeIn actionWithDuration:0.5],[CCFadeOut actionWithDuration:0.5],
                         [CCCallFunc actionWithTarget:self selector:@selector(removeMaskedLayer)],nil]];
}
-(void) removeMaskedLayer
{
    [self removeChild:m_maskedReadyGoLayer cleanup:YES];
    [self schedule:@selector(updateBar) interval:0.5];
}
-(id) init
{
    if ((self = [super init])) {
        m_photoNumOnce = 5;
        m_player1FinishPhotoNum = 0;
        m_player1FinishTotalNum = 0;
        m_player2FinishPhotoNum = 0;
        m_player2FinishTotalNum = 0;
        
        m_player1FindOutNumInCurPhoto = 0;
        m_player2FindOutNumInCurPhoto = 0;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite* top = [CCSprite spriteWithFile:@"top.png"];
        [self addChild:top];
        [top setAnchorPoint:ccp(0, 0)];
        [top setPosition:ccp(0, 768-80)];
        
        //player icon
        CCSprite* player1 = [CCSprite spriteWithFile:@"player1.png"];
        [self addChild:player1];
        [player1 setPosition:ccp(20, 743)];
        
        CCSprite* player2 = [CCSprite spriteWithFile:@"player2.png"];
        [self addChild:player2];
        [player2 setPosition:ccp(winSize.width-20, 743)];
        //end
        
        [self drawProcessBar];
        [self drawStarBkPlayer1];
        [self drawStarBkPlayer2];


        //temp for online
        //从AppDelegate那里得到一个RootViewController，因为这个视图控制器将会显示出matchmaker界面
        HappyDifferenceAppDelegate* appDelegate = (HappyDifferenceAppDelegate*)[UIApplication sharedApplication].delegate;
        GameCenterKit* gameKit = [GameCenterKit sharedInstance];
        [gameKit findMatchWithMinPlayers:2 
                              maxPlayers:2 
                          viewController:appDelegate.viewController 
                                delegate:self];
    }
    return self;
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
    CGPoint touchLocation = [touch locationInView: [touch view]]; 
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    if(!CGRectContainsPoint(m_touchRectLeft, touchLocation)
       &&!CGRectContainsPoint(m_touchRectright, touchLocation))
    {
        return NO;
    }
    
    for(NSDictionary* item in m_answersPointAry)
    {
        NSString* strx = [item objectForKey:@"x"];
        NSString* stry = [item objectForKey:@"y"];
        CGFloat x1 = strx.floatValue;
        CGFloat y1 = stry.floatValue;
        
		CGFloat x2 = strx.floatValue+m_orgImageWith+m_midLength;
        CGFloat y2 = stry.floatValue;
        
        if(((fabs(touchLocation.x - x1)*fabs(touchLocation.x - x1) + fabs(touchLocation.y - y1)*fabs(touchLocation.y - y1)) < 55*55)
		   || ((fabs(touchLocation.x - x2)*fabs(touchLocation.x - x2) + fabs(touchLocation.y - y2)*fabs(touchLocation.y - y2)) < 55*55))
            
        {
            m_player1FindOutNumInCurPhoto++;
            [self sendFindOutNumInCurPhoto];
            m_player1FinishTotalNum++;
            [self sendFindOutNumber];
            
            //open star
            [self openStarPlayer1];
            
            //run action
            CCAnimation* anim = [CCAnimation animationWithFile:@"touch frame" frameCount:12 delay:0.02f];
            CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
            CCSprite* touchFrame1 = [CCSprite spriteWithFile:@"360rb.png"];
			CCSprite* touchFrame2 = [CCSprite spriteWithFile:@"360rb.png"];
            [self addChild:touchFrame1];
			[self addChild:touchFrame2];
            [touchFrame1 setPosition:ccp(x1,y1)];
			[touchFrame2 setPosition:ccp(x2,y2)];
            [touchFrame1 runAction:animate];
			[touchFrame2 runAction:animate];
            
            [m_answersPointAry removeObject:item];
            
            [[SimpleAudioEngine sharedEngine]playEffect:@"ding_add.mp3"];
            
            return YES;
        }
        
    }
    
#if 1
    CCMoveBy* moveLeft = [CCMoveBy actionWithDuration:0.05 position:ccp(8,0)];
    CCMoveBy* moveRight=[CCMoveTo actionWithDuration:0.05 position:ccp(8, 0)];  
    CCFiniteTimeAction* action= [CCSequence actions:moveLeft,moveRight, nil];  
    CCActionInterval* actionShake = [CCRepeat actionWithAction:action times:5];
    [self runAction:actionShake];
#else
    CCActionInterval* shaky = [CCShaky3D actionWithRange:4 shakeZ:false grid:ccg(15, 10) duration:5];
    [self runAction:shaky];
#endif
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"error.mp3"];
	CCProgressTimer* bar = (CCProgressTimer*)[self getChildByTag:tag_pbar];
	bar.percentage -= 4;
	
    return YES; //这儿如果返回NO 此次触摸将被忽略
}

-(void) showPlayersName
{
    int nameLength = 12;
    m_player1Name = [GKLocalPlayer localPlayer].alias;
    m_player1Name = [m_player1Name substringToIndex:nameLength];
    
    CCLabelBMFont *player1Label = [CCLabelBMFont labelWithString:m_player1Name 
                                                         fntFile:@"about_color.fnt"];
    [self addChild:player1Label];
    [player1Label setPosition:ccp(100, 743)];
    
    m_player2Name = [GameCenterKit sharedInstance].m_otherPlayerName;
    m_player2Name = [m_player2Name substringToIndex:nameLength];
    
    CCLabelBMFont *player2Label = [CCLabelBMFont labelWithString:m_player2Name 
                                                         fntFile:@"about_color.fnt"];
    [self addChild:player2Label];
    [player2Label setPosition:ccp(100, 743)];
}
#pragma mark send data
-(void)sendPassPhotoNumber
{
    MessageSendNumber message;
    message.message.messageType = kMessageTypePassPhotoNumber;
    message.num = m_player1FinishPhotoNum;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageSendNumber)]; 
    [self sendData:data];
}
-(void)sendFindOutNumber
{
    MessageSendNumber message;
    message.message.messageType = kMessageTypeFindOutNumber;
    message.num = m_player1FinishTotalNum;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageSendNumber)]; 
    [self sendData:data];
}
-(void)sendFindOutNumInCurPhoto
{
    MessageSendNumber message;
    message.message.messageType = kMessageTypeFindOutNumberInCurPhoto;
    message.num = m_player1FindOutNumInCurPhoto;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageSendNumber)]; 
    [self sendData:data];
}

- (void)sendGameOver:(BOOL)player1Won {
    
    MessageGameOver message;
    message.message.messageType = kMessageTypeGameOver;
    message.player1Won = player1Won;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)]; 
    [self sendData:data];
    
}
// Modify setGameState as follows
// Adds debug labels for extra states
- (void)setGameState:(GameState)state {
    
    m_gameState = state;
    if (m_gameState == kGameStateWaitingForMatch) {

    } else if (m_gameState == kGameStateWaitingForRandomNumber) {

    } else if (m_gameState == kGameStateWaitingForStart) {

    } else if (m_gameState == kGameStateActive) {

    } else if (m_gameState == kGameStateDone) {

    } 
    
}
// Add new methods to bottom of file
#pragma mark GameCenterKitDelegate
- (void)matchStarted { 
    CCLOG(@"Match started");
    
    [self showPlayersName];
    [self drawPhoto];
    [self drawReadyGoLayer];
}
- (void)matchEnded { 
    CCLOG(@"Match ended"); 
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    CCLOG(@"Received data");
    
    Message *message = (Message *) [data bytes];
    
    if(message->messageType == kMessageTypePassPhotoNumber)
    {
        MessageSendNumber* messagePassPhotoNumber = (MessageSendNumber*)[data bytes];
        m_player2FinishPhotoNum = messagePassPhotoNumber->num;
    }
    else if(message->messageType == kMessageTypeFindOutNumber)
    {
        MessageSendNumber*   messageFindOutNumber = (MessageSendNumber*)[data bytes];
        m_player2FinishTotalNum = messageFindOutNumber->num;
    }
    else if(message->messageType == kMessageTypeFindOutNumberInCurPhoto)
    {
        MessageSendNumber*  messageFindOutNumInCurPhoto = (MessageSendNumber*)[data bytes];
        m_player2FindOutNumInCurPhoto = messageFindOutNumInCurPhoto->num;
        [self openStarPlayer2];
        
    } else if (message->messageType == kMessageTypeGameOver) { 
        
        MessageGameOver * messageGameOver = (MessageGameOver *) [data bytes];
        CCLOG(@"Received game over with player 1 won: %d", messageGameOver->player1Won);
        
        if (messageGameOver->player1Won) {
            [self endScene:kEndReasonLose]; 
        } else {
            [self endScene:kEndReasonWin]; 
        }
        
    }
    
}

@end
