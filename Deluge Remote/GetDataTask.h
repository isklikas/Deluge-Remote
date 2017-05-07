//
//  GetDataTask.h
//  Deluge Remote
//
//  Created by Yannis on 01/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "TorrentTask.h"

@interface GetDataTask : TorrentTask

- (NSString *)getStatus;
- (NSDictionary *)clientDefaults;

@end
