//
//  DMNetworkHelperTaskOperation.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 30.11.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

typedef void (^DMNetworkHelperListTaskFinishBlock)(NSArray *items, NSError *error, NSInteger statusCode);
typedef void (^DMNetworkHelperDownloadTaskFinishBlock)(NSString *filePath, NSError *error, NSInteger statusCode);
typedef void (^DMNetworkHelperProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

typedef enum {
    DMNetworkHelperTaskMethod_GET,
    DMNetworkHelperTaskMethod_PUT,
    DMNetworkHelperTaskMethod_POST
} DMNetworkHelperTaskMethod;

typedef enum {
    DMNetworkHelperTaskRequestType_None,
    DMNetworkHelperTaskRequestType_FileDownload
} DMNetworkHelperTaskRequestType;

typedef enum {
    DMNetworkHelperTaskResponseType_List,
    DMNetworkHelperTaskResponseType_Item
} DMNetworkHelperTaskResponseType;

@interface DMNetworkHelperTaskOperation : NSOperation

#pragma mark - params

@property (strong, nonatomic) id params;

@property (copy, nonatomic) DMNetworkHelperProgressBlock progressBlock;

- (void)executeWithCompletitionBlock:(DMNetworkHelperListTaskFinishBlock)finishBlock;
- (void)executeWithDownloadCompletitionBlock:(DMNetworkHelperDownloadTaskFinishBlock)finishBlock;

#pragma mark - method for rewrite
- (DMNetworkHelperTaskRequestType)requestType;
- (DMNetworkHelperTaskResponseType)responseType;
- (NSString *)absolutePath;
- (NSString *)path;
- (DMNetworkHelperTaskMethod) method;
- (NSString *)itemsKey;
- (BOOL)databaseIsUsing;

- (id)parseItem:(NSDictionary *)itemInfo;
- (id)parseItem:(NSDictionary *)itemInfo inLocalContext:(NSManagedObjectContext *)localContext;

- (NSString *)afterDownloadFileAtTmpPath:(NSString *)tmpPath withResponse:(NSHTTPURLResponse *)response;

@end
