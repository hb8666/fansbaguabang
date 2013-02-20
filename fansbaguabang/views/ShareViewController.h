//
//  ShareViewController.h
//  baguabang
//
//  Created by Yorgo Sun on 13-2-16.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ShareViewDelegate <NSObject>

- (void)didWeixinButtonClicked: (id)sender;
- (void)didWeiboButtonClicked: (id)sender;

@end

@interface ShareViewController : UIViewController
{
    
    id<ShareViewDelegate> delegate;
    
}


- (id)initWithDelegate: (id<ShareViewDelegate>)dg;


@end
