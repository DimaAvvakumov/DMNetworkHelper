//
//  SimpleNetworkHelper.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 02.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "SimpleNetworkHelper.h"

@implementation SimpleNetworkHelper

- (NSOperation *) nh_simpleLoadWithFinishBlock:(DMNetworkHelperListTaskFinishBlock)finishBlock {
    
    SimpleLoadTask *task = [[SimpleLoadTask alloc] init];
    [task executeWithCompletitionBlock:finishBlock];
    
    return task;
}

@end
