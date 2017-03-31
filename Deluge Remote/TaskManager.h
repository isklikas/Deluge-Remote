//
//  TaskManager.h
//  Deluge Remote
//
//  Created by Yannis on 31/03/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskManager : NSObject

@property (nonatomic) NSMutableArray *remainingTasks;
+ (instancetype)sharedInstance;
- (NSMutableArray *)remTasks;

- (void)addItemsObserver:(id)object;
- (void)removeItemsObserver:(id)object;

@end
