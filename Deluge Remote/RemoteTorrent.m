//
//  RemoteTorrent.m
//  Deluge Remote
//
//  Created by Yannis on 07/06/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "RemoteTorrent.h"
#import "Deluge_Remote-Swift.h"

@implementation RemoteTorrent

- (id)initWithArray:(NSArray *)array {
    self = [super init];
    if( !self ) return nil;
    self.type = @"Array";
    self.taskObject = array;
    return self;
}

- (id)initWithFileURL:(NSURL *)fileURL {
    self = [super init];
    if( !self ) return nil;
    self.type = @"File";
    self.taskObject = fileURL;
    return self;
}

- (id)initWithMagnetLink:(NSURL *)magnetURL {
    self = [super init];
    if( !self ) return nil;
    self.type = @"Magnet";
    self.taskObject = magnetURL;
    return self;
}

- (BOOL) execute {
    AddTorrentTask *aTask = [AddTorrentTask new];
    [aTask setValuesForKeysWithDictionary:self.torrentProperties];
    aTask.rTorrent = self;
    aTask.session = _session;
    BOOL success = [aTask addTorrentTask];
    return success;
}

@end
