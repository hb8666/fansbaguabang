//
//  NetImageView.m
//  ShoppingMall
//
//  Created by shaoxuan sun on 12-3-16.
//  Copyright (c) 2012年 Fans Media Co., Ltd. All rights reserved.
//

#import "NetImageView.h"

@implementation NetImageView
@synthesize httpRequest;

- (void)getImageFromURL:(NSString *)urlstring
{
    
    self.image = nil;
    NSURL *url = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    self.httpRequest = request;
    [request startAsynchronous];
}

#pragma mark - ASIHttpRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if ([[request responseData] length] > 0)
    {
        UIImage *retImage = [UIImage imageWithData:[request responseData]];
        self.image = retImage;
        
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
}

- (void)dealloc
{
    [httpRequest clearDelegatesAndCancel];
    self.httpRequest = nil;
    self.image = nil;
    [super dealloc];
}


@end
