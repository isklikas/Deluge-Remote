//
//  SetTorrentOptionsTask.m
//  Deluge Remote
//
//  Created by Yannis on 01/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "SetTorrentOptionsTask.h"

@implementation SetTorrentOptionsTask

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

- (BOOL)setOptionsForTorrents:(NSArray *)torrents {
    BOOL success = TRUE;
    return success;
}

@end
