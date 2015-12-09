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

typedef enum {
    DMNetworkHelperTaskMethod_GET,
    DMNetworkHelperTaskMethod_PUT,
    DMNetworkHelperTaskMethod_POST
} DMNetworkHelperTaskMethod;

typedef enum {
    DMNetworkHelperTaskResponseType_List,
    DMNetworkHelperTaskResponseType_Item
} DMNetworkHelperTaskResponseType;

@interface DMNetworkHelperTaskOperation : NSOperation

#pragma mark - params

@property (strong, nonatomic) id params;

- (void)executeWithCompletitionBlock:(DMNetworkHelperListTaskFinishBlock)finishBlock;

#pragma mark - method for rewrite
- (DMNetworkHelperTaskResponseType)responseType;
- (NSString *)path;
- (DMNetworkHelperTaskMethod) method;
- (NSString *)itemsKey;
- (BOOL)databaseIsUsing;

- (id)parseItem:(NSDictionary *)itemInfo;
- (id)parseItem:(NSDictionary *)itemInfo inLocalContext:(NSManagedObjectContext *)localContext;

@end
