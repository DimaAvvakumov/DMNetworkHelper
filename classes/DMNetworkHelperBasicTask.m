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
#import <MagicalRecord/MagicalRecord.h>

#import "DMNetworkHelperBasicTask.h"
#import "DMNetworkHelperBasicTaskProtected.h"

#import "DMNetworkHelperManager.h"

@interface DMNetworkHelperBasicTask() <DMNetworkHelperBasicTaskProtected> {
    BOOL _isExecuting;
    BOOL _isFinished;
}

@property (strong, nonatomic) NSManagedObjectContext *localContext;

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

- (NSString *)absolutePath {
    return nil;
}

- (NSString *)relativePath {
    return @"";
}

- (DMNetworkHelperTaskMethod) method {
    return DMNetworkHelperTaskMethod_GET;
}

- (NSString *)itemsKey {
    return @"items";
}

- (BOOL)databaseIsUsing {
    return YES;
}

- (id)parseItem:(NSDictionary *)itemInfo {
    return nil;
}

- (id)parseItem:(NSDictionary *)itemInfo inLocalContext:(NSManagedObjectContext *)localContext {
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

@end
