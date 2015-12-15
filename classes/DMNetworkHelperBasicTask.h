//
//  DMNetworkHelperBasicTask.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

typedef enum {
    DMNetworkHelperTaskMethod_GET,
    DMNetworkHelperTaskMethod_PUT,
    DMNetworkHelperTaskMethod_POST
} DMNetworkHelperTaskMethod;

@interface DMNetworkHelperBasicTask : NSOperation

@property (strong, nonatomic) id params;

- (NSString *)absolutePath;
- (NSString *)relativePath;
- (DMNetworkHelperTaskMethod) method;
- (NSString *)itemsKey;
- (BOOL)databaseIsUsing;

- (id)parseItem:(NSDictionary *)itemInfo;
- (id)parseItem:(NSDictionary *)itemInfo inLocalContext:(NSManagedObjectContext *)localContext;


@end
