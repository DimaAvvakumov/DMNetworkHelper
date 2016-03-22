//
//  DMNetworkHelperBasicTaskProtected.h
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 15.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#ifndef DMNetworkHelperBasicTaskProtected_h
#define DMNetworkHelperBasicTaskProtected_h

@protocol DMNetworkHelperBasicTaskProtected <NSObject>

- (void) finish;
- (NSString *) methodString;

- (id)findInJson:(id)json byKey:(NSString *)key;

@end

@interface DMNetworkHelperBasicTask (Protected) <DMNetworkHelperBasicTaskProtected>

@end


#endif /* DMNetworkHelperBasicTaskProtected_h */
