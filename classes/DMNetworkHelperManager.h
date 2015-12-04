//
//  DMNetworkHelperManager.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 30.11.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#define DM_NHM_SharedInstance [DMNetworkHelperManager sharedInstance]

@interface DMNetworkHelperManager : NSObject

@property (strong, nonatomic) NSString *url;

// shared instance
+ (instancetype)sharedInstance;

// helper managers
- (AFHTTPRequestOperationManager *) operationManager;
- (void)setOperationManager:(AFHTTPRequestOperationManager *) operationManager;

- (void)addOperation:(NSOperation *)operation;

- (NSString *)requestURLByAppendPath:(NSString *)path;

@end
