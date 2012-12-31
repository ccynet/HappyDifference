//
//  GameCenterKit.m
//  HappyDifference
//
//  Created by zzyy on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameCenterKit.h"
#import "GameCtl.h"


@implementation GKMatchmakerViewController (LandscapeOnly)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { 
    return ( UIInterfaceOrientationIsLandscape( UIInterfaceOrientationLandscapeLeft ) );
}

@end

@implementation GameCenterKit

@synthesize m_gameCenterAvailable;
@synthesize m_presentingViewController;
@synthesize m_match;
@synthesize m_delegate;
@synthesize m_playersDict;
@synthesize m_otherPlayerName;


static GameCenterKit*   _sharedGameCenterKit = nil;
//创建一个单例类来管理所有与Game Center相关的代码.
//当单例对象创建的时候，它会注册“authentication changed” notification。
//游戏将调用单例对象上的一个方法来认证用户。
//不管什么时候用户被认证（或登出），“authentication changed”回调将会触发。
//这个回调将会追踪用户当前是否被认证。

+(GameCenterKit*) sharedInstance
{
    if(!_sharedGameCenterKit)
    {
        _sharedGameCenterKit = [[GameCenterKit alloc]init];
    }
    return _sharedGameCenterKit;
}

-(BOOL) isGameCenterAvailable
{
    //check for presence of GKLocalPlayer Api
    Class gcClass = NSClassFromString(@"GKLocalPlayer");
    
    //check if the device is running iOS 4.1 or later
    NSString* reqSysVer = @"4.1";
    NSString* curSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL    osVersionSupported = ([curSysVer compare:reqSysVer
                                            options:NSNumericSearch]
                                  != NSOrderedAscending);
    return (gcClass && osVersionSupported);
}
-(id)init
{
    if ((self = [super init])) {
        m_gameCenterAvailable = [self isGameCenterAvailable];
        if (m_gameCenterAvailable) {
            //在尝试认证用户之前，注册这个通告灰常重要，这样，当认证完成的时候，它就会被调用。
            NSNotificationCenter* notify = [NSNotificationCenter defaultCenter];
            [notify addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
    }
    return self;
}
//用户认证状态改变的时候应该得到通知
//它只是简单地判断用户是否被认证，并且相应地更新标记变量。
-(void) authenticationChanged
{
    if ([GKLocalPlayer localPlayer].isAuthenticated && !m_userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        m_userAuthenticated = TRUE;
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && m_userAuthenticated)
    {
        NSLog(@"Authentication changed : player not authenticated.");
        m_userAuthenticated = FALSE;
    }
}
//认证本地用户
-(void) authenticateLocalLocalUser
{
    if (!m_gameCenterAvailable) {
        return;
    }
    
    NSLog(@"Authenticating local user....");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        //来认证用户
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil]; 
    }
    else
    {
        NSLog(@"Already authenicated!");
    }
}
//Matchmaker
//一种是编程来主动查找，另一种是使用内置的matchmaking接口。
//内置的matchmaking接口
-(void) findMatchWithMinPlayers:(int) minPlayers maxPlayers:(int)maxPlayers 
                 viewController:(UIViewController*) viewController
                       delegate:(id<GameCenterKitDelegate>) theDelegate
{
    if(!m_gameCenterAvailable)
        return;
    //add every time auth one more time
    [self authenticateLocalLocalUser];
    m_matchStarted = NO;
    m_match = nil;
    //存储视图控制器和代码
    m_presentingViewController = viewController;
    //同时把代理设置为GameCenterKit对象
    m_delegate = theDelegate;
    //还要销毁前面已经出现的任何模态视图控制器
    [m_presentingViewController dismissModalViewControllerAnimated:NO];
    
    GKMatchRequest* request = [[[GKMatchRequest alloc]init]autorelease];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    //显示gamecenter 匹配界面
    GKMatchmakerViewController* mmvc = [[[GKMatchmakerViewController alloc]initWithMatchRequest:request]autorelease];
    mmvc.matchmakerDelegate = self;
    [m_presentingViewController presentModalViewController:mmvc animated:YES];
}
// Add new method after authenticationChanged
- (void)lookupPlayers {
    
    NSLog(@"Looking up %d players...", m_match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:m_match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            m_matchStarted = NO;
            [m_delegate matchEnded];
        } else {
            
            // Populate players dict
            self.m_playersDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players) {
                NSLog(@"Found player: %@", player.alias);
                m_otherPlayerName = [NSString stringWithString:player.alias];
                [m_playersDict setObject:player forKey:player.playerID];
            }
            m_matchStarted = YES;
            [m_delegate matchStarted];
        }
    }];
    
}
//定义一些界面代理方法
//GKMatchmakerViewControllerDelegate start
//The user has cancelled matchmaking
//如果用户取消查找match或者查找过程中出现了错误的话，那么我们需要关闭matchmaker 视图
-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [m_presentingViewController dismissModalViewControllerAnimated:YES];
    [[GameCtl sharedGameCtl] backMainMenuScene];
}


//Matchmaking has failed with an error
-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [m_presentingViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match:%@", error.localizedDescription);
    [[GameCtl sharedGameCtl] backMainMenuScene];

}
//如果找到一个match的话，我们需要隐藏此对象，并且设置match的delegate为GameCenterKit对象
//A peer-to-peer match has been found, the game should start
-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    //隐藏此对象
    [m_presentingViewController dismissModalViewControllerAnimated:YES];
    m_match = match;
    //delegate为GameCenterKit对象
    m_match.delegate = self;
    //match对象保存了仍然需要多少个玩家才能完成连接
    int num = m_match.expectedPlayerCount;
    if(!m_matchStarted && m_match.expectedPlayerCount == 0)
    {
        NSLog(@"Ready to start match!");
        [self lookupPlayers];
    }
}
//end

// GKMatchDelegate回调函数实现 start
//The match received data sent from the player.
//这个方法是在其他玩家给你发送数据的时候被调用的
-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    if(m_match != match)
        return;
    //cocos2d layer会实现此代码
    [m_delegate match:match didReceiveData:data fromPlayer:playerID];
    //end
}
//是当有玩家接入的时候，你需要检测是否所有的玩家都已经就绪了。同时，当有玩家断开连接的时候，这个方法也会被调用。
//The player state changed(eg. connected or disconnected)
-(void)match:(GKMatch*)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    if(m_match != match)
        return;
    
    switch (state) {
        case GKPlayerStateConnected:
            //handle new player connection.
            NSLog(@"Player connected!");
            if (!m_matchStarted && match.expectedPlayerCount ==0)
            {
                NSLog(@"Ready to start match!");
                [self lookupPlayers];
            }
            break;
        case GKPlayerStateDisconnected:
            // a player just disconnected.
            NSLog(@"Player disconnected!");
            m_matchStarted = NO;
            [m_delegate matchEnded];
        default:
            break;
    }
}
//最后两个方法是发生错误的时候被调用。任何一种情形，都把match标记为已经结束了，同时通知delegate对象
//The match vas unable to connect with the player due to an error.
-(void)match:(GKMatch *)match connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error
{
    if(m_match != match)
        return;
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    m_matchStarted = NO;
    [m_delegate matchEnded];
}
//The match vas unable to be established vith any players due to an error.
-(void)match:(GKMatch *)match didFailWithError:(NSError *)error
{
    if(m_match != match)
        return;
    NSLog(@"Match failed with error:%@", error.localizedDescription);
    m_matchStarted = NO;
    [m_delegate matchEnded];
}
//GKMatchDelegate回调函数实现 end
-(void)dealloc
{
    [super dealloc];
}
@end
