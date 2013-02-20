//
//  ImageLoopView.h
//  ShoppingMall
//
//  Created by Yorgo Sun on 12-3-26.
//  Copyright (c) 2012年 Fans Media Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "PagerIndicatorViewController.h"

@interface ImageLoopView : UIView <ASIHTTPRequestDelegate, UIScrollViewDelegate> {
    ASIHTTPRequest *httpRequest;
    NSArray *listdata;
    UIScrollView *scrollView;
    
    NSTimer *turnPageTimer;
    NSTimer *restartTurnPageTimer;
    BOOL autoScrollWaitStage;
    int imageLength;
    
    UILabel *highlightTitle;
    
    PagerIndicatorViewController *pagerIndicatorController;
}

@property (nonatomic, retain) ASIHTTPRequest *httpRequest;
@property (nonatomic, retain) NSArray *listdata;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UILabel *highlightTitle;
@property (nonatomic, retain) PagerIndicatorViewController *pagerIndicatorController;
@property (nonatomic) int imageLength;

- (id)initWithFrame:(CGRect)frame andImageListURL: (NSString *)url;
- (void)startShowImages;
@end
