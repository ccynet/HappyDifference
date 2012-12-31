//
//  ClassicDifGameLayer.h
//  HappyDifference
//
//  Created by zzyy on 11-10-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "DifGameLayerBase.h"



@class PauseLayer;
@interface ClassicDifGameLayer : DifGameLayerBase {

    PauseLayer*         m_pauseLayer;
}
-(id) initWithStage:(int)iStage andLevel:(int) iLevel;
-(id) initWithReadyGo:(int) iCurStage andLevel:(int) iLevel;
-(void) pause;
-(void) resume;



@end

