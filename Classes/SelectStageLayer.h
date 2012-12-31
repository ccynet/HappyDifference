//
//  SelectStageLayer.h
//  HappyDifference
//
//  Created by zzyy on 11-11-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "CCScrollLayer.h"

@interface SelectStageLayer : CCLayer <CCScrollLayerDelegate>{
    int m_iCurScrollPage;
    NSMutableArray* m_bkImages;
	NSMutableArray* m_stageAryNUM;
}

@end
