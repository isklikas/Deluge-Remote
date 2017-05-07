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
    if (_maxConnections)
        [activeProperties addEntriesFromDictionary:@{@"max_connections":_maxConnections}];
    if (_maxUploadSlots)
        [activeProperties addEntriesFromDictionary:@{@"max_upload_slots":_maxUploadSlots}];
    if (_maxUploadSpeed)
        [activeProperties addEntriesFromDictionary:@{@"max_upload_speed":_maxUploadSpeed}];
    if (_maxDownloadSpeed)
        [activeProperties addEntriesFromDictionary:@{@"max_download_speed":_maxDownloadSpeed}];
    if (_prioritizedFirstLast)
        [activeProperties addEntriesFromDictionary:@{@"prioritize_first_last_pieces":_prioritizedFirstLast}];
    if (_sequentialDownload)
        [activeProperties addEntriesFromDictionary:@{@"sequential_download":_sequentialDownload}];
    if (_compactAllocation)
        [activeProperties addEntriesFromDictionary:@{@"compact_allocation":_compactAllocation}];
    if (_downloadLocation)
        [activeProperties addEntriesFromDictionary:@{@"download_location":_downloadLocation}];
    if (_autoManaged)
        [activeProperties addEntriesFromDictionary:@{@"auto_managed":_autoManaged}];
    if (_stopSeedAtRatio)
        [activeProperties addEntriesFromDictionary:@{@"stop_at_ratio":_stopSeedAtRatio}];
    if (_stopSeedRatio)
        [activeProperties addEntriesFromDictionary:@{@"stop_ratio":_stopSeedRatio}];
    if (_removeAtMaxRatio)
        [activeProperties addEntriesFromDictionary:@{@"remove_at_ratio":_removeAtMaxRatio}];
    if (_moveWhenComplete)
        [activeProperties addEntriesFromDictionary:@{@"move_completed":_moveWhenComplete}];
    if (_moveWhenCompletePath)
        [activeProperties addEntriesFromDictionary:@{@"move_completed_path":_moveWhenCompletePath}];
    if (_addAsPaused)
        [activeProperties addEntriesFromDictionary:@{@"add_paused":_addAsPaused}];
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
