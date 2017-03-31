//
//  ViewController.m
//  Deluge Remote
//
//  Created by Yannis on 27/03/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "ViewController.h"
#import "Deluge_Remote-Swift.h"

@interface ViewController ()

@end

@implementation ViewController


+ (NSArray *) remainingTasks {
    TaskManager *tManager = [TaskManager sharedInstance];
    return tManager.remainingTasks;
}

+ (void) addTask:(NSURL *)task {
    TaskManager *tManager = [TaskManager sharedInstance];
    NSMutableArray *tasks = [NSMutableArray arrayWithArray:tManager.remainingTasks];
    [tasks addObject:task];
    tManager.remainingTasks = tasks;
    if (tManager.controlInstance) {
        [(ViewController *)tManager.controlInstance respondToTorrent];
    }
}

- (void)respondToTorrent {
    NSLog(@"YIPEEEEE");
}

- (void)viewWillAppear:(BOOL)animated {
    TaskManager *tMan = [TaskManager sharedInstance];
    tMan.controlInstance = self;
    
    if ([ViewController remainingTasks].count >0) {
        [self respondToTorrent];
    }
    NSError *error;
    NSArray *passwordItems = [KeychainPasswordItem passwordItemsForService:@"com.isklikas.Deluge-Remote" accessGroup:nil error:&error];
    if (passwordItems.count == 0 || [[NSUserDefaults standardUserDefaults] stringForKey:@"serverAddress"] == nil || [[NSUserDefaults standardUserDefaults] stringForKey:@"delugeHomeLocation"] == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        KeychainController * vc = (KeychainController *)[sb instantiateViewControllerWithIdentifier:@"KeychainController"];
        [self.navigationController pushViewController:vc animated:FALSE];
    }
    else {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            RemoteManager *mngr = [[RemoteManager alloc] initWithConnection];
            [mngr getStatus];
            [mngr endConnection];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    TaskManager *tManager = [TaskManager sharedInstance];
    tManager.controlInstance = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
