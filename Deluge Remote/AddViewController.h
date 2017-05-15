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
#import "AddViewDirectoryController.h"

@interface AddViewController : UITableViewController

@property RemoteManager *remoteManager;
@property (strong) NSDictionary *propertiesOnAppear;
@property NSIndexPath *idPathOnAppear;
@property NSDictionary *clientDefaults;
@property NSMutableDictionary *manifestedProperties;
@property NSMutableDictionary *stepperValues;

@end

@interface UITableViewCell (CellEnabler)

- (void)enable:(BOOL)on;
- (void)appearClearly:(BOOL)on;

@end
