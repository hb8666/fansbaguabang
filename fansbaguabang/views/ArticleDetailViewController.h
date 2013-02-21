//
//  ArticleDetailViewController.h
//  baguabang
//
//  Created by Yorgo Sun on 13-2-4.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewController.h"
#import "SinaWeibo.h"
#import "WXApi.h"
#import "ASIHTTPRequest.h"

typedef enum
{
    SHARETYPE_WEIBO = 1,
    SHARETYPE_WEIXIN = 2,
} SHARETYPE;

@interface ArticleDetailViewController : UIViewController <ShareViewDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate, UIWebViewDelegate>
{
    NSString *articleURL;
    int articleID;
    
    ShareViewController *shareViewController;
    
    BOOL contentLoaded;
    int networkLoadStage;
    ASIHTTPRequest *httpRequest;
    
    NSDictionary *articleContent;
    UIImage *articlePic;
    
    SHARETYPE shareType;
        
    NSArray *countList;
}

@property (retain, nonatomic) NSString *articleURL;
@property (retain, nonatomic) ShareViewController *shareViewController;
@property (nonatomic, retain) ASIHTTPRequest *httpRequest;
@property (nonatomic, retain) NSDictionary *articleContent;
@property (nonatomic, retain) UIImage *articlePic;
@property (nonatomic, retain) UILabel *dingLabel;
@property (nonatomic, retain) UILabel *caiLabel;
@property (nonatomic, retain) NSArray *countList;

- (void)setCountList:(NSArray *)countList;
- (id)initWithURL: (NSString *)url andArticleID: (int)idnumber;

@end
