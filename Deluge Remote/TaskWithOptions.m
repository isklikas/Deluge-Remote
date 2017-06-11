//
//  TaskWithOptions.m
//  Deluge Remote
//
//  Created by Yannis on 01/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "TaskWithOptions.h"

@implementation TaskWithOptions

- (void) writeToTaskScript {
    NSString *cmdWithoutOptions = self.cmdString;
    NSDictionary *activeProperties = [self getActiveProperties];
    NSString *pyDict = [self castToPyStringForActiveProperties:activeProperties];
    NSString *newCmdString = [cmdWithoutOptions stringByReplacingOccurrencesOfString:@"[ENTER_PYDICT_HERE]" withString:pyDict];
    self.cmdString = newCmdString;
    [super writeToTaskScript];
}

- (id) executeTask {
    id execTask = [super executeTask];
    return execTask;
}

- (NSDictionary *)getActiveProperties {
    NSMutableDictionary *activeProperties = [NSMutableDictionary new];
    if (_max_connections)
        [activeProperties addEntriesFromDictionary:@{@"max_connections":_max_connections}];
    if (_max_upload_slots)
        [activeProperties addEntriesFromDictionary:@{@"max_upload_slots":_max_upload_slots}];
    if (_max_upload_speed)
        [activeProperties addEntriesFromDictionary:@{@"max_upload_speed":_max_upload_speed}];
    if (_max_download_speed)
        [activeProperties addEntriesFromDictionary:@{@"max_download_speed":_max_download_speed}];
    if (_prioritize_first_last_pieces)
        [activeProperties addEntriesFromDictionary:@{@"prioritize_first_last_pieces":_prioritize_first_last_pieces}];
    if (_sequential_download)
        [activeProperties addEntriesFromDictionary:@{@"sequential_download":_sequential_download}];
    if (_compact_allocation)
        [activeProperties addEntriesFromDictionary:@{@"compact_allocation":_compact_allocation}];
    if (_download_location)
        [activeProperties addEntriesFromDictionary:@{@"download_location":_download_location}];
    if (_auto_managed)
        [activeProperties addEntriesFromDictionary:@{@"auto_managed":_auto_managed}];
    if (_stop_at_ratio)
        [activeProperties addEntriesFromDictionary:@{@"stop_at_ratio":_stop_at_ratio}];
    if (_stop_ratio)
        [activeProperties addEntriesFromDictionary:@{@"stop_ratio":_stop_ratio}];
    if (_remove_at_ratio)
        [activeProperties addEntriesFromDictionary:@{@"remove_at_ratio":_remove_at_ratio}];
    if (_move_completed)
        [activeProperties addEntriesFromDictionary:@{@"move_completed":_move_completed}];
    if (_move_completed_path)
        [activeProperties addEntriesFromDictionary:@{@"move_completed_path":_move_completed_path}];
    if (_add_paused)
        [activeProperties addEntriesFromDictionary:@{@"add_paused":_add_paused}];
    if (_shared)
        [activeProperties addEntriesFromDictionary:@{@"shared":_shared}];
    return [activeProperties copy];
}

- (NSString *) castToPyStringForActiveProperties:(NSDictionary *)activeProperties {
    NSArray *activeKeys = [activeProperties allKeys];
    NSString *pyDictString = @"{";
    for (NSString *dictKey in activeKeys) {
        NSString *valueAsString;
        if ([dictKey isEqualToString:@"prioritize_first_last_pieces"] || [dictKey isEqualToString:@"sequential_download"] || [dictKey isEqualToString:@"compact_allocation"] || [dictKey isEqualToString:@"auto_managed"] || [dictKey isEqualToString:@"stop_at_ratio"] || [dictKey isEqualToString:@"remove_at_ratio"] || [dictKey isEqualToString:@"move_completed"] || [dictKey isEqualToString:@"add_paused"] || [dictKey isEqualToString:@"shared"]) {
            BOOL value = [activeProperties objectForKey:dictKey];
            if (value) {
                valueAsString = @"True";
            } else {
                valueAsString = @"False";
            }
        }
        else {
            NSNumber *value = [activeProperties objectForKey:dictKey];
            valueAsString = [NSString stringWithFormat:@"%@", value];
        }
        NSString *pyDictEntry = [NSString stringWithFormat:@"\"%@\":\"%@\"", dictKey, valueAsString];
        pyDictString = [pyDictString stringByAppendingString:pyDictEntry];
        NSInteger indexOfKey = [activeKeys indexOfObject:dictKey];
        if (indexOfKey != activeKeys.count-1) {
            pyDictString = [pyDictString stringByAppendingString:@","];
        }
    }
    pyDictString = [pyDictString stringByAppendingString:@"}"];
    return pyDictString;
}

- (void) cleanUp {
    [super cleanUp];
}

@end
