//
//  SimpleLoadTask.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 02.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "SimpleLoadTask.h"

#import <StandardPaths/StandardPaths.h>

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

- (void)parseResponseWithFinishBlock:(void (^)(id, NSError *error))finishParseBlock {
    
    finishParseBlock( self.allItems, nil );
}

#pragma mark - Mock section

- (NSString *)mockResponseFilePath {
    return [[NSFileManager defaultManager] pathForResource:@"SimpleLoadTaskMock.plist"];
}

@end
