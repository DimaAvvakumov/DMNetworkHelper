//
//  DMNetworkHelperRequestTask.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMNetworkHelperBasicTask.h"

@protocol DMNetworkHelperRequestTaskProtocol <NSObject>

- (void)afterSuccessResponse:(NSHTTPURLResponse *)response withObject:(id)responseObject;
- (void)afterFailureResponse:(NSHTTPURLResponse *)response withError: (NSError *)error;

@end

@interface DMNetworkHelperRequestTask : DMNetworkHelperBasicTask

@end
