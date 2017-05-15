//
//  AddViewDirectoryController.h
//  Deluge Remote
//
//  Created by Yannis on 09/05/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"
#import "RADataObject.h"
#import "RATableViewCell.h"
#import "RemoteManager.h"

@interface AddViewDirectoryController : UIViewController <RATreeViewDataSource, RATreeViewDelegate>

@property NSString *editingProperty;
@property UIViewController *parent;
@property RemoteManager *remoteManager;
@property NSString *rootDir;
@property NSInteger rootLevel;
@property (strong, nonatomic) NSArray *rootItems;
@property NSArray *data;
@property (strong, nonatomic) RATreeView *treeView;
// <indexPath> => @(YES) or nil.
@property (strong, nonatomic) NSMutableDictionary *expandedItems;
@property RADataObject *selectedItem;


@end
