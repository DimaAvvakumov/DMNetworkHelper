//
//  SettingsManager.h
//  DMNetworkHelper
//
//  Created by Dmitry Avvakumov on 16.09.13.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

+ (SettingsManager *) defaultManager;

@property (strong, nonatomic) NSString *serverProtocol;
@property (strong, nonatomic) NSString *serverHost;
@property (strong, nonatomic) NSString *serverPort;
@property (strong, nonatomic) NSString *serverPath;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *fileURL;

- (void)save;

@end