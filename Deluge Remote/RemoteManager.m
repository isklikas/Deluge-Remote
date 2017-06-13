//
//  RemoteManager.m
//  Deluge Remote
//
//  Created by Yannis on 27/03/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

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
                NSString *passManPath = [[NSBundle mainBundle] pathForResource:@"PasswordManager" ofType:@"py"]; // located in main bundle
                NSData *taskPyData = [NSData dataWithContentsOfFile:passManPath]; // image data
                // get the path of shared folder
                passManPath = [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path] stringByAppendingPathComponent:@"PasswordManager.py"]; // where to store your image
                [taskPyData writeToFile:passManPath atomically:YES];
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

- (void) connect {
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
                NSString *passManPath = [[NSBundle mainBundle] pathForResource:@"PasswordManager" ofType:@"py"]; // located in main bundle
                NSData *taskPyData = [NSData dataWithContentsOfFile:passManPath]; // image data
                // get the path of shared folder
                passManPath = [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path] stringByAppendingPathComponent:@"PasswordManager.py"]; // where to store your image
                [taskPyData writeToFile:passManPath atomically:YES];
                self.session = session;
                self.homeLocation = [[NSUserDefaults standardUserDefaults] stringForKey:@"delugeHomeLocation"];
                [self setUpPass];
                [_session.channel uploadFile:passManPath to:@"/tmp/"];
            }
        }
    }
    
}

- (void) setUpPass {
    NSString *delugeHomeDir = self.homeLocation;//@"/var/lib/deluge";
    NSString *authLocation = [delugeHomeDir stringByAppendingPathComponent:@".config/deluge/auth"];
    NSString *authData = [_session.channel execute:[NSString stringWithFormat:@"cat %@", authLocation] error:nil];
    NSString *password = [[[authData componentsSeparatedByString:@"localclient:"] objectAtIndex:1] componentsSeparatedByString:@":"][0];
    NSString *passManPath = [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path] stringByAppendingPathComponent:@"PasswordManager.py"]; // where to store your image
    NSString *passManager = [NSString stringWithContentsOfFile:passManPath encoding:NSUTF8StringEncoding error:NULL];
    passManager = [passManager stringByReplacingOccurrencesOfString:@"[PASSWORD HERE]" withString:password];
    [passManager writeToFile:passManPath atomically:TRUE encoding:NSUTF8StringEncoding error:nil];
}

- (NSArray *)directoriesInLocation:(NSString *)location {
    NSMutableArray *resultingDirs = [NSMutableArray new];
    NSString *dirs = [_session.channel execute:[NSString stringWithFormat:@"cd \"%@\";  ls -d */", location] error:nil];
    NSArray *tmpDirs = [dirs componentsSeparatedByString:@"\n"];
    for (NSString *folderName in tmpDirs) {
        NSString *dirName = [folderName componentsSeparatedByString:@"/"][0];
        if (dirName.length > 0) {
            [resultingDirs addObject:dirName];
        }
    }
    return resultingDirs;
}

- (NSArray *)getRunningTorrents {
    //Returns an array of torrent IDs
    GetDataTask *dTask = [[GetDataTask alloc] init];
    dTask.session = _session;
    NSArray *runningTorrents = [dTask getRunningTorrents];
    return runningTorrents;
    
}

- (NSDictionary *)getCellDataforTorrentID:(NSString *)torrentID {
    //Returns all cell necessary properties
    GetDataTask *dTask = [[GetDataTask alloc] init];
    dTask.session = _session;
    NSDictionary *runningTorrents = [dTask getCellDataforTorrentID:torrentID];
    return runningTorrents;
}

- (NSString *)getStatus {
    GetDataTask *dTask = [[GetDataTask alloc] init];
    dTask.session = _session;
    NSString *status = [dTask getStatus];
    return status;
}

- (NSDictionary *)clientDefaults {
    GetDataTask *dTask = [[GetDataTask alloc] init];
    dTask.session = _session;
    NSDictionary *defaults = [dTask clientDefaults];
    return defaults;
}

- (void) endConnection {
    NSError *error;
    [_session.channel execute:@"cd /tmp; rm PasswordManager.py" error:&error];
    [self.session disconnect];
}

@end
