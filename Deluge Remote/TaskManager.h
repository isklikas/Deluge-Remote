//
//  TaskManager.h
//  Deluge Remote
//
//  Created by Yannis on 31/03/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskManager : NSObject

@property (retain) NSMutableArray *remainingTasks;
+ (instancetype)sharedInstance;
@end
