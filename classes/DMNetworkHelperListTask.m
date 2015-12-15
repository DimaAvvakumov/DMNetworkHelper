//
//  DMNetworkHelperListTask.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMNetworkHelperListTask.h"

// frameworks
#import <MagicalRecord/MagicalRecord.h>

#import "DMNetworkHelperRequestTask.h"
#import "DMNetworkHelperBasicTaskProtected.h"

#import "DMNetworkHelperManager.h"

@interface DMNetworkHelperListTask () <DMNetworkHelperRequestTaskProtocol>

@property (strong, nonatomic) NSManagedObjectContext *localContext;

@property (copy, nonatomic) DMNetworkHelperListTaskFinishBlock finishBlock;

@end

@implementation DMNetworkHelperListTask

- (void)executeWithCompletitionBlock:(DMNetworkHelperListTaskFinishBlock)finishBlock {
    self.finishBlock = finishBlock;
    
    [DM_NHM_SharedInstance addOperation:self];
}

- (void)afterSuccessResponse:(NSHTTPURLResponse *)response withObject:(id)responseObject {
    
    NSDictionary *json = (NSDictionary *) responseObject;
    NSInteger statusCode = response.statusCode;
    
    NSArray *itemsJson = nil;
    NSString *key = [self itemsKey];
    
    if ([key isEqualToString:@"*"] && [json isKindOfClass:[NSArray class]]) {
        itemsJson = (NSArray *) json;
    } else {
        NSRange dotRange = [key rangeOfString:@"."];
        NSDictionary *subDict = json;
        while (dotRange.location != NSNotFound) {
            NSString *firstKey = [key substringToIndex:dotRange.location];
            key = [key substringFromIndex:(dotRange.location + 1)];
            
            subDict = [subDict objectForKey:firstKey];
            
            dotRange = [key rangeOfString:@"."];
        }
        
        itemsJson = [subDict objectForKey:key];
    }
    
    if (itemsJson == nil || NO == [itemsJson isKindOfClass:[NSArray class]]) {
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
    
    NSInteger itemsCount = [itemsJson count];
    NSMutableArray *items = nil;
    BOOL databaseIsUsing = [self databaseIsUsing];
    
    if (databaseIsUsing) {
        NSManagedObjectContext *savingContext = [NSManagedObjectContext MR_rootSavingContext];
        self.localContext = [NSManagedObjectContext MR_contextWithParent:savingContext];
    }
    
    if (itemsCount > 0) {
        items = [NSMutableArray arrayWithCapacity:itemsCount];
        
        for (NSDictionary *itemInfo in itemsJson) {
            
            id item = nil;
            if (databaseIsUsing) {
                item = [self parseItem:itemInfo inLocalContext:self.localContext];
            } else {
                item = [self parseItem:itemInfo];
            }
            
            if (item) {
                [items addObject:item];
            }
        }
    }
    
    // save context
    [self.localContext MR_saveToPersistentStoreAndWait];
    
    if (_finishBlock) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _finishBlock(items, nil, statusCode);
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
