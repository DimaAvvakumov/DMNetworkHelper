//
//  DMNetworkHelperDownloadTask.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMNetworkHelperBasicTask.h"

typedef void (^DMNetworkHelperDownloadTaskFinishBlock)(NSString *filePath, NSError *error, NSInteger statusCode);
typedef void (^DMNetworkHelperProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

@interface DMNetworkHelperDownloadTask : DMNetworkHelperBasicTask

@property (strong, nonatomic) NSString *url;

- (void)executeWithProgressBlock:(DMNetworkHelperProgressBlock)progressBlock andCompletitionBlock:(DMNetworkHelperDownloadTaskFinishBlock)finishBlock;

- (NSString *)afterDownloadTempFile:(NSString *)tmpFilePath withResponse:(NSHTTPURLResponse *)response;

@end
