//
//  DifGameNode.h
//  HappyDifference
//
//  Created by zzyy on 11-11-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

@class DifGameLayer;
@interface DifGameNode : CCNode {
    
    int                m_iCurStage;
    int                m_iCurLevel;
    int                m_itotalLevel;
    NSDictionary*      m_iCuritem;
    
    CGRect             m_touchRectLeft;
    CGRect             m_touchRectright;
    NSMutableArray*    m_answersPointAry;
    NSMutableArray*    m_starIcon;
    int                m_openStarNum;
    DifGameLayer*      m_layer;
    
    
    
    
}
-(id) initWithStage:(int)iStage level:(int)iLevel andLayer:(DifGameLayer*) layer;
-(void) openStar;
@end
