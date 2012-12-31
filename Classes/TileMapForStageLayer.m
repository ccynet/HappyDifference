//
//  TileMapForStageLayer.m
//  HappyDifference
//
//  Created by zzyy on 12-1-2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TileMapForStageLayer.h"


@implementation TileMapForStageLayer
-(id)init
{
    if((self = [super init]))
    {
        self.isTouchEnabled = YES;
        
        CCTMXTiledMap* tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"tilemapforstage.tmx"]; 
        [self addChild:tileMap z:-1 tag:TileMapNode]; 
        CCTMXLayer* eventLayer = [tileMap layerNamed:@"GameEventLayer"]; 
        eventLayer.visible = NO;
    }
    return self;
}
-(void) dealloc
{
    [super dealloc];
}
//将屏幕坐标转换为瓷砖在地图上的坐标
-(CGPoint) tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap 
{
    // 触摸的屏幕坐标必须减去瓷砖地图的坐标 - 万一瓷砖地图位置已经不在(0,0)点上了
    CGPoint pos = ccpSub(location, tileMap.position);
    // 将得到坐标值转换成整数
    pos.x = (int)(pos.x / tileMap.tileSize.width); pos.y = (int)((tileMap.mapSize.height * tileMap.tileSize.height - pos.y) / tileMap.tileSize.height);
    return pos;
}
-(void) centerTileMapOnTileCoord:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap 
{
    // 获取屏幕大小和屏幕中心点
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGPoint screenCenter = CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);
    // 瓷砖的坐标0,0点是在左上角
    tilePos.y = (tileMap.mapSize.height - 1) - tilePos.y;
    // 此变量用于移动瓷砖地图
    CGPoint scrollPosition = CGPointMake(-(tilePos.x * tileMap.tileSize.width), -(tilePos.y * tileMap.tileSize.height));
    // 把得到的scrollPosition加上位移值
    scrollPosition.x += screenCenter.x - tileMap.tileSize.width * 0.5f; 
    scrollPosition.y += screenCenter.y - tileMap.tileSize.height * 0.5f;
    // 确保地图边界和屏幕边界对齐时让地图的移动停止
    scrollPosition.x = MIN(scrollPosition.x, 0);
    scrollPosition.x = MAX(scrollPosition.x, -screenSize.width); 
    scrollPosition.y = MIN(scrollPosition.y, 0); 
    scrollPosition.y = MAX(scrollPosition.y, -screenSize.height);
    CCAction* move = [CCMoveTo actionWithDuration:0.2f position: scrollPosition]; [tileMap stopAllActions]; 
    [tileMap runAction:move];
}
-(CGPoint) locationFromTouch:(UITouch*)touch 
{
    CGPoint touchLocation = [touch locationInView: [touch view]]; 
    return [[CCDirector sharedDirector] convertToGL:touchLocation];
}
-(CGPoint) locationFromTouches:(NSSet*)touches 
{
    return [self locationFromTouch:[touches anyObject]];
}
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    CCNode* node = [self getChildByTag:TileMapNode]; 
    NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
    CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;

    // 由触摸位置信息获取相应瓷砖的坐标
    CGPoint touchLocation = [self locationFromTouches:touches]; 
	m_touchBeganPoint = touchLocation;
    
    //CGPoint tilePos = [self tilePosFromLocation:touchLocation tileMap:tileMap];
    // 移动瓷砖地图,让触摸到的瓷砖处于屏幕中央 
    //[self centerTileMapOnTileCoord:tilePos tileMap:tileMap];
}
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize	screenSize = [CCDirector sharedDirector].winSize;
	
	CGPoint location = [self locationFromTouches:touches]; 
	
	int _detlaX = location.x - m_touchBeganPoint.x;
    int _detlaY = location.y - m_touchBeganPoint.y;
    
    CCNode* node = [self getChildByTag:TileMapNode]; 
    NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
    CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CGPoint scrollPosition;
    scrollPosition.x = tileMap.position.x+_detlaX;
    scrollPosition.y = tileMap.position.y+_detlaY;
    // 确保地图边界和屏幕边界对齐时让地图的移动停止
    scrollPosition.x = MIN(scrollPosition.x, 0);
    scrollPosition.x = MAX(scrollPosition.x, -screenSize.width); 
    scrollPosition.y = MIN(scrollPosition.y, 0); 
    scrollPosition.y = MAX(scrollPosition.y, -screenSize.height);
	tileMap.position = ccp(scrollPosition.x, scrollPosition.y);
    
    m_touchBeganPoint = location;

}
@end
