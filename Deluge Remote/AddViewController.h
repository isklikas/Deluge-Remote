//
//  AddViewController.h
//  Deluge Remote
//
//  Created by Yannis on 02/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteManager.h"
#import "ClientPropertyCell.h"
#import "StepperPropertyCell.h"
#import "SwitchPropertyCell.h"

@interface AddViewController : UITableViewController

@property RemoteManager *remoteManager;
@property NSDictionary *clientDefaults;
@property NSMutableDictionary *manifestedProperties;
@property NSMutableDictionary *stepperValues;

@end

@interface UITableViewCell (CellEnabler)

- (void)enable:(BOOL)on;
- (void)appearClearly:(BOOL)on;

@end
