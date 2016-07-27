//
//  SimpleNetworkHelper.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 02.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "SimpleNetworkHelper.h"

@implementation SimpleNetworkHelper

- (NSOperation *) nh_simpleLoadWithFinishBlock:(DMNetworkHelperRequestTaskFinishBlock)finishBlock {
    
    // create
    SimpleLoadTask *task = [[SimpleLoadTask alloc] init];
    
    // mock
#ifdef MOCK_ENVIROMENT
    task.isMock = YES;
#endif
    
    // execute
    [task executeWithCompletitionBlock:finishBlock];
    
    return task;
}

- (NSOperation *) nh_loadFileAtURL:(NSString *)url
                     progressBlock:(DMNetworkHelperProgressBlock)progressBlock
                   withFinishBlock:(DMNetworkHelperDownloadTaskFinishBlock)finishBlock {
    
    FileLoadTask *task = [[FileLoadTask alloc] init];
    
    task.params = @{@"url": url};
    
    [task executeWithProgressBlock:progressBlock andCompletitionBlock:finishBlock];
    
    return task;
    
}

@end
