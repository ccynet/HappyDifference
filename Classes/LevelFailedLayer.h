//
//  LevelFailedLayer.h
//  HappyDifference
//
//  Created by zzyy on 11-11-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

@class ClassicDifGameLayer;

@interface LevelFailedLayer : CCLayerColor {
    ClassicDifGameLayer*      m_layer;

}
-(id) initWithLayer:(ClassicDifGameLayer*) layer;

@end
