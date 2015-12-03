//
//  SettingsManager.m
//  DMNetworkHelper
//
//  Created by Dmitry Avvakumov on 16.09.13.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "SettingsManager.h"

@interface SettingsManager ()

@end

@implementation SettingsManager

+ (SettingsManager *) defaultManager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id) init {
    self = [super init];
    if (self) {
        // restore
        [self restoreUserDefaults];
    }
    
    return self;
}

#pragma mark - Restore

- (void) restoreUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.serverProtocol = [userDefaults stringForKey:@"Server_Protocol"];
    self.serverHost = [userDefaults stringForKey:@"Server_Host"];
    self.serverPort = [userDefaults stringForKey:@"Server_Port"];
    self.serverPath = [userDefaults stringForKey:@"Server_Path"];
    
    self.username = [userDefaults stringForKey:@"Username"];
    self.password = [userDefaults stringForKey:@"Password"];
    
}

- (void)save {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (self.serverProtocol) {
        [userDefaults setObject:self.serverProtocol forKey:@"Server_Protocol"];
    }
    if (self.serverHost) {
        [userDefaults setObject:self.serverHost forKey:@"Server_Host"];
    }
    if (self.serverPort) {
        [userDefaults setObject:self.serverPort forKey:@"Server_Port"];
    }
    if (self.serverPath) {
        [userDefaults setObject:self.serverPath forKey:@"Server_Path"];
    }
    if (self.username) {
        [userDefaults setObject:self.username forKey:@"Username"];
    }
    if (self.password) {
        [userDefaults setObject:self.password forKey:@"Password"];
    }
    
    [userDefaults synchronize];
}



@end