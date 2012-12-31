//
//  SelectStageWithMovingLayer.h
//  HappyDifference
//
//  Created by zzyy on 12-1-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum
{
    stageBk_tag =0,
}SelectStageWithMovingLayer_tag;

@interface SelectStageWithMovingLayer : CCLayer {
    CGPoint m_touchBeganPoint;
}

@end
