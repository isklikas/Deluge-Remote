//
//  AddViewDirectoryController.m
//  Deluge Remote
//
//  Created by Yannis on 09/05/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "AddViewDirectoryController.h"

@interface AddViewDirectoryController ()

@end

@implementation AddViewDirectoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _expandedItems = [NSMutableDictionary new];
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
    treeView.delegate = self;
    treeView.dataSource = self;
    [self.view addSubview:treeView];
    [treeView registerClass:[RATableViewCell class] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
    self.treeView = treeView;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(upButton:)];
    self.navigationItem.rightBarButtonItem = backButton;
    [self setUpForRootPoint];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/" options:NSRegularExpressionCaseInsensitive error:&error];
    NSInteger numberOfMatches = [regex numberOfMatchesInString:self.rootDir options:0 range:NSMakeRange(0, [self.rootDir length])];
    self.rootLevel = numberOfMatches+1;
    // Do any additional setup after loading the view.
}

- (void) setUpForRootPoint {
    NSString *title = [[self.rootDir componentsSeparatedByString:@"/"] lastObject];
    title = title.length > 0 ? title : @"/";
    self.navigationItem.title = title;
    NSArray *dirs = [self.remoteManager directoriesInLocation:self.rootDir];
    self.rootItems = dirs;
    self.data = [self RADataObjectsArrayFromDirArray:dirs];
}

- (NSArray *)RADataObjectsArrayFromDirArray:(NSArray *)dirArray {
    NSMutableArray *tempData = [NSMutableArray new];
    for (NSString *dir in dirArray) {
        RADataObject *dirObject = [RADataObject dataObjectWithName:dir children:nil];
        [tempData addObject:dirObject];
    }
    return [tempData copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 44;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    RADataObject *dataObject = item;
    /**/
    BOOL expanded = [self.treeView isCellForItemExpanded:item];
    if (!expanded) {
        NSString *preExistingDirs = @"";
        BOOL hasParent = TRUE;
        RADataObject *parentObject = item;
        while (hasParent) {
            parentObject = [self.treeView parentForItem:parentObject];
            if (parentObject) {
                NSString *parentDir = [parentObject name];
                parentDir = [parentDir stringByAppendingPathComponent:preExistingDirs];
                preExistingDirs = parentDir;
            }
            else {
                hasParent = FALSE;
            }
        }
        NSString *currentDir = [[self.rootDir stringByAppendingPathComponent:preExistingDirs] stringByAppendingPathComponent:dataObject.name];
        NSArray *dirs = [self.remoteManager directoriesInLocation:currentDir];
        if (dirs.count > 0) {
            NSArray *dataObjectArray = [self RADataObjectsArrayFromDirArray:dirs];
            [dataObject setChildren:dataObjectArray];
            [self.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, dataObjectArray.count - 1)] inParent:dataObject withAnimation:RATreeViewRowAnimationLeft];
            [self.treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
        }
    }
    if ([dataObject isEqual:self.selectedItem]) {
        RATableViewCell *cell = (RATableViewCell *)[self.treeView cellForItem:self.selectedItem];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        _selectedItem = nil;
    }
    else {
        if (![[self.treeView parentForItem:dataObject] isEqual:_selectedItem]) { // If the new selected item isn't a child of the previous, then collapse the previous dir, to expand the current
            if (_selectedItem) {
                [self.treeView collapseRowForItem:_selectedItem collapseChildren:TRUE withRowAnimation:RATreeViewRowAnimationAutomatic];
            }
        }
        RATableViewCell *cell = (RATableViewCell *)[self.treeView cellForItem:self.selectedItem];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell = (RATableViewCell *)[self.treeView cellForItem:dataObject];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        _selectedItem = dataObject;
    }

}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    RADataObject *dataObject = item;
    NSInteger level = [self.treeView levelForCellForItem:item];
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataObject.name level:level];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return data.children[index];
}


- (void)upButton:(id)selector {
    if (self.rootLevel > 0) {
        if (_selectedItem) {
            RATableViewCell *cell = (RATableViewCell *) [self.treeView cellForItem:_selectedItem];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            _selectedItem = nil;
        }
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.rootDir componentsSeparatedByString:@"/"]];
        [arr removeObjectAtIndex:self.rootLevel-1];
        NSString *newTop = [arr componentsJoinedByString:@"/"];
        newTop = newTop.length > 0? newTop: @"/";
        self.rootLevel--;
        self.rootDir = newTop;
        [self setUpForRootPoint];
        [self.treeView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    NSString *currentDir = self.rootDir;
    if (_selectedItem) {
        NSString *preExistingDirs = @"";
        BOOL hasParent = TRUE;
        RADataObject *parentObject = _selectedItem;
        while (hasParent) {
            parentObject = [self.treeView parentForItem:parentObject];
            if (parentObject) {
                NSString *parentDir = [parentObject name];
                parentDir = [parentDir stringByAppendingPathComponent:preExistingDirs];
                preExistingDirs = parentDir;
            }
            else {
                hasParent = FALSE;
            }
        }
        currentDir = [[self.rootDir stringByAppendingPathComponent:preExistingDirs] stringByAppendingPathComponent:_selectedItem.name];
    }
    NSDictionary *manifestedProperties = @{self.editingProperty:currentDir};
    [self.parent setValue:manifestedProperties forKey:@"propertiesOnAppear"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
