//
//  UIViewController+DMNetworkHelper.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 24.03.16.
//  Copyright © 2016 Dmitry Avvakumov. All rights reserved.
//

#import "UIViewController+DMNetworkHelper.h"

#import <objc/runtime.h>

static char networkHelpersKey;

static void UIViewController_DMNetworkHelper_swizzleInstanceMethod(Class c, SEL original, SEL replacement)
{
    Method a = class_getInstanceMethod(c, original);
    Method b = class_getInstanceMethod(c, replacement);
    if (class_addMethod(c, original, method_getImplementation(b), method_getTypeEncoding(b)))
    {
        class_replaceMethod(c, replacement, method_getImplementation(a), method_getTypeEncoding(a));
    }
    else
    {
        method_exchangeImplementations(a, b);
    }
    
}

@implementation UIViewController (DMNetworkHelper)

- (NSArray *)networkHelpers {
    return objc_getAssociatedObject(self, &networkHelpersKey);
}

- (void)setNetworkHelpers:(NSArray *)networkHelpers {
    objc_setAssociatedObject(self, &networkHelpersKey, networkHelpers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    UIViewController_DMNetworkHelper_swizzleInstanceMethod(self, @selector(init), @selector(networkHelper_init));
    UIViewController_DMNetworkHelper_swizzleInstanceMethod(self, @selector(initWithCoder:), @selector(networkHelper_initWithCoder:));
    UIViewController_DMNetworkHelper_swizzleInstanceMethod(self, @selector(initWithNibName:bundle:), @selector(networkHelper_initWithNibName:bundle:));
}

- (id)networkHelper_init{
    id selfObject = [self networkHelper_init];
    
    NSArray *helpers = [self nh_listOfHelpers];
    //    NSAssert(helpers != nil, @"Network helper list of helpers");
    
    [selfObject setNetworkHelpers:helpers];
    
    return selfObject;
}

- (id)networkHelper_initWithCoder:(NSCoder *)aDecoder{
    id selfObject = [self networkHelper_initWithCoder:aDecoder];
    
    NSArray *helpers = [self nh_listOfHelpers];
//    NSAssert(helpers != nil, @"Network helper list of helpers");
    
    [selfObject setNetworkHelpers:helpers];
    
    return selfObject;
}

- (id)networkHelper_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    id selfObject = [self networkHelper_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    NSArray *helpers = [self nh_listOfHelpers];
    //    NSAssert(helpers != nil, @"Network helper list of helpers");
    
    [selfObject setNetworkHelpers:helpers];
    
    return selfObject;
}

#pragma mark - Forvarding

-(id)forwardingTargetForSelector:(SEL)sel {
    NSArray *forwardingTargets = [self networkHelpers];
    if (forwardingTargets == nil) return nil;
    
    for (id candidate in forwardingTargets)
        if ([candidate respondsToSelector:sel])
            return candidate;
    
    return [super forwardingTargetForSelector:sel];
}

#pragma mark - Override

- (NSArray *) nh_listOfHelpers {
    return nil;
}

@end
