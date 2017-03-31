//
//  RemoteManager.m
//  Deluge Remote
//
//  Created by Yannis on 27/03/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

/*

 options_conf_map = {
 "max_connections": "max_connections_per_torrent",
 "max_upload_slots": "max_upload_slots_per_torrent",
 "max_upload_speed": "max_upload_speed_per_torrent",
 "max_download_speed": "max_download_speed_per_torrent",
 "prioritize_first_last_pieces": "prioritize_first_last_pieces",
 "sequential_download": "sequential_download",
 "compact_allocation": "compact_allocation",
 "download_location": "download_location",
 "auto_managed": "auto_managed",
 "stop_at_ratio": "stop_seed_at_ratio",
 "stop_ratio": "stop_seed_ratio",
 "remove_at_ratio": "remove_seed_at_ratio",
 "move_completed": "move_completed",
 "move_completed_path": "move_completed_path",
 "add_paused": "add_paused",
 "shared": "shared"
 }
 
 */

#import "RemoteManager.h"
#import "Deluge_Remote-Swift.h"

@implementation RemoteManager

- (id) initWithConnection {
    self = [super init];
    if( !self ) return nil;
    NSError *error;
    NSArray *passwordItems = [KeychainPasswordItem passwordItemsForService:@"com.isklikas.Deluge-Remote" accessGroup:nil error:&error];
    NSString *serverAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverAddress"];
    if (passwordItems.count > 0 && serverAddress != nil) {
        KeychainPasswordItem *item = passwordItems[0];
        NSString *server = [serverAddress stringByAppendingString:@":22"];
        NMSSHSession *session = [NMSSHSession connectToHost:server withUsername:item.account];
        if (session.isConnected) {
            [session authenticateByPassword:[item readPasswordAndReturnError:nil]];
            if (session.isAuthorized) {
                NSLog(@"Authentication succeeded");
                NSString *passManPath = [[NSBundle mainBundle] pathForResource:@"PasswordManager" ofType:@"py"];
                self.session = session;
                self.homeLocation = [[NSUserDefaults standardUserDefaults] stringForKey:@"delugeHomeLocation"];
                [self setUpPass];
                [_session.channel uploadFile:passManPath to:@"/tmp/"];
                return self;
            }
        }
    }
    return nil;
}

- (void) setUpPass {
    NSString *delugeHomeDir = self.homeLocation;//@"/var/lib/deluge";
    NSString *authLocation = [delugeHomeDir stringByAppendingPathComponent:@".config/deluge/auth"];
    NSString *authData = [_session.channel execute:[NSString stringWithFormat:@"cat %@", authLocation] error:nil];
    NSString *password = [[[authData componentsSeparatedByString:@"localclient:"] objectAtIndex:1] componentsSeparatedByString:@":"][0];
    NSString *passManPath = [[NSBundle mainBundle] pathForResource:@"PasswordManager" ofType:@"py"];
    NSString *passManager = [NSString stringWithContentsOfFile:passManPath encoding:NSUTF8StringEncoding error:NULL];
    passManager = [passManager stringByReplacingOccurrencesOfString:@"[PASSWORD HERE]" withString:password];
    [passManager writeToFile:passManPath atomically:TRUE encoding:NSUTF8StringEncoding error:nil];
}

- (void)getStatus {
    NSError *error = nil;
    //NSString *getPass = [session.channel execute:@"cd /tmp; python Status.py" error:&error];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Status" ofType:@"py"];
    BOOL success = [_session.channel uploadFile:filePath to:@"/tmp/"];
    NSString *response = [_session.channel execute:@"cd /tmp; python Status.py" error:&error];
    NSLog(@"Deluge status %@", response);
    NSString *deletion = [_session.channel execute:@"cd /tmp; rm Status.py" error:&error];
}

- (void) endConnection {
    NSError *error;
    [_session.channel execute:@"cd /tmp; rm PasswordManager.py" error:&error];
    [self.session disconnect];
}

@end
