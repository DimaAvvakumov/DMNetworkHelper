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

@property (copy, nonatomic) void(^beforeParseResponseBlock)(NSHTTPURLResponse *response, NSError *error, BOOL *shouldContinue);

// shared instance
+ (instancetype)sharedInstance;

// helper managers
- (AFHTTPSessionManager *) sessionManager;
- (void)setOperationManager:(AFHTTPSessionManager *) sessionManager;

- (void)addOperation:(NSOperation *)operation;

- (NSString *)requestURLByAppendPath:(NSString *)path;

#pragma mark - Shared request serializer
@property (strong, nonatomic) AFHTTPRequestSerializer *requestSerializer;

#pragma mark - Shared responce serializer
@property (strong, nonatomic) AFHTTPResponseSerializer *responseSerializer;

@end
