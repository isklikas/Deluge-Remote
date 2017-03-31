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
        // Perform other initialisation...
    });
    return sharedInstance;
}

- (NSMutableArray *)remTasks {
    return [self mutableArrayValueForKey:@"_remTasks"];
}

- (void)addItemsObserver:(id)object {
    [self addObserver:object forKeyPath:@"_remTasks.@count" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeItemsObserver:(id)object {
    [self removeObserver:object forKeyPath:@"_remTasks.@count" context:nil];
}

//    You need need to override init method as well, because developer can call [[MyClass alloc]init] method also. that time also we have to return sharedInstance only.


@end
