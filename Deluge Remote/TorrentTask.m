//
//  TorrentTask.m
//  Deluge Remote
//
//  Created by Yannis on 01/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "TorrentTask.h"

@implementation TorrentTask

- (void) writeToTaskScript {
    NSString *taskPath = [[NSBundle mainBundle] pathForResource:@"Task" ofType:@"py"]; // located in main bundle
    NSData *taskPyData = [NSData dataWithContentsOfFile:taskPath]; // image data
    // get the path of shared folder
    taskPath = [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path] stringByAppendingPathComponent:@"Task.py"]; // where to store your image
    [taskPyData writeToFile:taskPath atomically:YES];
    NSString *taskManager = [NSString stringWithContentsOfFile:taskPath encoding:NSUTF8StringEncoding error:NULL];
    taskManager = [taskManager stringByReplacingOccurrencesOfString:@"[COMMAND_LINES_GO_HERE]" withString:self.cmdString];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL fileExistsAtPath = TRUE;
    int writeIndex =  0;
    NSString *nameToWrite;
    while (fileExistsAtPath) {
        writeIndex++;
        NSString *pathWithoutExtension = [taskPath componentsSeparatedByString:@".py"][0];
        nameToWrite = [NSString stringWithFormat:@"%@%d.py",pathWithoutExtension,writeIndex];
        fileExistsAtPath = [fileManager fileExistsAtPath:nameToWrite];
    }
    self.writeIndex = [NSNumber numberWithInt:writeIndex];
    self.pyName = nameToWrite;
    [taskManager writeToFile:nameToWrite atomically:TRUE encoding:NSUTF8StringEncoding error:nil];
}

- (id) executeTask {
    NSError *error;
    NSString *filePath = self.pyName;
    NSString *fName = [NSString stringWithFormat:@"Task%@.py", self.writeIndex];
    BOOL success = [_session.channel uploadFile:filePath to:@"/tmp/"];
    if (success) {
        NSString *response = [_session.channel execute:[NSString stringWithFormat:@"cd /tmp; python %@",fName] error:&error];
        [_session.channel execute:[NSString stringWithFormat:@"cd /tmp; rm %@",fName] error:&error];
        return response;
    }
    return nil;
}

- (void) cleanUp {
    NSError *error;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtPath:self.pyName error:&error];
}

@end
