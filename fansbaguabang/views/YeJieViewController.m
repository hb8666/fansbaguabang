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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setMainController:(UIViewController *)controller
{
    mainController = controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)loadData
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&c=2", APIMAKER(API_URL_LIST)]]];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.mainTableView = nil;
    self.listdata = nil;
    [super dealloc];
}

@end
