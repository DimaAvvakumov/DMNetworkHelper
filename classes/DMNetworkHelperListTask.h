//
//  DMNetworkHelperListTask.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMNetworkHelperRequestTask.h"

typedef void (^DMNetworkHelperListTaskFinishBlock)(NSArray *items, NSError *error, NSInteger statusCode);

@interface DMNetworkHelperListTask : DMNetworkHelperRequestTask

- (void)executeWithCompletitionBlock:(DMNetworkHelperListTaskFinishBlock)finishBlock;

@end
