//
//  GetDataTask.m
//  Deluge Remote
//
//  Created by Yannis on 01/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "GetDataTask.h"

@implementation GetDataTask

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

- (NSString *)getStatus {
    self.cmdString = @"client.core.get_session_status([\"payload_upload_rate\", \"payload_download_rate\"]).addCallback(on_get_status)";
    [self writeToTaskScript];
    NSString *status = [self executeTask];
    [self cleanUp];
    return status;
}

- (NSDictionary *)getCellDataforTorrentID:(NSString *)torrentID {
    //Asks for the data presented on Active Torrent Cells
    //get_torrent_status(torrent_id, keys, diff=False)
    self.cmdString = [NSString stringWithFormat:@"torrentID = \"%@\" \n    client.core.get_torrent_status(torrentID, [\"state\", \"paused\", \"progress\", \"is_finished\", \"total_download\", \"total_upload\", \"all_time_download\", \"total_payload_upload\", \"eta\", \"name\", \"total_size\", \"total_uploaded\"], diff=False).addCallback(on_get_status)",torrentID];
    [self writeToTaskScript];
    NSString *status = [self executeTask];
    NSData *data = [status dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [self cleanUp];
    return dictionary;
}

- (NSArray *)getRunningTorrents {
    //Returns an array of torrent IDs
    self.cmdString = @"client.core.get_session_state().addCallback(on_get_status)";
    [self writeToTaskScript];
    NSString *state = [self executeTask];
    [self cleanUp];
    NSArray *rawState = [state componentsSeparatedByString:@"\""];
    NSMutableArray *runningTorrents = [NSMutableArray new];
    if (rawState.count > 1) {
        for (int i = 1; i < rawState.count; i += 2) {
            NSString *torrentID = rawState[i];
            [runningTorrents addObject:torrentID];
        }
    }
    return [runningTorrents copy];
}

- (NSDictionary *)clientDefaults {
    self.cmdString = @"client.core.get_config_values([\"max_connections\", \"max_upload_slots\", \"max_upload_speed\", \"max_download_speed\", \"prioritize_first_last_pieces\", \"sequential_download\", \"compact_allocation\", \"download_location\", \"auto_managed\", \"stop_at_ratio\", \"stop_ratio\", \"remove_at_ratio\", \"move_completed\", \"move_completed_path\", \"add_paused\", \"shared\"]).addCallback(on_get_status)";
    [self writeToTaskScript];
    NSString *response = [self executeTask];
    NSString *usefulPart = [response componentsSeparatedByString:@"}"][0];
    NSArray *options = [usefulPart componentsSeparatedByString:@","];
    NSMutableDictionary *defaults = [NSMutableDictionary new];
    for (int i = 0; i < options.count; i++) {
        NSString *option = options[i];
        NSArray *intermediate = [option componentsSeparatedByString:@"\""];
        NSString *key = intermediate[1];
        id value;
        if (intermediate.count > 3) { //Values are returned as "key": false, while only strings are returned as "key":"value"
            value = intermediate[3];
        }
        else {
            NSString *tempValue = [option componentsSeparatedByString:@": "][1];
            //If it is a number or a BOOL, it is always here.
            if ([tempValue isEqualToString:@"true"] || [tempValue isEqualToString:@"false"]) {
                BOOL val = [tempValue boolValue];
                value = [NSNumber numberWithBool:val];
            }
            else { //Thus, a number
                float val = [tempValue floatValue];
                value = [NSNumber numberWithFloat:val];
            }
        }
        NSDictionary *pair = @{key:value};
        [defaults addEntriesFromDictionary:pair];
    }
    [self cleanUp];
    return defaults;
}

@end
