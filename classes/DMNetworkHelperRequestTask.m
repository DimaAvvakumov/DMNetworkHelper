//
//  DMNetworkHelperRequestTask.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

// frameworks
#import <StandardPaths/StandardPaths.h>
#import <AFNetworking/AFNetworking.h>
#import <MagicalRecord/MagicalRecord.h>

#import "DMNetworkHelperRequestTask.h"

#import "DMNetworkHelperBasicTaskProtected.h"

#import "DMNetworkHelperManager.h"

@interface DMNetworkHelperRequestTask () <DMNetworkHelperRequestTaskProtocol>

@end

@implementation DMNetworkHelperRequestTask

- (void)start {
    if ([self isCancelled]) {
        [self finish];
        
        return;
    }
    
    // performing request
    AFHTTPSessionManager *manager = [DMNetworkHelperManager sharedInstance].sessionManager;
    
    // result queue
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // request serializer
    AFHTTPRequestSerializer *requestSerializer = manager.requestSerializer;
    if (requestSerializer == nil) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
        
        manager.requestSerializer = requestSerializer;
    }
    
    NSString *requestURL = [self absolutePath];
    if (requestURL == nil) {
        requestURL = [DM_NHM_SharedInstance requestURLByAppendPath:[self relativePath]];
    }
    
    NSString *method = [self methodString];
    
    // weak self
    __weak typeof (self) weakSelf = self;
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:requestURL parameters:self.params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (NO == error) {
            [strongSelf afterSuccessResponse:(NSHTTPURLResponse *)response withObject:responseObject];
        } else {
            [strongSelf afterFailureResponse:(NSHTTPURLResponse *)response withError:error];
        
        }
    }];
    
    [dataTask resume];
}

- (void)afterSuccessResponse:(NSHTTPURLResponse *)response withObject:(id)responseObject {
    
    [self finish];
}

- (void)afterFailureResponse:(NSHTTPURLResponse *)response withError: (NSError *)error {
    
    [self finish];
}

@end
