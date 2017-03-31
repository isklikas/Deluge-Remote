/*
 MIT License
 
 Copyright (c) 2017 John Sklikas
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */
//
//  KeychainController.m
//  sYoutube-dl
//
//  Created by Yannis on 04/12/2016.
//  Copyright © 2016 isklikas. All rights reserved.
//

#import "KeychainController.h"
#import "Deluge_Remote-Swift.h"

@interface KeychainController ()

@end

@implementation KeychainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Details";
    NSError *error;
    NSArray *passwordItems = [KeychainPasswordItem passwordItemsForService:@"com.isklikas.Deluge-Remote" accessGroup:nil error:&error];
    NSString *serverAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverAddress"];
    NSString *defaultLocation = [[NSUserDefaults standardUserDefaults] stringForKey:@"delugeHomeLocation"];
    if (passwordItems.count > 0) {
        KeychainPasswordItem *item = passwordItems[0];
        NSString *username = item.account;
        _userField.text = username;
        _originalName = username;
        NSError *error2;
        _passwordField.text = [item readPasswordAndReturnError:&error2];
        if (serverAddress != nil) {
            _serverField.text = serverAddress;
        }
        if (defaultLocation != nil) {
            _defaultLocationField.text = defaultLocation;
        }
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveToKeychain:(id)sender {
    
    // This is a new account, create a new keychain item with the account name.
    if (!_originalName) {
        _originalName = _userField.text;
    }
    KeychainPasswordItem *passwordItem = [[KeychainPasswordItem alloc] initWithService:@"com.isklikas.Deluge-Remote" account:_originalName accessGroup:nil];
    if (![_originalName isEqualToString:_userField.text]) {
        [passwordItem renameAccount:_userField.text error:nil];
    }
    // Save the password for the new item.
    NSError *error;
    [passwordItem savePassword:_passwordField.text error:&error];
    [[NSUserDefaults standardUserDefaults] setObject:_serverField.text forKey:@"serverAddress"];
    [[NSUserDefaults standardUserDefaults] setObject:_defaultLocationField.text forKey:@"delugeHomeLocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
