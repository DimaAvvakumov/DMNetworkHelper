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
    return @"1.0/feed";
}

- (DMNetworkHelperTaskMethod)method {
    return DMNetworkHelperTaskMethod_GET;
}

- (DMNetworkHelperResponseOptions)responseOptions {
    return DMNetworkHelperResponseOptionJsonEmptyAvaliable | DMNetworkHelperResponseOptionResultIsArray;
}

- (NSString *)findByKey {
    return @"result.items";
}

- (void)parseResponseWithFinishBlock:(void (^)(id))finishParseBlock {
    
    finishParseBlock( self.allItems );
}

@end
