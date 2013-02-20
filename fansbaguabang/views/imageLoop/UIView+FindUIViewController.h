//
//  UIView+FindUIViewController.h
//  ShiKeBang
//
//  Created by Yorgo Sun on 12-8-10.
//  Copyright (c) 2012年 ZeroSmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController;
- (id) traverseResponderChainForUIViewController;
@end
