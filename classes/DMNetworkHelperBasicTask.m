//
//  DMNetworkHelperBasicTask.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

// frameworks
#import <StandardPaths/StandardPaths.h>
#import <AFNetworking/AFNetworking.h>

#import "DMNetworkHelperBasicTask.h"
#import "DMNetworkHelperBasicTaskProtected.h"

#import "DMNetworkHelperManager.h"

@interface DMNetworkHelperBasicTask() <DMNetworkHelperBasicTaskProtected> {
    BOOL _isExecuting;
    BOOL _isFinished;
}

@end

@implementation DMNetworkHelperBasicTask

- (void)start {
    if ([self isCancelled]) {
        [self finish];
        
        return;
    }
}

- (void) finish {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isFinished {
    return _isFinished;
}

- (BOOL)isExecuting {
    return _isExecuting;
}

#pragma mark - Default

- (NSString *)apiEndpoint {
    return nil;
}

- (NSString *)absolutePath {
    return nil;
}

- (NSString *)relativePath {
    return @"";
}

- (DMNetworkHelperTaskMethod) method {
    return DMNetworkHelperTaskMethod_GET;
}

- (NSTimeInterval)timeoutInterval {
    return 0.0;
}

- (NSString *)buildRequestURLString {
    if (self.apiEndpoint == nil) return nil;
    
    NSString *apiEndpoint = self.apiEndpoint;
    NSString *path = [self relativePath];
    return [NSString stringWithFormat:@"%@/%@", apiEndpoint, path];
}

- (NSString *)findByKey {
    return @"*";
}

- (DMNetworkHelperResponseOptions)responseOptions {
    return 0;
}

- (void)parseResponseWithFinishBlock:(void (^)(id result, NSError *error))finishParseBlock {
    finishParseBlock(nil, nil);
}

#pragma mark - Mock

- (NSTimeInterval)mockRequestDuration {
    return 3.0;
}

- (NSString *)mockResponseFilePath {
    return @"";
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
        case DMNetworkHelperTaskMethod_DELETE: {
            return @"DELETE";
        }
        default: {
            return @"GET";
        }
    }
}

- (id)findInJson:(id)json byKey:(NSString *)key {
    if ([key isEqualToString:@"*"]) {
        return json;
    }
    
    NSRange dotRange = [key rangeOfString:@"."];
    NSDictionary *subDict = json;
    while (dotRange.location != NSNotFound) {
        // check for valid subDict
        if (subDict == nil) break;
        if (NO == [subDict isKindOfClass:[NSDictionary class]]) break;
        
        NSString *firstKey = [key substringToIndex:dotRange.location];
        key = [key substringFromIndex:(dotRange.location + 1)];
        
        subDict = [subDict objectForKey:firstKey];
        
        dotRange = [key rangeOfString:@"."];
    }
    
    if (subDict == nil) return nil;
    if (NO == [subDict isKindOfClass:[NSDictionary class]]) return nil;
    
    return [subDict objectForKey:key];
}

#pragma mark - Cancelling

- (void)cancel {
    [super cancel];
    
    NSURLSessionTask *task = self.dataTask;
    if (task) {
        [task cancel];
    }
}

@end
