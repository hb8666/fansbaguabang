//
//  NetImageView.h
//  ShoppingMall
//
//  Created by shaoxuan sun on 12-3-16.
//  Copyright (c) 2012年 Fans Media Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface NetImageView : UIImageView <ASIHTTPRequestDelegate> 
{
    ASIHTTPRequest *httpRequest;
}

@property (nonatomic, retain) ASIHTTPRequest *httpRequest;

- (void)getImageFromURL:(NSString *)urlstring;


@end
