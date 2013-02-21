//
//  YeJieViewController.m
//  baguabang
//
//  Created by Yorgo Sun on 13-2-1.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import "YeJieViewController.h"

@interface YeJieViewController ()

@end

@implementation YeJieViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
}



-(void)loadData
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&c=2&page=%d", APIMAKER(API_URL_LIST),currentPage]]];
    request.delegate = self;
    [request startAsynchronous];
}



@end
