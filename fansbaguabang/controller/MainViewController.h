//
//  MainViewController.h
//  baguabang
//
//  Created by Yorgo Sun on 13-1-29.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "MingXingViewController.h"
#import "YeJieViewController.h"
#import "JiZheViewController.h"

typedef enum {
    BottomToolbarStatusMingXing = 900001,
    BottomToolbarStatusYeJie = 900002,
    BottomToolbarStatusJiZhe = 900003

} BottomToolbarStatus;

@interface MainViewController : UIViewController
{
    
    MingXingViewController *mingxingController;
    YeJieViewController *yejieController;
    JiZheViewController *jizheController;
       int toolbarStatus;
    
}

@property (nonatomic, retain) MingXingViewController *mingxingController;
@property (nonatomic, retain) YeJieViewController *yejieController;
@property (nonatomic, retain) JiZheViewController *jizheController;

@end
