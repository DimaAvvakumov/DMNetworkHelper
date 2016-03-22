//
//  DMNetworkHelperUploadTask.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 23.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMNetworkHelperBasicTask.h"

typedef void (^DMNetworkHelperUploadTaskFinishBlock)(id item, NSError *error);
typedef void (^DMNetworkHelperProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

@interface DMNetworkHelperUploadTask : DMNetworkHelperBasicTask

@property (copy, nonatomic) void (^appendBlock)(id formData, NSError **error);

- (void)executeWithProgressBlock:(DMNetworkHelperProgressBlock)progressBlock andCompletitionBlock:(DMNetworkHelperUploadTaskFinishBlock)finishBlock;

@end
