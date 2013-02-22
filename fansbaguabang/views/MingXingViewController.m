//
//  MingXingViewController.m
//  baguabang
//
//  Created by Yorgo Sun on 13-2-1.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import "MingXingViewController.h"
#import "ImageLoopView.h"
#import "NetImageView.h"
#import "ArticleDetailViewController.h"


@interface MingXingViewController ()

@end

@implementation MingXingViewController

@synthesize imageLoopView;

- (void)viewDidLoad
{
   
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //推荐图
    
    ImageLoopView *loopView = [[ImageLoopView alloc]initWithFrame:CGRectMake(0, 0, 320, 158) andImageListURL:APIMAKER(API_URL_TUIJIAN)];
    mainTableView.tableHeaderView = loopView;
    self.imageLoopView = loopView;
    [loopView release];

}

-(void)loadData
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&c=1&page=%d", APIMAKER(API_URL_LIST),currentPage]]];
    request.delegate = self;
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy|ASIDoNotWriteToCacheCachePolicy];
    [request startAsynchronous];
}

-(void)didRefreshButtonClicked:(id)sender
{
    [super didRefreshButtonClicked:sender];
    [imageLoopView reloadData];
}
-(void)dealloc
{
    self.imageLoopView = nil;
    [super dealloc];
}

@end
