//
//  FailedScene.m
//  HappyDifference
//
//  Created by zzyy on 11-12-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FailedScene.h"


@implementation FailedScene
-(void)dealloc
{
    [self removeAllChildrenWithCleanup:YES];

    [super dealloc];
}
-(id)init
{
    if ((self = [super init])) {
        
    }
        return self;
}
@end
