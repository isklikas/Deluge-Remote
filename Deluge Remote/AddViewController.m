//
//  AddViewController.m
//  Deluge Remote
//
//  Created by Yannis on 02/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "AddViewController.h"
#import "ViewController.h"

@interface AddViewController ()

@end

@implementation UITableViewCell (CellEnabler)

- (void)enable:(BOOL)on {
    self.userInteractionEnabled = on;
    for (UIView *view in self.contentView.subviews) {
        view.userInteractionEnabled = on;
    }
}
- (void)appearClearly:(BOOL)on {
    self.alpha = on ? 1 : 0.4;
    for (UIView *view in self.contentView.subviews) {
        view.alpha = on ? 1 : 0.4;
    }
}

@end

@implementation AddViewController

- (void)viewWillAppear:(BOOL)animated {
    if (_propertiesOnAppear != nil) {
        for (NSString *key in _propertiesOnAppear.allKeys) {
            id item = [_propertiesOnAppear objectForKey:key];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_idPathOnAppear];
            if ([cell isKindOfClass:[ClientPropertyCell class]]) {
                cell.detailTextLabel.text = item;
            }
            [self.manifestedProperties setObject:item forKey:key];
        }
    }
    _propertiesOnAppear = nil;
    _idPathOnAppear = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _propertiesOnAppear = nil;
    _idPathOnAppear = nil;
    self.manifestedProperties = [NSMutableDictionary new];
    NSNumber *defaultVal = @0;
    self.stepperValues = [NSMutableDictionary dictionaryWithDictionary:@{@"max_connections":defaultVal, @"max_upload_slots":defaultVal, @"max_upload_speed":defaultVal, @"max_download_speed":defaultVal, @"stop_ratio":defaultVal}];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        RemoteManager *remoteManager = [[RemoteManager alloc] initWithConnection];
        self.remoteManager = remoteManager;
        NSDictionary *defaults = [remoteManager clientDefaults];
        self.clientDefaults = defaults;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 17;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (![cell isKindOfClass:[ClientPropertyCell class]]) {
        if (self.assignedTasks.count > 1) {
            RemoteTorrent *rTorrent = [[RemoteTorrent alloc] initWithArray:self.assignedTasks];
            self.rTorrent = rTorrent;
        }
        else {
            NSURL *url = self.assignedTasks[0];
            if ([url.scheme isEqualToString:@"magnet"]) {
                NSString *link = [url description];
                cell.detailTextLabel.text = link;
                RemoteTorrent *rTorrent = [[RemoteTorrent alloc] initWithMagnetLink:url];
                self.rTorrent = rTorrent;
            }
            else {
                NSString *filename = [[[url path] componentsSeparatedByString:@"/"] lastObject];
                cell.detailTextLabel.text = filename;
                RemoteTorrent *rTorrent = [[RemoteTorrent alloc] initWithFileURL:url];
                self.rTorrent = rTorrent;
                /*
                    NSString *scheme = [url scheme];
                    NSLog(@"url recieved: %@", url);
                    NSLog(@"Called with: %@ scheme", [url scheme]);
                    NSLog(@"query string: %@", [url query]);
                    NSLog(@"host: %@", [url host]);
                    NSLog(@"url path: %@", [url path]);
                */
            }
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (_clientDefaults) {
        if ([cell isKindOfClass:[ClientPropertyCell class]]) {
            NSString *cellProperty = [(ClientPropertyCell *)cell keyString];
            id defaultValue = [_clientDefaults objectForKey:cellProperty];
            if (defaultValue) {
                [(ClientPropertyCell *)cell setIsShownClearly:TRUE];
                if ([defaultValue isKindOfClass:[NSNumber class]]) {
                    if ([cell isKindOfClass:[SwitchPropertyCell class]]) {
                        BOOL property = [(NSNumber *)defaultValue boolValue];
                        UISwitch *cellSwitch = [(SwitchPropertyCell *)cell mainSwitch];
                        [cellSwitch setOn:property];
                    }
                    else if ([cell isKindOfClass:[StepperPropertyCell class]]) {
                        float property = [(NSNumber *)defaultValue floatValue];
                        UITextField *field = [(StepperPropertyCell *)cell valueField];
                        [field setText:[NSString stringWithFormat:@"%.01f",property]];
                    }
                }
                else {
                    NSString *property = (NSString *)defaultValue;
                    cell.detailTextLabel.text = property;
                    //Then it is an NSString
                }
            }
            else {
                if ([(ClientPropertyCell *)cell necessaryProperty] != nil) {
                    NSString *necessaryProperty = [(ClientPropertyCell *)cell necessaryProperty];
                    if ([_clientDefaults objectForKey:necessaryProperty] == nil) {
                        [cell enable:FALSE];
                    }
                }
                [(ClientPropertyCell *)cell setIsShownClearly:FALSE];
                [cell appearClearly:FALSE];
                if ([cell isKindOfClass:[SwitchPropertyCell class]]) {
                    [[(SwitchPropertyCell *)cell mainSwitch] setOn:FALSE];
                }
                if ([cell isKindOfClass:[StepperPropertyCell class]]) {
                    [[(StepperPropertyCell *)cell valueField] setText:@"-1.0"];
                }
            }
        }
    }
    return cell;
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    UIView *view = sender;
    while (view && ![view isKindOfClass:[UITableViewCell class]]){
        view = view.superview;
    }
    NSString *keyString = [(StepperPropertyCell *)view keyString];
    if (![(ClientPropertyCell *)view isShownClearly]) {
        [(ClientPropertyCell *)view appearClearly:TRUE];
        [(ClientPropertyCell *)view setIsShownClearly:TRUE];
    }
    UITextField *tField = [(StepperPropertyCell *)view valueField];
    NSInteger currentVal = sender.value;
    NSInteger previousVal = [[self.stepperValues objectForKey:keyString] integerValue];
    NSInteger difference = currentVal - previousVal;
    [self.stepperValues setObject:[NSNumber numberWithInteger:currentVal] forKey:keyString];
    if ([keyString isEqualToString:@"stop_ratio"]) {
        float value = [tField.text floatValue];
        value = value + (float)difference/2;
        [tField setText:[NSString stringWithFormat:@"%0.1f", value]];
        NSNumber *numValue = [NSNumber numberWithFloat:value];
        [self.manifestedProperties setObject:numValue forKey:keyString];
    }
    else {
        NSInteger value = [tField.text integerValue];
        value = value + difference;
        [tField setText:[NSString stringWithFormat:@"%ld", value]];
        NSNumber *numValue = [NSNumber numberWithInteger:value];
        [self.manifestedProperties setObject:numValue forKey:keyString];
    }
}

- (IBAction)switchChanged:(UISwitch *)sender {
    UIView *view = sender;
    while (view && ![view isKindOfClass:[UITableViewCell class]]){
        view = view.superview;
    }
    if (![(ClientPropertyCell *)view isShownClearly]) {
        [(ClientPropertyCell *)view appearClearly:TRUE];
        [(ClientPropertyCell *)view setIsShownClearly:TRUE];
    }
    NSInteger dependentCells = [(ClientPropertyCell *)view dependentCells];
    if (dependentCells >= 1) {
        BOOL status = [sender isOn];
        for (NSInteger i = 1; i <= dependentCells; i++) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:(ClientPropertyCell *)view];
            NSInteger idPath = indexPath.row;
            NSIndexPath *nextPath = [NSIndexPath indexPathForRow:idPath+i inSection:indexPath.section];
            ClientPropertyCell *nextCell = [self.tableView cellForRowAtIndexPath:nextPath];
            [nextCell enable:status];
            if (!status) {
                [nextCell appearClearly:FALSE];
                [nextCell setIsShownClearly:FALSE];
                [self.manifestedProperties removeObjectForKey:nextCell.keyString];
            }
        }
    }
    NSString *keyString = [(SwitchPropertyCell *)view keyString];
    NSNumber *switchValue = [NSNumber numberWithBool:[sender isOn]];
    [self.manifestedProperties setObject:switchValue forKey:keyString];
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    UIView *view = sender;
    while (view && ![view isKindOfClass:[UITableViewCell class]]){
        view = view.superview;
    }
    if (![(ClientPropertyCell *)view isShownClearly]) {
        [(ClientPropertyCell *)view appearClearly:TRUE];
        [(ClientPropertyCell *)view setIsShownClearly:TRUE];
    }
    NSString *keyString = [(StepperPropertyCell *)view keyString];
    if ([keyString isEqualToString:@"stop_ratio"]) {
        float value = [sender.text floatValue];
        NSNumber *numValue = [NSNumber numberWithFloat:value];
        [self.manifestedProperties setObject:numValue forKey:keyString];
    }
    else {
        NSInteger value = [sender.text integerValue];
        NSNumber *numValue = [NSNumber numberWithInteger:value];
        [self.manifestedProperties setObject:numValue forKey:keyString];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ClientPropertyCell class]]) {
        if ([[(ClientPropertyCell *)cell keyString] isEqualToString:@"download_location"] || [[(ClientPropertyCell *)cell keyString] isEqualToString:@"move_completed_path"]) {
            NSString *keyStr = [[(ClientPropertyCell *)cell keyString] isEqualToString:@"download_location"]? @"download_location" : @"move_completed_path";
            AddViewDirectoryController *addDirController = [[AddViewDirectoryController alloc] init];
            addDirController.remoteManager = self.remoteManager;
            NSDictionary *parser = [self.manifestedProperties objectForKey:keyStr] ? self.manifestedProperties : self.clientDefaults;
            NSString *location = [parser objectForKey:keyStr];
            if (location.length == 0) {
                location = @"/";
            }
            _idPathOnAppear = indexPath;
            addDirController.rootDir = location;
            addDirController.parent = self;
            addDirController.editingProperty = keyStr;
            [self.navigationController pushViewController:addDirController animated:TRUE];
        }
    }
}

- (void)taskEnded {
    self.assignedTasks = nil;
    TaskManager *tManager = [TaskManager sharedInstance];
    tManager.remainingTasks = nil;
    if (_remoteManager) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [self.remoteManager endConnection];
            self.remoteManager = nil;
        });
    }
}

- (IBAction)cancel:(id)sender {
    [self taskEnded];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)done:(id)sender {
    _rTorrent.torrentProperties = _manifestedProperties;
    BOOL success = [_rTorrent execute];
    if (success) {
        [self taskEnded];
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }
}

@end
