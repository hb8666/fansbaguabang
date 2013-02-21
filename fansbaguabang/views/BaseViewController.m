//
//  BaseViewController.m
//  fansbaguabang
//
//  Created by huangbiao on 13-2-19.
//  Copyright (c) 2013年 fans. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageLoopView.h"
#import "NetImageView.h"
#import "ArticleDetailViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize listdata, mainTableView, refreshHeaderView, lastRefreshTime, refreshFooterView,mainController;

- (id)init
{
    self = [super init];
    if (self)
    {
        currentPage = 1;
        totalPage = 1;
        isDataLoading = NO;
       
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-83) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    
    [self.view addSubview:tableView];
    self.mainTableView = tableView;
    
   
           //列表刷新头
    if (refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableView.bounds.size.height, self.view.frame.size.width, tableView.bounds.size.height)];
		view.delegate = self;
		[tableView addSubview:view];
		self.refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[refreshHeaderView refreshLastUpdatedDate];
    
    [tableView release];
    
    [self loadData];
    
    isDataLoading = YES;
    
}

-(void)loadData
{
    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *responseString = [request responseString];
    if (dataLoadingType == 0)
    {
        self.listdata = (NSArray *)[[responseString JSONValue] objectForKey:@"data"];
    }
    else
    {
        self.listdata = [self.listdata arrayByAddingObjectsFromArray:(NSArray *)[[responseString JSONValue] objectForKey:@"data"]];
    }
    
    currentPage = [[[responseString JSONValue] objectForKey:@"page_now"] intValue];
    totalPage = [[[responseString JSONValue] objectForKey:@"page_count"] intValue];
    
    self.lastRefreshTime = [NSDate date];
    
    [mainTableView reloadData];
    [self updateFooterView];
    [self doneLoadingTableViewData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
    //UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"无网络连接" message:@"请检查网络设置。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //[alertView show];
    [self doneLoadingTableViewData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listdata count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
 //   cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
  //解决缓存导致的数据问题..
    cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d",[[[listdata objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]]];
    
    if (cell == nil)
    {
      //  cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]] autorelease];
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%d", [[[listdata objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]]] autorelease];
        cell.backgroundView = nil;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 290, 30)];
        
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0];
        title.backgroundColor = [UIColor clearColor];
        title.text = [[listdata objectAtIndex:indexPath.row] objectForKey:@"info_title"];
        [cell.contentView addSubview:title];
        [title release];
        
        
        
        NSArray *imgs = [[listdata objectAtIndex:indexPath.row] objectForKey:@"info_picurl"];
        
        if ([imgs count] > 1)
        {
            int i=0;
            
            for (NSString *imgurl in imgs)
            {
                NetImageView *imageView = [[NetImageView alloc]initWithFrame:CGRectMake(15+i*97, 35, 90, 60)];
                [cell.contentView addSubview:imageView];
                [imageView getImageFromURL:imgurl];
                [imageView release];
                i++;
            }
        }
        else if ([imgs count] > 0)
        {
            NetImageView *imageView = [[NetImageView alloc]initWithFrame:CGRectMake(15, 35, 90, 60)];
            [cell.contentView addSubview:imageView];
            [imageView getImageFromURL:[imgs objectAtIndex:0]];
            [imageView release];
            
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(115, 28, 190, 55)];
            content.font = [UIFont systemFontOfSize:11];
            content.textColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0];
            content.backgroundColor = [UIColor clearColor];
            //content.lineBreakMode = UILineBreakModeWordWrap;
            content.numberOfLines = 3;
            content.text = [[listdata objectAtIndex:indexPath.row] objectForKey:@"info_diggest"];
            //[content sizeToFit];
            
            [cell.contentView addSubview:content];
            [content release];
            
        }
        
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"table selected");
    
    NSString *url = [[listdata objectAtIndex:indexPath.row] objectForKey:@"url"];
    int articleid = [[[listdata objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    
    ArticleDetailViewController *controller = [[ArticleDetailViewController alloc]initWithURL:url andArticleID:articleid];
    [mainController.navigationController pushViewController:controller animated:YES];
    
    [controller release];
    
}

- (void)didRefreshButtonClicked: (id)sender
{
    [mainTableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
  
}

- (void)doneManualRefresh
{
    [refreshHeaderView egoRefreshScrollViewDidScroll:mainTableView];
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:mainTableView];
}

- (void)updateFooterView
{
    //列表刷新尾 测试
    if (refreshFooterView == nil)
    {
        
        EGORefreshTableFooterView *footerView = [[EGORefreshTableFooterView alloc]initWithFrame:CGRectMake(0, mainTableView.contentSize.height, self.view.frame.size.width, mainTableView.bounds.size.height)];
        footerView.delegate = self;
        [mainTableView addSubview:footerView];
        self.refreshFooterView = footerView;
        [footerView release];
    }
    else
    {
        refreshFooterView.frame = CGRectMake(0, mainTableView.contentSize.height, self.view.frame.size.width, mainTableView.bounds.size.height);
    }
    
    [refreshFooterView refreshLastUpdatedDate];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.mainTableView = nil;
    self.listdata = nil;
    self.refreshHeaderView = nil;
    self.lastRefreshTime = nil;
    [super dealloc];
}

#pragma mark - egoRefreshTableHeaderView Interface Methods


- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    NSLog(@"total: %d", totalPage);
    
	if (dataLoadingType == 0)
    {
        
        isDataLoading = YES;
        currentPage = 1;
        /*
        NSLog(@"%@", [NSString stringWithFormat:@"%@&c=1&page=%d", APIMAKER(API_URL_LIST), currentPage]);
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&c=1&page=%d", APIMAKER(API_URL_LIST), currentPage]]];
        [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy|ASIDoNotWriteToCacheCachePolicy];
        request.delegate = self;
        [request startAsynchronous];
         */
[self loadData];
	}
    else if (dataLoadingType == 1)
    {
        if (currentPage == totalPage)
        {
            isDataLoading = YES;
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
        }
        else
        {
            isDataLoading = YES;
            currentPage++;
            /*
            NSLog(@"%@", [NSString stringWithFormat:@"%@&c=1&page=%d", APIMAKER(API_URL_LIST), currentPage]);
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&c=1&page=%d", APIMAKER(API_URL_LIST), currentPage]]];
            [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy|ASIDoNotWriteToCacheCachePolicy];
            request.delegate = self;
            [request startAsynchronous];
             */
            [self loadData];
        }
    }
}

- (void)doneLoadingTableViewData
{
    isDataLoading = NO;
    if (dataLoadingType == 0)
    {
        [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainTableView];
    }
    else if (dataLoadingType == 1)
    {
        [refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainTableView];
    }
}

#pragma mark - egoRefreshTableHeaderViewDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    dataLoadingType = 0;
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return isDataLoading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	
    NSDate *time;
    
    if (lastRefreshTime == nil)
    {
        time = [NSDate date];
    }
    else
    {
        time = lastRefreshTime;
    }
    
	return time; // should return date data source was last changed
	
}

#pragma mark - egoRefreshTableFooterViewDelegate

- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    dataLoadingType = 1;
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return isDataLoading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	
    NSDate *time;
    
    if (lastRefreshTime == nil)
    {
        time = [NSDate date];
    }
    else
    {
        time = lastRefreshTime;
    }
    
	return time; // should return date data source was last changed
	
}


@end
