//
//  DMNetworkHelperDownloadTask.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMNetworkHelperDownloadTask.h"

// frameworks
#import <StandardPaths/StandardPaths.h>
#import <MagicalRecord/MagicalRecord.h>

#import "DMNetworkHelperBasicTaskProtected.h"

#import "DMNetworkHelperManager.h"

@interface DMNetworkHelperDownloadTask() <DMNetworkHelperBasicTaskProtected>

@property (strong, nonatomic) NSManagedObjectContext *localContext;

@property (copy, nonatomic) DMNetworkHelperProgressBlock progressBlock;
@property (copy, nonatomic) DMNetworkHelperDownloadTaskFinishBlock finishBlock;

@end

@implementation DMNetworkHelperDownloadTask

- (void)executeWithProgressBlock:(DMNetworkHelperProgressBlock)progressBlock andCompletitionBlock:(DMNetworkHelperDownloadTaskFinishBlock)finishBlock {
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
    
    NSString *requestURL = self.url;
    
    NSString *method = [self methodString];
    
    // weak self
    __weak typeof (self) weakSelf = self;
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:requestURL parameters:self.params error:nil];
    
    NSString *tmpFileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".tmp"];
    __block NSString *tmpPath = [[NSFileManager defaultManager] pathForCacheFile:tmpFileName];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        [weakSelf afterSuccessResponse:operation.response withTmpFile:tmpPath];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        [weakSelf afterFailureResponse:operation.response withError:error];
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (strongSelf.progressBlock) {
            strongSelf.progressBlock( bytesRead, totalBytesRead, totalBytesExpectedToRead );
        }
        
    }];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath: tmpPath append: NO];
    
    [manager.operationQueue addOperation:operation];
}

- (void)afterSuccessResponse:(NSHTTPURLResponse *)response withTmpFile:(NSString *)tmpPath {
    
    NSInteger statusCode = response.statusCode;
    
    NSString *filePath = [self afterDownloadTempFile:tmpPath withResponse:response];
    if (filePath == nil) {
        filePath = [self canonizeFilePath:self.url];
        
        NSString *fullPath = [[NSFileManager defaultManager] pathForCacheFile:filePath];
        
        NSError *error = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
            BOOL isRemoved = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
            
            if (NO == isRemoved) {
                if (error == nil) {
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey: @"File already exist and can`t be removed",
                                               @"filePath": fullPath
                                               };

                    error = [NSError errorWithDomain:@"custom" code:-1 userInfo:userInfo];
                }
                
                if (_finishBlock) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        _finishBlock(nil, error, statusCode);
                    });
                }
                
                [self finish];
                
                return;
            }
        } else {
            BOOL isCreated = [[NSFileManager defaultManager] createDirectoryAtPath:[fullPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error];
            
            if (NO == isCreated) {
                if (error == nil) {
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey: @"Directory can`t be created",
                                               @"filePath": fullPath
                                               };
                    error = [NSError errorWithDomain:@"custom" code:-1 userInfo:userInfo];
                }
                
                if (_finishBlock) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        _finishBlock(nil, error, statusCode);
                    });
                }
                
                [self finish];
                
                return;
            }
        }
        
        BOOL isMoved = [[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:fullPath error:&error];
        if (NO == isMoved) {
            if (error == nil) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: @"File downloaded but can`t be moved",
                                           @"filePath": fullPath
                                           };
                
                error = [NSError errorWithDomain:@"custom" code:-1 userInfo:userInfo];
            }
            
            if (_finishBlock) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    _finishBlock(nil, error, statusCode);
                });
            }
            
            [self finish];
            
            return;
        }
        
    }
    
    if (_finishBlock) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _finishBlock(filePath, nil, statusCode);
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

- (NSString *)afterDownloadTempFile:(NSString *)tmpFilePath withResponse:(NSHTTPURLResponse *)response {
    
    return nil;
}

- (NSString *)canonizeFilePath:(NSString *)filePath {
    filePath = [filePath stringByReplacingOccurrencesOfString:@"://" withString:@"_"];
    
    NSInteger length = [filePath length];
    NSMutableString *newPath = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        unichar c = [filePath characterAtIndex:i];
        
        BOOL add = NO;
        if (c >= '0' && c <= '9') {
            add = YES;
        } else if (c >= 'a' && c <= 'z') {
            add = YES;
        } else if (c >= 'A' && c <= 'Z') {
            add = YES;
        } else if (c == '_' || c == '.') {
            add = YES;
        } else if (c == '/') {
            add = YES;
        }
        
        if (add) {
            [newPath appendFormat:@"%c", c];
        } else {
            [newPath appendString:@"_"];
        }
        
    }
    
    return newPath;
}

@end
