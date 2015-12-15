//
//  SimpleLoadTask.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 02.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "SimpleLoadTask.h"

@implementation SimpleLoadTask

- (NSString *)relativePath {
    return @"api/contacts";
}

- (DMNetworkHelperTaskMethod)method {
    return DMNetworkHelperTaskMethod_GET;
}

- (NSString *)itemsKey {
    return @"*";
}

- (id)parseItem:(NSDictionary *)itemInfo {
    
    return itemInfo;
}

@end
