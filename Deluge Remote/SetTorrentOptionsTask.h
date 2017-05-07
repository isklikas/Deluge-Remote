//
//  SetTorrentOptionsTask.h
//  Deluge Remote
//
//  Created by Yannis on 01/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "TaskWithOptions.h"

@interface SetTorrentOptionsTask : TaskWithOptions

- (BOOL)setOptionsForTorrents:(NSArray *)torrents; //set_torrent_options(torrent_ids, options)

@end
