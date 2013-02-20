//
//  AppDelegate.h
//  fansbaguabang
//
//  Created by huangbiao on 13-2-19.
//  Copyright (c) 2013年 fans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate, WXApiDelegate>
{
    SinaWeibo *sinaweibo;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) SinaWeibo *sinaweibo;

@end
