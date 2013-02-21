//
//  ImageLoopView.m
//  ShoppingMall
//
//  Created by Yorgo Sun on 12-3-26.
//  Copyright (c) 2012年 Fans Media Co., Ltd. All rights reserved.
//

#import "ImageLoopView.h"
#import "NetImageView.h"
#import "UIView+FindUIViewController.h"
#import "ArticleDetailViewController.h"
#import "MingXingViewController.h"

@implementation ImageLoopView
@synthesize httpRequest, listdata, scrollView, imageLength, highlightTitle, pagerIndicatorController, imageUrl;

- (id)initWithFrame:(CGRect)frame andImageListURL: (NSString *)urlstring
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.scrollView = [[[UIScrollView alloc]initWithFrame:self.bounds] autorelease];
        
        scrollView.pagingEnabled = YES;
        scrollView.scrollsToTop = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.delaysContentTouches = NO;
        scrollView.backgroundColor = [UIColor blackColor];
        
        [self addSubview:scrollView];
        
        UIImageView *titleBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"highlight_title_bg.png"]];
        titleBG.frame = CGRectMake(0, self.frame.size.height-30, 320, 30);
        [self addSubview:titleBG];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 250, 30)];
        title.font = [UIFont boldSystemFontOfSize:17];
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"正在读取数据中，请稍后"; //[[listdata objectAtIndex:0] objectForKey:@"info_title"];
        [titleBG addSubview:title];
        self.highlightTitle = title;
        [title release];
        
        
        PagerIndicatorViewController *pagerController = [[PagerIndicatorViewController alloc]initWithPageNumber:[listdata count]];
        self.pagerIndicatorController = pagerController;
        pagerController.view.frame = CGRectMake(260, 12, 60, 6);
        [titleBG addSubview:pagerController.view];
        
        [pagerController release];
        
        [titleBG release];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleGesture:)];
        singleTapGesture.numberOfTapsRequired = 1;
        [scrollView addGestureRecognizer:singleTapGesture];
        [singleTapGesture release];
        
        turnPageTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollTime:) userInfo:nil repeats:YES];
        restartTurnPageTimer = nil;
        autoScrollWaitStage = YES;
        
        self.imageUrl = urlstring;
        
        NSURL *url  = [NSURL URLWithString:urlstring];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        self.httpRequest = request;
        NSLog(@"ImageLoopView");
        NSLog(@"http request: %@", urlstring);
        [request startAsynchronous];
    }
    return self;
}

- (void)reloadData
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [request setDelegate:self];
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy|ASIDoNotWriteToCacheCachePolicy];
    self.httpRequest = request;
    [request startAsynchronous];
}

#pragma mark - ASIHttpRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    self.listdata = (NSArray *)[[responseString JSONValue] objectForKey:@"data"];
    //imageLength = [listdata count];
    
    
    if ([listdata count] > 0)
    {
        //        UIViewController *controller = (UIViewController *)[self firstAvailableUIViewController];
        //        if ([controller isKindOfClass:[MainViewController class]])
        //        {
        //            [(MainViewController *)controller addLoopBar:[listdata count]];
        //        }
        [self startShowImages];
        highlightTitle.text = [[listdata objectAtIndex:0] objectForKey:@"info_title"];
        [pagerIndicatorController setTotalPage:[listdata count]];
        
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"imageLoopView: %@", error);
    //    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"无网络连接" message:@"请检查网络设置。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //    [alertView show];
}

- (void)startShowImages
{
    //首先清除所有历史数据
    NSArray *items = [scrollView subviews];
    for (UIView *view in items)
    {
        [view removeFromSuperview];
    }
    
    scrollView.contentSize = CGSizeMake(self.bounds.size.width * ([listdata count] + 2), self.bounds.size.height);
    
    NetImageView *netImageView;
    NSString *imgurl;
    int i=1;
    
    for (NSDictionary *item in listdata)
    {
        imgurl = [NSString stringWithFormat:@"%@", [item objectForKey:@"info_headpicurl"]];
        netImageView = [[NetImageView alloc]init];
        netImageView.frame = CGRectMake(self.bounds.size.width * i, 0, self.bounds.size.width, self.bounds.size.height);
        netImageView.userInteractionEnabled = YES;
        //[netImageView setData:item];
        [netImageView getImageFromURL: imgurl];
        
        [scrollView addSubview:netImageView];
        [netImageView release];
        i++;
    }
    
    NSDictionary *item = [listdata objectAtIndex:[listdata count] - 1]; //最后一个数据
    imgurl = [NSString stringWithFormat:@"%@", [item objectForKey:@"info_headpicurl"]];
    netImageView = [[NetImageView alloc]init];
    netImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    netImageView.userInteractionEnabled = YES;
    [scrollView addSubview:netImageView];
    [netImageView getImageFromURL: imgurl];
    [netImageView release];
    
    item = [listdata objectAtIndex:0]; //第一个数据
    imgurl = [NSString stringWithFormat:@"%@", [item objectForKey:@"info_headpicurl"]];
    netImageView = [[NetImageView alloc]init];
    netImageView.frame = CGRectMake(self.bounds.size.width * ([listdata count] + 1), 0, self.bounds.size.width, self.bounds.size.height);
    netImageView.userInteractionEnabled = YES;
    [scrollView addSubview:netImageView];
    [netImageView getImageFromURL: imgurl];
    
    [netImageView release];
    
    
    [scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    
    restartTurnPageTimer = nil;
    autoScrollWaitStage = NO;
    
    
}

#pragma mark UIScrollView delegate methods


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)_scrollView
{
    [self changePageLoop:scrollView];
    [self changeTitle];
    
}

- (void)changeTitle
{
    int currentpage = (int)(scrollView.contentOffset.x / self.bounds.size.width);
    
    if (currentpage == [listdata count]+1)
    {
        currentpage = 1;
    }
    else if (currentpage == 0)
    {
        currentpage = [listdata count];
    }
    
    //NSLog(@"CurrentPage: %d", currentpage);
    
    self.highlightTitle.text = [[listdata objectAtIndex:currentpage-1] objectForKey:@"info_title"];
    [self.pagerIndicatorController setPageNumber:currentpage-1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    
    autoScrollWaitStage = YES;
    if (restartTurnPageTimer != nil)
    {
        if ([restartTurnPageTimer isValid])
        {
            [restartTurnPageTimer invalidate];
        }
    }
    restartTurnPageTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reScrollTime:) userInfo:nil repeats:NO];
    
    [self changePageLoop:scrollView];
    //[self changeLoopBar:NO];
    [self changeTitle];
}


- (void)scrollTime:(id)sender
{
    if(autoScrollWaitStage)
    {
        return;
    }
    
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x + self.bounds.size.width, 0) animated:YES];
    //NSLog(@"offset: %f", (scrollView.contentOffset.x + self.bounds.size.width));
    
    //[self changePageLoop:scrollView];
    //[self changeLoopBar:YES];
}

- (void)reScrollTime:(id)sender
{
    autoScrollWaitStage = NO;
    [restartTurnPageTimer invalidate];
    restartTurnPageTimer = nil;
}

- (void)changePageLoop:(UIScrollView *)_scrollView
{
    
    int totalItemNumber = [listdata count];
    
    int width = self.bounds.size.width;
    
    int currentpage = (int)(scrollView.contentOffset.x / width);
    
    //NSLog(@"currentpage: %d ,tolpage: %d", currentpage, totalItemNumber);
    
    if (currentpage <1)
    {
        [scrollView setContentOffset:CGPointMake(width*(totalItemNumber), 0) animated:NO];
        
    }
    else if(currentpage>totalItemNumber)
    {
        [scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
    }
    
}

- (int) getCurrentPage
{
    int width = self.bounds.size.width;
    int currentpage = (int)(scrollView.contentOffset.x / width);
    return currentpage;
}


- (void)singleGesture: (id)sender
{
    int currentPage = [self getCurrentPage] - 1;
    if (currentPage == [listdata count])
    {
        currentPage = 0;
    }
    else if (currentPage == 1)
    {
        currentPage =[listdata count] - 1;
    }
    
    NSDictionary *item = [listdata objectAtIndex:currentPage];
    MingXingViewController *controller = (MingXingViewController *)[self firstAvailableUIViewController];
    
    NSString *url = [item objectForKey:@"url"];
    int articleid = [[item objectForKey:@"id"] intValue];
    
    
    ArticleDetailViewController *detailcontroller = [[ArticleDetailViewController alloc]initWithURL:url andArticleID:articleid];
    [[(UIViewController *)controller.mainController navigationController] pushViewController:detailcontroller animated:YES];
    
    [detailcontroller release];
    
}


- (void)dealloc
{
    self.httpRequest = nil;
    self.listdata = nil;
    self.scrollView = nil;
    self.highlightTitle = nil;
    self.pagerIndicatorController = nil;
    self.imageUrl = nil;
    
    [super dealloc];
}

@end
