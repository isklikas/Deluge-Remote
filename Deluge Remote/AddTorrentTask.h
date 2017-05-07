//
//  AddTorrentTask.h
//  Deluge Remote
//
//  Created by Yannis on 01/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "TaskWithOptions.h"

@interface AddTorrentTask : TaskWithOptions

- (BOOL)addTorrentFileTask:(id)torrent;
- (BOOL)addTorrentFilesTask:(NSArray *)torrents;
- (BOOL)addTorrentLinkTask:(id)torrentURL;
- (BOOL)addTorrentMagnetTask:(NSURL *)magnetURL;

@end
