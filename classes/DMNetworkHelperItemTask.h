//
//  DMNetworkHelperItemTask.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMNetworkHelperRequestTask.h"

typedef void (^DMNetworkHelperItemTaskFinishBlock)(NSArray *items, NSError *error, NSInteger statusCode);

@interface DMNetworkHelperItemTask : DMNetworkHelperRequestTask

- (void)executeWithCompletitionBlock:(DMNetworkHelperItemTaskFinishBlock)finishBlock;

@end
