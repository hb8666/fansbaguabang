//
//  BaseViewController.h
//  fansbaguabang
//
//  Created by huangbiao on 13-2-19.
//  Copyright (c) 2013年 fans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface BaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate, EGORefreshTableFooterDelegate>
{
    NSArray *listdata;
    UITableView *mainTableView;
    UIViewController *mainController;
    
    int currentPage;
    int totalPage;
    
    NSDate *lastRefreshTime;
    
    EGORefreshTableHeaderView *refreshHeaderView;
    EGORefreshTableFooterView *refreshFooterView;
    
    BOOL isDataLoading;
    int dataLoadingType;

    BOOL isLoop;
}
@property (nonatomic, retain) NSArray *listdata;
@property (nonatomic, retain) UITableView *mainTableView;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, retain) NSDate *lastRefreshTime;
@property (nonatomic, retain) EGORefreshTableFooterView *refreshFooterView;

- (void)setMainController: (UIViewController *)controller;
- (UIViewController *)mainController;

-(void)loadData;
@end
