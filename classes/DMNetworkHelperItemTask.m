//
//  DMNetworkHelperItemTask.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMNetworkHelperItemTask.h"

// frameworks
#import <MagicalRecord/MagicalRecord.h>

#import "DMNetworkHelperRequestTask.h"
#import "DMNetworkHelperBasicTaskProtected.h"

#import "DMNetworkHelperManager.h"

@interface DMNetworkHelperItemTask () <DMNetworkHelperRequestTaskProtocol>

@property (strong, nonatomic) NSManagedObjectContext *localContext;

@property (copy, nonatomic) DMNetworkHelperItemTaskFinishBlock finishBlock;

@end

@implementation DMNetworkHelperItemTask

- (void)executeWithCompletitionBlock:(DMNetworkHelperItemTaskFinishBlock)finishBlock {
    self.finishBlock = finishBlock;
    
    [DM_NHM_SharedInstance addOperation:self];
}

- (void)afterSuccessResponse:(NSHTTPURLResponse *)response withObject:(id)responseObject {
    
    NSDictionary *json = (NSDictionary *) responseObject;
    NSInteger statusCode = response.statusCode;
    
    NSDictionary *itemJson = nil;
    NSString *key = [self itemsKey];
    
    if ([key isEqualToString:@"*"] && [json isKindOfClass:[NSDictionary class]]) {
        itemJson = (NSDictionary *) json;
    } else {
        NSRange dotRange = [key rangeOfString:@"."];
        NSDictionary *subDict = json;
        while (dotRange.location != NSNotFound) {
            NSString *firstKey = [key substringToIndex:dotRange.location];
            key = [key substringFromIndex:(dotRange.location + 1)];
            
            subDict = [subDict objectForKey:firstKey];
            
            dotRange = [key rangeOfString:@"."];
        }
        
        itemJson = [subDict objectForKey:key];
    }
    
    if (itemJson == nil || NO == [itemJson isKindOfClass:[NSDictionary class]]) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Wrong server response" };
        NSError *error = [NSError errorWithDomain:DM_NHM_SharedInstance.url code:-1 userInfo:userInfo];
        
        if (_finishBlock) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _finishBlock(nil, error, statusCode);
            });
        }
        
        [self finish];
        
        return;
    }
    
    BOOL databaseIsUsing = [self databaseIsUsing];
    
    if (databaseIsUsing) {
        NSManagedObjectContext *savingContext = [NSManagedObjectContext MR_rootSavingContext];
        self.localContext = [NSManagedObjectContext MR_contextWithParent:savingContext];
    }
    
    id item = nil;
    NSDictionary *itemInfo = itemJson;
    if (databaseIsUsing) {
        item = [self parseItem:itemInfo inLocalContext:self.localContext];
    } else {
        item = [self parseItem:itemInfo];
    }
    
    // save context
    [self.localContext MR_saveToPersistentStoreAndWait];
    
    if (_finishBlock) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _finishBlock(item, nil, statusCode);
        });
    }
    
    [self finish];
}

- (void)afterFailureResponse:(NSHTTPURLResponse *)response withError:(NSError *)error {
    
    NSInteger statusCode = response.statusCode;
    
    if (_finishBlock) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _finishBlock(nil, error, statusCode);
        });
    }
    
    [self finish];
}

@end
