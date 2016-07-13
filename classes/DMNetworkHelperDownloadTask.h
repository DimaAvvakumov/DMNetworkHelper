//
//  DMNetworkHelperDownloadTask.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMNetworkHelperBasicTask.h"

typedef void (^DMNetworkHelperDownloadTaskFinishBlock)(id downloadResult, NSError *error);
typedef void (^DMNetworkHelperProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

@interface DMNetworkHelperDownloadTask : DMNetworkHelperBasicTask

- (void)executeWithProgressBlock:(DMNetworkHelperProgressBlock)progressBlock andCompletitionBlock:(DMNetworkHelperDownloadTaskFinishBlock)finishBlock;

- (NSString *)afterDownloadTempFile:(NSString *)tmpFilePath withResponse:(NSHTTPURLResponse *)response;

@end
