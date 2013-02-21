//
//  MingXingViewController.h
//  baguabang
//
//  Created by Yorgo Sun on 13-2-1.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ImageLoopView.h"
@interface MingXingViewController : BaseViewController
{
    ImageLoopView *imageViewLoop;

}

@property (nonatomic,retain) ImageLoopView *imageLoopView;

@end
