//
//  AddTorrentTask.m
//  Deluge Remote
//
//  Created by Yannis on 01/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "AddTorrentTask.h"

@implementation AddTorrentTask

- (void) writeToTaskScript {
    [super writeToTaskScript];
}

- (id) executeTask {
    id execTask = [super executeTask];
    return execTask;
}

- (void) cleanUp {
    [super cleanUp];
}

- (BOOL)addTorrentFileTask:(id)torrent {
    BOOL success = TRUE;
    return success;
}

- (BOOL)addTorrentFilesTask:(NSArray *)torrents {
    BOOL success = TRUE;
    return  success;
}

- (BOOL)addTorrentLinkTask:(id)torrentURL {
    BOOL success = TRUE;
    return  success;
}

- (BOOL)addTorrentMagnetTask:(NSURL *)magnetURL {
    NSString *magnetString = [magnetURL absoluteString];
    self.cmdString = [NSString stringWithFormat:@"magnetlink = \"%@\" \n    client.core.add_torrent_magnet(magnetlink,[ENTER_PYDICT_HERE]).addCallback(on_get_status)",magnetString];
    [self writeToTaskScript];
    NSString *status = [self executeTask];
    [self cleanUp];
    BOOL success = FALSE;
    if (status) {
        success = TRUE;
    }
    return success;
}

@end
