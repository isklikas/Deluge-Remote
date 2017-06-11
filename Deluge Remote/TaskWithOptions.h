//
//  TaskWithOptions.h
//  Deluge Remote
//
//  Created by Yannis on 01/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "TorrentTask.h"

/*
 
 options_conf_map = {
 "max_connections": "max_connections_per_torrent",
 "max_upload_slots": "max_upload_slots_per_torrent",
 "max_upload_speed": "max_upload_speed_per_torrent",
 "max_download_speed": "max_download_speed_per_torrent",
 "prioritize_first_last_pieces": "prioritize_first_last_pieces",
 "sequential_download": "sequential_download",
 "compact_allocation": "compact_allocation",
 "download_location": "download_location",
 "auto_managed": "auto_managed",
 "stop_at_ratio": "stop_seed_at_ratio",
 "stop_ratio": "stop_seed_ratio",
 "remove_at_ratio": "remove_seed_at_ratio",
 "move_completed": "move_completed",
 "move_completed_path": "move_completed_path",
 "add_paused": "add_paused",
 "shared": "shared"
 }
 
 */

@interface TaskWithOptions : TorrentTask

@property NSNumber *max_connections;
@property NSNumber *max_upload_slots;
@property NSNumber *max_upload_speed;
@property NSNumber *max_download_speed;
@property NSNumber /* as BOOL */ *prioritize_first_last_pieces;
@property NSNumber /* as BOOL */ *sequential_download;
@property NSNumber /* as BOOL */ *compact_allocation;
@property NSString *download_location;
@property NSNumber /* as BOOL */ *auto_managed;
@property NSNumber /* as BOOL */ *stop_at_ratio;
@property NSNumber *stop_ratio;
@property NSNumber /* as BOOL */ *remove_at_ratio;
@property NSNumber /* as BOOL */ *move_completed;
@property NSString *move_completed_path;
@property NSNumber /* as BOOL */ *add_paused;
@property NSNumber /* as BOOL */ *shared;



@end
