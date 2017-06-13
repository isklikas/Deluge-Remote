//
//  RemoteManager.h
//  Deluge Remote
//
//  Created by Yannis on 27/03/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NMSSH/NMSSH.h>
#import <Security/Security.h>
#import "KeychainController.h"
#import "GetDataTask.h"


@interface RemoteManager : NSObject
@property (retain) NMSSHSession *session;
@property (retain) NSString *homeLocation;

- (id) initWithConnection;
- (void) connect;
- (void)setUpPass;
- (void)endConnection;
- (NSArray *)directoriesInLocation:(NSString *)location;
- (NSString *)getStatus;
- (NSArray *)getRunningTorrents;
- (NSDictionary *)clientDefaults;
- (NSDictionary *)getCellDataforTorrentID:(NSString *)torrentID;
@end
