//
//  GameCenterKit.h
//  HappyDifference
//
//  Created by zzyy on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <GameKit/GameKit.h>


@interface GKMatchmakerViewController(LandscapeOnly)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end


//内置的matchmaking接口
//游戏逻辑部份实现该协议
@protocol GameCenterKitDelegate

-(void) matchStarted;
-(void) matchEnded;
-(void) match:(GKMatch*)match 
        didReceiveData:(NSData*)data
        fromPlayer:(NSString *)playerID;
@end
//end
@interface GameCenterKit : NSObject <GKMatchmakerViewControllerDelegate,GKMatchDelegate>
{
    BOOL    m_gameCenterAvailable;
    BOOL    m_userAuthenticated;
    
    //内置的matchmaking接口
    UIViewController*   m_presentingViewController;
    GKMatch*            m_match;
    BOOL                m_matchStarted;
    id<GameCenterKitDelegate>   m_delegate;
    //end
    
    //playerlist
    // Add inside @interface
    NSMutableDictionary*    m_playersDict;
    NSString*               m_otherPlayerName;
    

}

+(GameCenterKit*) sharedInstance;
-(void) authenticateLocalLocalUser;

//内置的matchmaking接口
-(void) findMatchWithMinPlayers:(int) minPlayers maxPlayers:(int)maxPlayers 
                 viewController:(UIViewController*) viewController
                       delegate:(id<GameCenterKitDelegate>) theDelegate;
//end

@property(assign, readonly) BOOL    m_gameCenterAvailable;
@property(retain)   UIViewController* m_presentingViewController;
@property(retain)   GKMatch*        m_match;
@property(assign)   id<GameCenterKitDelegate> m_delegate;

// Add after @interface
@property (retain) NSMutableDictionary *m_playersDict;
@property (retain) NSString*            m_otherPlayerName;

@end
