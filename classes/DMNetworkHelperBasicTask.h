//
//  DMNetworkHelperBasicTask.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext, AFHTTPRequestSerializer;

typedef enum {
    DMNetworkHelperTaskMethod_GET,
    DMNetworkHelperTaskMethod_PUT,
    DMNetworkHelperTaskMethod_POST,
    DMNetworkHelperTaskMethod_DELETE
} DMNetworkHelperTaskMethod;

/**
 Defines "options" for parse response in a bitmask.
 
 */
typedef NS_ENUM (NSUInteger, DMNetworkHelperResponseOptions)
{
    /** Empty response avaliability */
    DMNetworkHelperResponseOptionJsonEmptyAvaliable = 1 << 0,
    
    /** Check result as array */
    DMNetworkHelperResponseOptionResultIsArray = 1 << 1,
    
    /** Check result as dictionary */
    DMNetworkHelperResponseOptionResultIsDictionary = 1 << 2,
    
    /** Check result as html */
    DMNetworkHelperResponseOptionResultIsHTML = 1 << 3,
    
    /** Pass response with server error */
    DMNetworkHelperResponseOptionPassServerError = 1 << 4,

};

@interface DMNetworkHelperBasicTask : NSOperation

@property (strong, nonatomic) id params;

/**
 The dispatch queue for `completionBlock`. If `NULL` (default), the main queue is used.
 */
@property (nonatomic, strong) dispatch_queue_t completionQueue;

/**
 Custom request serializer for current task
 */
@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;

/**
 Use as mock request
 */
@property (nonatomic, assign) BOOL isMock;

/**
 * Request params
 *
 */
- (NSString *)absolutePath;
- (NSString *)relativePath;
- (DMNetworkHelperTaskMethod) method;
- (NSTimeInterval)timeoutInterval;

/**
 * Default mock settings
 *
 */
- (NSTimeInterval)mockRequestDuration;
- (NSString *)mockResponseFilePath;

@property (weak, nonatomic) NSURLSessionTask *dataTask;

/**
 * Response params
 *
 */
@property (strong, nonatomic) NSURLResponse *response;
@property (strong, nonatomic) id responseObject;
@property (assign, nonatomic) NSInteger statusCode;

@property (strong, nonatomic) NSArray *allItems;
@property (strong, nonatomic) NSDictionary *oneItem;
@property (strong, nonatomic) NSString *htmlItem;

@property (strong, nonatomic) NSError *responseError;

- (DMNetworkHelperResponseOptions)responseOptions;

- (NSString *)findByKey;

- (void)parseResponseWithFinishBlock:(void(^)(id result, NSError *error))finishParseBlock;


@end
