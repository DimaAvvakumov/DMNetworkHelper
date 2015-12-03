//
//  DMNetworkHelperTaskOperation.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 30.11.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

// frameworks
#import <AFNetworking/AFNetworking.h>

#import "DMNetworkHelperManager.h"
#import "DMNetworkHelperTaskOperation.h"

@interface DMNetworkHelperTaskOperation() {
    BOOL _isExecuting;
    BOOL _isFinished;
}

@property (copy, nonatomic) DMNetworkHelperListTaskFinishBlock finishBlock;

@end

@implementation DMNetworkHelperTaskOperation

- (void)start {
    if ([self isCancelled]) {
        [self finish];
        
        return;
    }
    
    [self printThread];
    
    // performing request
    AFHTTPRequestOperationManager *manager = [DMNetworkHelperManager sharedInstance].operationManager;
    
    // result queue
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // request serializer
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    // bind
    manager.requestSerializer = requestSerializer;
    
    NSString *requestURL = [DM_NHM_SharedInstance requestURLByAppendPath:[self path]];
    NSString *method = [self methodString];
    
    // weak self
    __weak typeof (self) weakSelf = self;

    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:requestURL parameters:nil error:nil];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = responseObject;
        
        [weakSelf afterSuccessResponse: result];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [weakSelf afterFailureResponse: error];
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)afterSuccessResponse:(NSDictionary *)json {
    if ([self isCancelled]) {
        [self finish];
        
        return;
    }
    
    if ([self responseType] == DMNetworkHelperTaskResponseType_List)  {
        return [self afterSuccessListResponse:json];
    } else {
        return [self afterSuccessItemResponse:json];
    }
    
}

- (void)afterSuccessListResponse:(NSDictionary *)json {

    NSArray *itemsJson = nil;
    NSString *key = [self itemsKey];
    
    if ([key isEqualToString:@"*"] && [json isKindOfClass:[NSArray class]]) {
        itemsJson = (NSArray *) json;
    } else {
        NSRange dotRange = [key rangeOfString:@"."];
        NSDictionary *subDict = json;
        while (dotRange.location != NSNotFound) {
            NSString *firstKey = [key substringToIndex:dotRange.location];
            key = [key substringFromIndex:(dotRange.location + 1)];
            
            subDict = [subDict objectForKey:firstKey];
            
            dotRange = [key rangeOfString:@"."];
        }
        
        itemsJson = [subDict objectForKey:key];
    }
    
    if (itemsJson == nil || NO == [itemsJson isKindOfClass:[NSArray class]]) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Wrong server response" };
        NSError *error = [NSError errorWithDomain:DM_NHM_SharedInstance.host code:-1 userInfo:userInfo];
        
        if (_finishBlock) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _finishBlock(nil, error);
            });
        }
        
        [self finish];
        
        return;
    }
    
    NSInteger itemsCount = [itemsJson count];
    NSMutableArray *items = nil;
    
    if (itemsCount > 0) {
        items = [NSMutableArray arrayWithCapacity:itemsCount];
        
        for (NSDictionary *itemInfo in itemsJson) {
            
            id item = [self parseItem:itemInfo];
            
            if (item) {
                [items addObject:item];
            }
        }
    }
    
    if (_finishBlock) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _finishBlock(items, nil);
        });
    }
    
    [self finish];
}

- (void)afterSuccessItemResponse:(NSDictionary *)json {
    
}

- (void)afterFailureResponse:(NSError *)error {
    if (_finishBlock) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _finishBlock(nil, error);
        });
    }
    
    [self finish];
}

- (void) finish {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    NSLog(@"Operation %p finished!", self);
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)printThread {
    NSString *isMain = ([NSThread isMainThread]) ? @"is main" : @"background";
    NSLog(@"Thread: %p %@", [NSThread currentThread], isMain);
}

- (BOOL)isFinished {
    return _isFinished;
}

- (BOOL)isExecuting {
    return _isExecuting;
}

#pragma mark - Default

- (DMNetworkHelperTaskResponseType)responseType {
    return DMNetworkHelperTaskResponseType_List;
}

- (NSString *)path {
    return @"";
}

- (DMNetworkHelperTaskMethod) method {
    return DMNetworkHelperTaskMethod_GET;
}

- (NSString *)itemsKey {
    return @"items";
}

- (id)parseItem:(NSDictionary *)itemInfo {
    return nil;
}

#pragma mark - Helper

- (NSString *)methodString {
    
    DMNetworkHelperTaskMethod method = [self method];
    
    switch (method) {
        case DMNetworkHelperTaskMethod_GET: {
            return @"GET";
        }
        case DMNetworkHelperTaskMethod_PUT: {
            return @"PUT";
        }
        case DMNetworkHelperTaskMethod_POST: {
            return @"POST";
        }
        default: {
            return @"GET";
        }
    }
}

- (void)executeWithCompletitionBlock:(DMNetworkHelperListTaskFinishBlock)finishBlock {
    self.finishBlock = finishBlock;
    
    [DM_NHM_SharedInstance addOperation:self];
}

@end
