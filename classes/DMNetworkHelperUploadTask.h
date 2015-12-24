//
//  DMNetworkHelperUploadTask.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 23.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import <DMNetworkHelper/DMNetworkHelperBasicTask.h>

typedef void (^DMNetworkHelperUploadTaskFinishBlock)(_Nullable id item, NSError __autoreleasing * _Nullable  error, NSInteger statusCode);
typedef void (^DMNetworkHelperProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

@interface DMNetworkHelperUploadTask : DMNetworkHelperBasicTask

@property (copy, nonatomic, nullable) void (^appendBlock)(id formData, NSError **error);

- (void)executeWithProgressBlock:(DMNetworkHelperProgressBlock)progressBlock andCompletitionBlock:(_Nullable DMNetworkHelperUploadTaskFinishBlock)finishBlock;

@end
