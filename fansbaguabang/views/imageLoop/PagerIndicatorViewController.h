//
//  PagerIndicatorViewController.h
//  baguabang
//
//  Created by Yorgo Sun on 13-2-1.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagerIndicatorViewController : UIViewController
{
    int indicatorNumber;
    UIImageView *whitePoint;
}

@property (nonatomic, retain) UIImageView *whitePoint;

- (id)initWithPageNumber: (int)pagenumber;
- (void)setPageNumber: (int)number;
- (void)setTotalPage: (int)totalpage;

@end
