//
//  DMNetworkHelperManager.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 30.11.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMNetworkHelperManager.h"

@interface DMNetworkHelperManager()

@property (strong, nonatomic) AFHTTPRequestOperationManager *storedOperationManager;
@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation DMNetworkHelperManager

+ (instancetype)sharedInstance {
    static DMNetworkHelperManager *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (id)init {
    self = [super init];
    if (self == nil) return nil;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    
    self.operationQueue = queue;
    
    return self;
}

// helper managers
- (AFHTTPRequestOperationManager *) operationManager {
    static dispatch_semaphore_t semaphore;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        semaphore = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (self.storedOperationManager == nil) {
        self.storedOperationManager = [AFHTTPRequestOperationManager manager];
    }
    
    dispatch_semaphore_signal(semaphore);
    
    return self.storedOperationManager;
}

- (void)setOperationManager:(AFHTTPRequestOperationManager *) operationManager {
    self.storedOperationManager = operationManager;
}

- (void)addOperation:(NSOperation *)operation {
    [self.operationQueue addOperation:operation];
}

- (NSString *)requestURLByAppendPath:(NSString *)path {
    
    NSString *url = (self.url) ? self.url : @"localhost";
    return [NSString stringWithFormat:@"%@/%@", url, path];
}

@end
