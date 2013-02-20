//
//  UIView+FindUIViewController.m
//  ShiKeBang
//
//  Created by Yorgo Sun on 12-8-10.
//  Copyright (c) 2012年 ZeroSmart. All rights reserved.
//

#import "UIView+FindUIViewController.h"

@implementation UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end