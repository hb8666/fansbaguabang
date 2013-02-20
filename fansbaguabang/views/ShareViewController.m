//
//  ShareViewController.m
//  baguabang
//
//  Created by Yorgo Sun on 13-2-16.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController


- (id)initWithDelegate:(id<ShareViewDelegate>)dg
{
    self = [super init];
    if (self)
    {
        delegate = dg;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.backgroundColor = [UIColor grayColor];
    bgView.alpha = 0.5;
    
    [self.view addSubview:bgView];
    [bgView release];
    
    UIView *shareBGView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 240, 320, 240)];
    shareBGView.backgroundColor = [UIColor whiteColor];
    shareBGView.userInteractionEnabled = YES;
    
    UILabel *shareTitle = [[UILabel alloc]initWithFrame:CGRectMake(135, 20, 320, 100)];
    shareTitle.font = [UIFont boldSystemFontOfSize:20];
    shareTitle.backgroundColor = [UIColor clearColor];
    shareTitle.text = @"分享到";
    shareTitle.textColor = [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0];
    [shareBGView addSubview:shareTitle];
    [shareTitle sizeToFit];
    [shareTitle release];
    
    UIButton *shareButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton1 setImage:[UIImage imageNamed:@"share_weibo.png"] forState:UIControlStateNormal];
    shareButton1.frame = CGRectMake(20, 63, 49, 36);
    [shareButton1 addTarget:self action:@selector(shareWeiboButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareBGView addSubview:shareButton1];
    
    UILabel *shareBT1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 105, 80, 50)];
    shareBT1.font = [UIFont systemFontOfSize:12];
    shareBT1.backgroundColor = [UIColor clearColor];
    shareBT1.textColor = [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0];
    shareBT1.text = @"新浪微博";
    [shareBGView addSubview:shareBT1];
    [shareBT1 sizeToFit];
    [shareBT1 release];
    
    
    UIButton *shareButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton2 setImage:[UIImage imageNamed:@"share_weixin.png"] forState:UIControlStateNormal];
    shareButton2.frame = CGRectMake(100, 63, 49, 36);
    [shareButton2 addTarget:self action:@selector(shareWeixinButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareBGView addSubview:shareButton2];
    
    UILabel *shareBT2 = [[UILabel alloc]initWithFrame:CGRectMake(112, 105, 80, 50)];
    shareBT2.font = [UIFont systemFontOfSize:12];
    shareBT2.backgroundColor = [UIColor clearColor];
    shareBT2.textColor = [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0];
    shareBT2.text = @"微信";
    [shareBGView addSubview:shareBT2];
    [shareBT2 sizeToFit];
    [shareBT2 release];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"cancelbutton.png"] forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(59, 170, 202, 47);
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareBGView addSubview:cancelButton];
    
    [self.view addSubview:shareBGView];
    [shareBGView release];
}


- (void)cancelButtonClicked: (id)sender
{
    [self.view removeFromSuperview];
}

- (void)shareWeiboButtonClicked: (id)sender
{
    [self.view removeFromSuperview];
    [delegate performSelector:@selector(didWeiboButtonClicked:)];
}


- (void)shareWeixinButtonClicked: (id)sender
{
    [self.view removeFromSuperview];
    [delegate performSelector:@selector(didWeixinButtonClicked:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
