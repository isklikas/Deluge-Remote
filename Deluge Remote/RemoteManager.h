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

@interface RemoteManager : NSObject
@property (retain) NMSSHSession *session;
@property (retain) NSString *homeLocation;

- (id) initWithConnection;
- (void)setUpPass;
- (void)endConnection;
- (void)getStatus;

@end
