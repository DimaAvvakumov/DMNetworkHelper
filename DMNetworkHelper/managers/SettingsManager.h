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

- (void)save;

@end