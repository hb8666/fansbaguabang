//
//  ArticleDetailViewController.m
//  baguabang
//
//  Created by Yorgo Sun on 13-2-4.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface ArticleDetailViewController ()

@end

@implementation ArticleDetailViewController
@synthesize articleURL, shareViewController, httpRequest, articleContent, articlePic,countList,dingLabel,caiLabel;

- (id)initWithURL: (NSString *)url andArticleID:(int)idnumber
{
    self = [super init];
    if (self)
    {
        self.articleURL = url;
        articleID = idnumber;
        contentLoaded = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //顶导航
    UIImageView *navBar = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"detail_toptoolbar.png"]];
    navBar.frame = CGRectMake(0, 0, 320, 43);
    navBar.userInteractionEnabled = YES;
    [self.view addSubview:navBar];
    
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backbuttonclicked.png"] forState:UIControlStateSelected];
    backButton.frame = CGRectMake(5, 2, 40, 40);
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    
    [navBar release];
    
    
    //内容
    UIWebView *mainView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40)];
    mainView.delegate = self;
    [mainView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:articleURL]]];
    mainView.scrollView.bounces = NO;
   
    [self.view insertSubview:mainView atIndex:0];
    
    //进度提示窗口
    MBProgressHUD *progressBox = [[MBProgressHUD alloc] initWithView:mainView];
    progressBox.tag = 999;
    [self.view addSubview:progressBox];
    [self.view bringSubviewToFront:progressBox];
    progressBox.labelText = @"加载中...";
    [progressBox show:YES];
    [progressBox release];
    
    [mainView release];
    
    [self loadArticleCount];
    
    //底部toolbar
    UIImageView *toolbar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_bottomtoolbar_bg.png"]];
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-40, 320, 40);
    toolbar.userInteractionEnabled = YES;
    [self.view addSubview:toolbar];
    
    //分享按钮
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"sharebutton.png"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(5, 0, 40, 40);
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:shareButton];
    
    
    //顶按钮
    UIButton *dingButton = [UIButton buttonWithType:UIButtonTypeCustom];
  //  UIImageView *dingButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_ding.png"]];
    [dingButton setImage:[UIImage imageNamed:@"detail_ding.png"] forState:UIControlStateNormal];
     dingButton.frame = CGRectMake(158, 13, 14, 15);
    [dingButton addTarget:self action:@selector(dingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:dingButton];
  //  [dingButton release];
    dingLabel = [[UILabel alloc] init];
    dingLabel.frame = CGRectMake(180, 13, 30, 15);
    dingLabel.font = [UIFont systemFontOfSize:15];
    dingLabel.text = @"0.0";
    dingLabel.backgroundColor = [UIColor clearColor];
    dingLabel.textColor = [UIColor grayColor];
    [toolbar addSubview:dingLabel];
    [dingLabel release];
    
    //踩按钮
     UIButton *caiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [caiButton setImage:[UIImage imageNamed:@"detail_cai.png"] forState:UIControlStateNormal];
 //   UIImageView *caiButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_cai.png"]];
    caiButton.frame = CGRectMake(247, 11, 16, 17);
    [caiButton addTarget:self action:@selector(caiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:caiButton];
 //   [caiButton release];
    caiLabel = [[UILabel alloc] init];
    caiLabel.frame = CGRectMake(270, 13, 30, 15);
    caiLabel.font = [UIFont systemFontOfSize:15];
    caiLabel.text = @"0.0";
    caiLabel.backgroundColor = [UIColor clearColor];
    caiLabel.textColor = [UIColor grayColor];
    [toolbar addSubview:caiLabel];
    
    
    [toolbar release];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.articleURL = nil;
    self.shareViewController = nil;
    self.httpRequest = nil;
    self.articlePic = nil;
    self.articleContent = nil;
    self.caiLabel = nil;
    self.dingLabel = nil;
    [super dealloc];
}

- (void)showShareWaitingBox
{
    MBProgressHUD *progressBox = [[MBProgressHUD alloc] initWithView:self.view];
    progressBox.tag = 999;
    [self.view addSubview:progressBox];
    [self.view bringSubviewToFront:progressBox];
    progressBox.labelText = @"内容分享中...";
    [progressBox show:YES];
    [progressBox release];
}

- (void)trunOffWaitingBox
{
    UIView *waitBox = [self.view viewWithTag:999];
    [waitBox removeFromSuperview];
}

- (void)loadArticleCount
{
    NSString *urlstring = [NSString stringWithFormat:@"%@&id=%d", APIMAKER(API_URL_GETARTICLECOUNT), articleID];
    NSLog(@"loadPage:%@",urlstring);
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlstring]] autorelease];
    request.delegate = self;
    request.tag = 2;
    [request startAsynchronous];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self trunOffWaitingBox];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self trunOffWaitingBox];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:[NSString stringWithFormat:@"内容加载错误 %@", error]
                                                       delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    [alertView release];
}

#pragma mark - Buttons Callback

- (void)backButtonClicked: (id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonClicked: (id)sender
{
    if (shareViewController == nil)
    {
        ShareViewController *shareController = [[ShareViewController alloc]initWithDelegate:self];
        shareController.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        self.shareViewController = shareController;
        [shareController release];
    }
    
    [self.view addSubview:shareViewController.view];
}

-(void)dingButtonClicked:(id)sender
{
    NSLog(@"ding");
    
    NSString *urlstring = [NSString stringWithFormat:@"%@&id=%d", APIMAKER(API_URL_DING), articleID];
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlstring]] autorelease];
    request.delegate = self;
    request.tag = 3;
    [request startAsynchronous];

}

-(void)caiButtonClicked:(id)sender
{
    NSString *urlstring = [NSString stringWithFormat:@"%@&id=%d", APIMAKER(API_URL_CAI), articleID];
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlstring]] autorelease];
    request.delegate = self;
    request.tag = 3;
    [request startAsynchronous];
}

#pragma mark - Sina weibo block

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)didWeiboButtonClicked: (id)sender
{
    SinaWeibo *weibo = [self sinaweibo];
    
    if (![weibo isAuthValid])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSinaWeiboUserLogined:) name:@"SinaWeiboUserLogined" object:nil];
        
        
        [weibo logIn];
    }
    else
    {
        shareType = SHARETYPE_WEIBO;
        
        if (contentLoaded)
        {
            [self sendWeiboContent];
        }
        else
        {
            [self loadShareContent];
        }
    }
    
}

- (void)didSinaWeiboUserLogined: (id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SinaWeiboUserLogined" object:nil];
    
    shareType = SHARETYPE_WEIBO;
    
    if (contentLoaded)
    {
        [self sendWeiboContent];
    }
    else
    {
        [self loadShareContent];
    }
}


- (void)sendWeiboContent
{
    SinaWeibo *weibo = [self sinaweibo];
    
    NSString *content = [NSString stringWithFormat:@"分享八卦帮娱乐新闻：《%@》%@", [articleContent objectForKey:@"info_title"], [articleContent objectForKey:@"share_url"]];
    
    if (articlePic != nil)
    {
        [weibo requestWithURL:@"statuses/upload.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:content, @"status", articlePic, @"pic", nil]
                   httpMethod:@"POST"
                     delegate:self];
    }
    else
    {
        [weibo requestWithURL:@"statuses/update.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:content, @"status", nil]
                       httpMethod:@"POST"
                         delegate:self];
    }
    
    [self showShareWaitingBox];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [self trunOffWaitingBox];
    
    if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:[NSString stringWithFormat:@"分享微博出错 %@", error]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:[NSString stringWithFormat:@"分享微博出错 %@", error]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [self trunOffWaitingBox];
    
    if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"成功分享微博！"
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知"
                                                            message:@"成功分享微博！"
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
    }
}

#pragma mark - WeiXin block

- (void)didWeixinButtonClicked:(id)sender
{
    shareType = SHARETYPE_WEIXIN;
    
    if (contentLoaded)
    {
        [self sendWeixinContent];
    }
    else
    {
        [self loadShareContent];
    }
}

- (void)sendWeixinContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [articleContent objectForKey:@"info_title"];
    message.description = [articleContent objectForKey:@"info_content"];
    
    if (articlePic != nil)
    {
        [message setThumbImage:articlePic];
    }
    
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [articleContent objectForKey:@"share_url"];
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

#pragma mark - Network Loading

- (void)loadShareContent
{
    
    if (!contentLoaded)
    {
        NSString *urlstring = [NSString stringWithFormat:@"%@&id=%d", APIMAKER(API_URL_SHARECONTENT), articleID];
        
        NSLog(@"%@", urlstring);
        
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlstring]];
        [request setDelegate:self];
        
        networkLoadStage = 0; //开始读取文本内容
        
        [request startAsynchronous];
        self.httpRequest = request;
        [request release];
    }
    
}

-(void)setCountList:(NSArray *)countList
{
   
    dingLabel.text = [NSString stringWithFormat:@"%@", [countList valueForKey:@"ding_counts"]];
    caiLabel.text = [NSString stringWithFormat:@"%@", [countList valueForKey:@"cai_counts"]];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 2)
    {
        NSString *responseString = [request responseString];
        NSRange result = [responseString rangeOfString:@"false"];
        
        if (result.location == NSNotFound) {
            self.countList = (NSArray *)[responseString JSONValue];
            NSLog(@"result:%@",responseString);
        }
        
        return;
    }else if (request.tag = 3)
    {
        NSString *responseString = [request responseString];
        NSLog(@"是否成功: %@",responseString);
       
            [self loadArticleCount];
    
        return;
    }
    
    
    if (networkLoadStage == 0)
    {
        NSString *responseString = [request responseString];
        NSLog(@"%@", responseString);
        
        NSDictionary *contentData = [responseString JSONValue];
        self.articleContent = contentData;
        
        NSString *picurl = [articleContent objectForKey:@"info_picurl"];
        
        if (picurl != nil && [picurl length] > 0)
        {
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:picurl]];
            request.delegate = self;
            
            networkLoadStage = 1;
            [request startAsynchronous];
            
            self.httpRequest = request;
            [request release];
        }
        else
        {
            self.articlePic = nil;
            contentLoaded = YES;
        }
    }
    else if (networkLoadStage == 1)
    {
        NSData *responseData = [request responseData];
        UIImage *tmp = [UIImage imageWithData:responseData];
        self.articlePic = tmp;
        contentLoaded = YES;
    }
    
    if (contentLoaded)
    {
        if (shareType == SHARETYPE_WEIBO)
        {
            [self sendWeiboContent];
        }
        else if (shareType == SHARETYPE_WEIXIN)
        {
            [self sendWeixinContent];
        }
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@", request.error);
}

@end
