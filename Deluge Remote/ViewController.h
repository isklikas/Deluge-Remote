//
//  ViewController.h
//  Deluge Remote
//
//  Created by Yannis on 27/03/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import "KeychainController.h"
#import "RemoteManager.h"
#import "TaskManager.h"
#import "AddViewController.h"

@interface ViewController : UIViewController

@property RemoteManager *remoteManager;

+ (NSArray *) remainingTasks;
+ (void) addTask:(NSURL *)task;
- (void)respondToTorrent;

@end

