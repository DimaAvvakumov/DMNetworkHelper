//
//  DMNetworkHelperRequestTask.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMNetworkHelperBasicTask.h"

typedef void (^DMNetworkHelperRequestTaskFinishBlock)(id result, NSError *error);

@interface DMNetworkHelperRequestTask : DMNetworkHelperBasicTask

- (void)executeWithCompletitionBlock:(DMNetworkHelperRequestTaskFinishBlock)finishBlock;

@end
