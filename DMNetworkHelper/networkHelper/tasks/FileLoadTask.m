//
//  FileLoadTask.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "FileLoadTask.h"

@implementation FileLoadTask

- (NSString *)absolutePath {
    return [self.params objectForKey:@"url"];
}

- (DMNetworkHelperTaskMethod)method {
    return DMNetworkHelperTaskMethod_GET;
}

@end
