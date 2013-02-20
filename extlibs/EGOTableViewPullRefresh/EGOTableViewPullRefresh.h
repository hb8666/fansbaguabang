//
//  EGOTableViewPullRefresh.h
//  baguabang
//
//  Created by Yorgo Sun on 13-2-18.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#ifndef baguabang_EGOTableViewPullRefresh_h
#define baguabang_EGOTableViewPullRefresh_h

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,
} EGOPullRefreshState;

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#endif
