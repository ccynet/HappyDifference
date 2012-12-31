//
//  DifGameLayerBase.m
//  HappyDifference
//
//  Created by zzyy on 11-12-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
@implementation CCAnimation(Helper)
+(CCAnimation*) animationWithFile:(NSString*)name frameCount:(int)frameCount delay:(float)delay
{
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
    for(int i =0; i<frameCount; i++)
    {
        NSString* file = [NSString stringWithFormat:@"%drb.png",30*(i+1)];
        CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:file];
        
        CGSize texSize = texture.contentSize;
        CGRect texRect = CGRectMake(0, 0, texSize.width, texSize.height);
        CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:texRect];
        [frames addObject:frame];
    }
    return [CCAnimation animationWithName:name delay:delay frames:frames];
}
@end
#import "DifGameLayerBase.h"
#import "SimpleAudioEngine.h"
#import "GameCtl.h"

@implementation DifGameLayerBase

@synthesize m_iCurLevel,m_iCurStage;

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
-(void) drawPhoto
{
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
    
    CCSprite* leftsprite = [CCSprite spriteWithTexture:orgTex];
    CCSprite* rightsprite = [CCSprite spriteWithTexture:orgTex];
    
    [self addChild:leftsprite];
    [self addChild:rightsprite];
    [leftsprite setAnchorPoint:CGPointMake(0, 0)];
    [rightsprite setAnchorPoint:CGPointMake(0, 0)];
    
    [leftsprite setPosition:CGPointMake(0, 0)];
    [rightsprite setPosition:CGPointMake(m_orgImageWith+m_midLength, 0)];
    
    //touch range
    m_touchRectLeft = CGRectMake(0, 0, m_orgImageWith, orgImageHeigh);
    m_touchRectright = CGRectMake(m_orgImageWith+m_midLength, 0, 2*m_orgImageWith+m_midLength, orgImageHeigh);
}
-(void) drawbk
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //draw bkg
    CCSprite* bkg = [CCSprite spriteWithFile:@"AboutBg.png"];
    [self addChild:bkg];
    [bkg setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
}
-(void) drawProcessBar
{
    CCSprite* top = [CCSprite spriteWithFile:@"top.png"];
    [self addChild:top];
    [top setAnchorPoint:ccp(0, 0)];
    [top setPosition:ccp(0, 768-80)];
    
    CCSprite*   barBk = [CCSprite spriteWithFile:@"pbarbk.png"];
    [self addChild:barBk];
    [barBk setPosition:CGPointMake(562, 746)];
    
    CCProgressTimer* bar = [CCProgressTimer progressWithFile:@"pbar.png"];
    bar.type = kCCProgressTimerTypeHorizontalBarLR;
    [self addChild:bar z:0 tag:tag_pbar];
    [bar setPosition:CGPointMake(552, 746)];
    bar.percentage =100; 
    
    [self schedule:@selector(updateBar) interval:0.5];
}
-(void) drawStar
{
    //draw star bk
#define SX 46
#define SY 723
#define starNum 5
    //player
    CCSprite* player = [CCSprite spriteWithFile:@"player1.png"];
    [self addChild:player];
    //[top setAnchorPoint:ccp(0, 0)];
    [player setPosition:ccp(20, 743)];
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
    
    [[CCTextureCache sharedTextureCache]removeUnusedTextures];
    
    [super dealloc];
}
-(id) initWithStage:(int)iStage andLevel:(int) iLevel
{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        
        NSDictionary* GameCtlRoot = [GameCtl sharedGameCtl].m_difGameSceneDic;
        //photos group stage nums
        NSArray* stageAry = [GameCtlRoot objectForKey:@"stages"];
        m_itotalStage = [stageAry count];
        NSArray* stage = [stageAry objectAtIndex:m_iCurStage];
        m_itotalLevel = [stage count];
        
        m_iCurStage = iStage%m_itotalStage;
        m_iCurLevel = iLevel%m_itotalLevel;
        
        [self drawPhoto];
        [self drawStar];
	}
	return self;
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
-(id) initWithReadyGo:(int) iCurStage andLevel:(int) iLevel
{
    if( (self=[super init] )) {
        [self initWithStage:iCurStage andLevel:iLevel];
        [self drawReadyGoLayer];
	}
	return self;
}
-(void) removeMaskedLayer
{
    [self removeChild:m_maskedReadyGoLayer cleanup:YES];
    [self drawProcessBar];

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
            //open star
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

@end
