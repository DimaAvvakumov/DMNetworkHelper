//
//  SimpleNetworkHelper.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 02.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimpleLoadTask.h"
#import "FileLoadTask.h"

@protocol SimpleNetworkHelper <NSObject>

- (NSOperation *) nh_simpleLoadWithFinishBlock:(DMNetworkHelperListTaskFinishBlock)finishBlock;

- (NSOperation *) nh_loadFileAtURL:(NSString *)url
                     progressBlock:(DMNetworkHelperProgressBlock)progressBlock
                   withFinishBlock:(DMNetworkHelperDownloadTaskFinishBlock)finishBlock;

@end

@interface SimpleNetworkHelper : NSObject <SimpleNetworkHelper>

@end
