//
//  RemoteTorrent.h
//  Deluge Remote
//
//  Created by Yannis on 07/06/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NMSSH/NMSSH.h>

@interface RemoteTorrent : NSObject

@property NSString *type;
@property NMSSHSession *session;
@property NSObject *taskObject;
@property NSDictionary *torrentProperties;

- (id)initWithArray:(NSArray *)array;
- (id)initWithFileURL:(NSURL *)fileURL;
- (id)initWithMagnetLink:(NSURL *)magnetURL;
- (BOOL)execute;

@end
