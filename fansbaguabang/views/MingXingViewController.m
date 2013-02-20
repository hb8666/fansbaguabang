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


- (void)viewDidLoad
{
    isLoop = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)loadData
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&c=1&page=%d", APIMAKER(API_URL_LIST), currentPage]]];
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy|ASIDoNotWriteToCacheCachePolicy];
    request.delegate = self;
    [request startAsynchronous];
}

#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
    [super dealloc];
}



@end
