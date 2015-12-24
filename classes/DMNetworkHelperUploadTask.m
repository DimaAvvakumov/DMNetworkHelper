//
//  DMNetworkHelperUploadTask.m
//  Pods
//
//  Created by Avvakumov Dmitry on 23.12.15.
//
//

#import "DMNetworkHelperUploadTask.h"

// frameworks
#import <StandardPaths/StandardPaths.h>
#import <MagicalRecord/MagicalRecord.h>

#import "DMNetworkHelperBasicTaskProtected.h"

#import "DMNetworkHelperManager.h"

@interface DMNetworkHelperUploadTask() <DMNetworkHelperBasicTaskProtected>

@property (strong, nonatomic) NSManagedObjectContext *localContext;

@property (copy, nonatomic) DMNetworkHelperProgressBlock progressBlock;
@property (copy, nonatomic) DMNetworkHelperUploadTaskFinishBlock finishBlock;

@end

@implementation DMNetworkHelperUploadTask

- (void)executeWithProgressBlock:(DMNetworkHelperProgressBlock)progressBlock andCompletitionBlock:(DMNetworkHelperUploadTaskFinishBlock)finishBlock {
    self.progressBlock = progressBlock;
    self.finishBlock = finishBlock;
    [DM_NHM_SharedInstance addOperation:self];
}

- (void)start {
    if ([self isCancelled]) {
        [self finish];
        
        return;
    }
    
    // performing request
    AFHTTPRequestOperationManager *manager = [DMNetworkHelperManager sharedInstance].operationManager;
    
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
    
    // error
    __block NSError *error = nil;
    
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:method URLString:requestURL parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (strongSelf.appendBlock) {
            strongSelf.appendBlock(formData, &error);
        }
        
    } error:&error];
    
    if (error) {
        if (_finishBlock) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _finishBlock(nil, error, 0);
            });
        }
        
        [self finish];
        
        return;
    }
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        [strongSelf afterSuccessResponse:operation.response withObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        [strongSelf afterFailureResponse:operation.response withError:error];
    }];
    
    if (_progressBlock) {
        [operation setUploadProgressBlock:_progressBlock];
    }
    
    [manager.operationQueue addOperation:operation];
    
}

- (void)afterSuccessResponse:(NSHTTPURLResponse *)response withObject:(id)responseObject {
    
    NSDictionary *json = (NSDictionary *) responseObject;
    NSInteger statusCode = response.statusCode;
    
    NSDictionary *itemJson = nil;
    NSString *key = [self itemsKey];
    
    if ([key isEqualToString:@"-"]) {
        if (_finishBlock) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _finishBlock(nil, nil, statusCode);
            });
        }
        
        [self finish];
        
        return;
    }
    
    if ([key isEqualToString:@"*"] && [json isKindOfClass:[NSDictionary class]]) {
        itemJson = (NSDictionary *) json;
    } else {
        NSRange dotRange = [key rangeOfString:@"."];
        NSDictionary *subDict = json;
        while (dotRange.location != NSNotFound) {
            NSString *firstKey = [key substringToIndex:dotRange.location];
            key = [key substringFromIndex:(dotRange.location + 1)];
            
            subDict = [subDict objectForKey:firstKey];
            
            dotRange = [key rangeOfString:@"."];
        }
        
        itemJson = [subDict objectForKey:key];
    }
    
    if (itemJson == nil || NO == [itemJson isKindOfClass:[NSDictionary class]]) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Wrong server response" };
        NSError *error = [NSError errorWithDomain:DM_NHM_SharedInstance.url code:-1 userInfo:userInfo];
        
        if (_finishBlock) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _finishBlock(nil, error, statusCode);
            });
        }
        
        [self finish];
        
        return;
    }
    
    BOOL databaseIsUsing = [self databaseIsUsing];
    
    if (databaseIsUsing) {
        NSManagedObjectContext *savingContext = [NSManagedObjectContext MR_rootSavingContext];
        self.localContext = [NSManagedObjectContext MR_contextWithParent:savingContext];
    }
    
    id item = nil;
    NSDictionary *itemInfo = itemJson;
    if (databaseIsUsing) {
        item = [self parseItem:itemInfo inLocalContext:self.localContext];
    } else {
        item = [self parseItem:itemInfo];
    }
    
    // save context
    [self.localContext MR_saveToPersistentStoreAndWait];
    
    if (_finishBlock) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _finishBlock(item, nil, statusCode);
        });
    }
    
    [self finish];
}

- (void)afterFailureResponse:(NSHTTPURLResponse *)response withError:(NSError *)error {
    
    NSInteger statusCode = response.statusCode;
    
    if (_finishBlock) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _finishBlock(nil, error, statusCode);
        });
    }
    
    [self finish];
}

@end
