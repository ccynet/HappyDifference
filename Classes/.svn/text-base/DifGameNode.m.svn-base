//
//  DifGameNode.m
//  HappyDifference
//
//  Created by zzyy on 11-11-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DifGameNode.h"
#import "DifGameLayer.h"
#import "SimpleAudioEngine.h"
#import "UserData.h"
#import "GameCtl.h"

enum tag
{
    tag_pbar =0,
}tag_name;

@implementation DifGameNode
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [self removeAllChildrenWithCleanup:YES];
    [m_answersPointAry release];
    [m_starIcon release];
    [self unschedule:@selector(updateBar)];
    [super dealloc];
}
-(void)nextLevel
{
    NSNumber* score;
    CCProgressTimer* bar = (CCProgressTimer*)[self getChildByTag:tag_pbar];
    if(bar.percentage >70)
    {
        score = [NSNumber numberWithInt:3];
    }
    else if(bar.percentage>50)
    {
        score = [NSNumber numberWithInt:2];

    }
    else
    {
        score = [NSNumber numberWithInt:1];

    }
    
    NSMutableArray* stageAry = [[UserData sharedUserData].m_passScoreAry objectAtIndex:m_iCurStage];
    [stageAry replaceObjectAtIndex:m_iCurLevel withObject:score];

    if((m_iCurLevel +1) >= m_itotalLevel)
    {
        //next stage
        [m_layer showStageCompletedLayer];
    }
    else
    {
        [m_layer showLevelPassLayer];

    }
}
-(void) updateBar
{
    CCProgressTimer* bar = (CCProgressTimer*)[self getChildByTag:tag_pbar];
    bar.percentage--;
    if(bar.percentage <0)
    {
        bar.percentage = 0;
        [self unschedule:@selector(updateBar)];
        //show failed level
        [m_layer showLevelFailedLayer];
    }
    else
    {
        if(m_openStarNum == [m_starIcon count])
        {
            //show pass level
            [self nextLevel];
            [self unschedule:@selector(updateBar)];
        }
    }
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
    [self schedule:@selector(updateBar) interval:0.5];
    
    CCSprite* cate = [CCSprite spriteWithFile:@"cate.png"];
    [self addChild:cate];
    [cate setPosition:ccp(68, 695)];
    
}
-(void) drawStar
{
    //draw star bk
#define SX 746
#define SY 723
#define starNum 5
    
    m_starIcon  = [[NSMutableArray alloc]init];
    m_openStarNum =0;
    
    NSArray*  starNameAry = [[NSArray alloc]initWithObjects:@"lampb.png",@"lampa.png",nil];
    for(int iCnt =0; iCnt < starNum; iCnt++)
    {
        CCSprite* starBk = [CCSprite spriteWithFile:[starNameAry objectAtIndex:0]];
        [self addChild:starBk];
        //[starBk setAnchorPoint:CGPointMake(0, 0)];
        [starBk setPosition:CGPointMake(SX+iCnt*(starBk.textureRect.size.width+10), SY)];
        CCSprite* star = [CCSprite spriteWithFile:[starNameAry objectAtIndex:1]];
        //[star setAnchorPoint:CGPointMake(0, 0)];
        [star setPosition:CGPointMake(SX+iCnt*(starBk.textureRect.size.width+10), SY)];
        [m_starIcon addObject:star];
    }
    [starNameAry release];
}
-(void) drawPhoto
{
    //draw photo
    //read No.stage answers an No.photo

    NSString*   resRoot = [GameCtl sharedGameCtl].m_resRoot;
    NSArray*    stageFolderAry = [GameCtl sharedGameCtl].m_stageFolderAry;
    NSString*   stageNoStr = [stageFolderAry objectAtIndex:m_iCurStage];
    NSString*   stageFloderRoot = [resRoot stringByAppendingPathComponent:stageNoStr];
    
    NSString*   levelNoStr = [NSString stringWithFormat:@"level%d",m_iCurLevel+1];
    NSString*   levelFolderRoot = [stageFloderRoot stringByAppendingPathComponent:levelNoStr];
    NSString*   leftPath = [levelFolderRoot stringByAppendingPathComponent:@"a.png"];
    NSString*   rightPath = [levelFolderRoot stringByAppendingPathComponent:@"b.png"];


    CCSprite* leftsprite = [CCSprite spriteWithFile:leftPath];
    CCSprite* rightsprite = [CCSprite spriteWithFile:rightPath];
    [self addChild:leftsprite];
    [self addChild:rightsprite];
    [leftsprite setAnchorPoint:CGPointMake(0, 0)];
    [rightsprite setAnchorPoint:CGPointMake(0, 0)];
    
    [leftsprite setPosition:CGPointMake(26, 37)];
    [rightsprite setPosition:CGPointMake(519, 37)];
}
// on "init" you need to initialize your instance
-(id) initWithStage:(int)iStage level:(int)iLevel andLayer:(DifGameLayer*) layer
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {

        m_iCurStage = iStage;
        m_iCurLevel = iLevel;

        m_touchRectLeft = CGRectMake(26, 37, 480, 650);
        m_touchRectright = CGRectMake(519, 37, 480, 650);
        
        NSDictionary* root = [GameCtl sharedGameCtl].m_difGameSceneDic;
        //photos group stage nums
        NSArray* stageAry = [root objectForKey:@"stages"];
        if(iStage <0||iStage >= [stageAry count])
            iStage =0;
        NSArray* stage = [stageAry objectAtIndex:iStage];
        
        m_itotalLevel = [stage count];

        //read No.stage answers an No.photo
        NSDictionary* iCurItem = [stage objectAtIndex:(m_iCurLevel)];
        m_answersPointAry = [[NSMutableArray alloc]init];
        NSArray* answers   =[iCurItem objectForKey:@"answers"];
        for(NSDictionary* item in answers)
        {
            [m_answersPointAry addObject:item];
        }

        m_layer = layer;
        
        [self drawPhoto];
        [self drawProcessBar];
        [self drawStar];
        
        
	}
	return self;
}


-(void) openStar
{
    if(m_openStarNum <[m_starIcon count])
    {
        CCSprite* star = [m_starIcon objectAtIndex:m_openStarNum];
        [self addChild:star];
        m_openStarNum++; 
    }
    
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
    
    
    
    //[m_layer setSocre];
    
    for(NSDictionary* item in m_answersPointAry)
    {
        NSString* strx = [item objectForKey:@"x"];
        NSString* stry = [item objectForKey:@"y"];
        CGFloat x1 = strx.floatValue+26;
        CGFloat y1 = 650-stry.floatValue+37;
		CGFloat x2 = strx.floatValue+519;
        CGFloat y2 = 650-stry.floatValue+37;
        if(((fabs(touchLocation.x - x1)*fabs(touchLocation.x - x1) + fabs(touchLocation.y - y1)*fabs(touchLocation.y - y1)) < 55*55)
		   || ((fabs(touchLocation.x - x2)*fabs(touchLocation.x - x2) + fabs(touchLocation.y - y2)*fabs(touchLocation.y - y2)) < 55*55))
            
        {
            [self openStar];
            //run action
            CCAnimation* anim = [CCAnimation animationWithFile:@"touch frame" frameCount:12 delay:0.02f];
            CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
            CCSprite* touchFrame1 = [CCSprite spriteWithFile:@"360rb.png"];
			CCSprite* touchFrame2 = [CCSprite spriteWithFile:@"360rb.png"];
            [self addChild:touchFrame1];
			[self addChild:touchFrame2];
            [touchFrame1 setPosition:ccp(x1,y1)];
			[touchFrame2 setPosition:ccp(x2,y2)];
            CCSequence* seq = [CCSequence actions:animate,[CCCallFunc actionWithTarget:self selector:@selector(showTouchFrame)], nil];
            [touchFrame1 runAction:seq];
			[touchFrame2 runAction:seq];
            
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
-(void) showTouchFrame
{
    
}
@end
