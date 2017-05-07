//
//  TorrentTask.h
//  Deluge Remote
//
//  Created by Yannis on 01/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NMSSH/NMSSH.h>

@interface TorrentTask : NSObject

@property NSString *cmdString;
@property NSString *pyName;
@property NSNumber *writeIndex;
@property NMSSHSession *session;

- (void) writeToTaskScript;
- (id) executeTask;
- (void) cleanUp;

@end
