//
//  TaskManager.m
//  Deluge Remote
//
//  Created by Yannis on 31/03/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "TaskManager.h"

@implementation TaskManager

+ (instancetype)sharedInstance {
    static TaskManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TaskManager alloc] init];
    });
    return sharedInstance;
}


@end
