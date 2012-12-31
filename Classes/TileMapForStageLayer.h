//
//  TileMapForStageLayer.h
//  HappyDifference
//
//  Created by zzyy on 12-1-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
enum tag
{
    TileMapNode =0,
}TileMapForStageLayer_tag;

@interface TileMapForStageLayer : CCLayer {
    CGPoint m_touchBeganPoint;
}

@end
