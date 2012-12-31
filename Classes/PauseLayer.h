//
//  PauseLayer.h
//  HappyDifference
//
//  Created by zzyy on 11-11-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

@class ClassicDifGameLayer;
@interface PauseLayer : CCLayerColor {
    ClassicDifGameLayer*      m_layer;
    
    CCMenuItemImage*    m_soundOpen;
    CCMenuItemImage*    m_soundOff;
}
-(id) initWithLayer:(ClassicDifGameLayer*) layer;
@end
