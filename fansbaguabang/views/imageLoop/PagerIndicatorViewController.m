//
//  PagerIndicatorViewController.m
//  baguabang
//
//  Created by Yorgo Sun on 13-2-1.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import "PagerIndicatorViewController.h"

@interface PagerIndicatorViewController ()

@end

@implementation PagerIndicatorViewController
@synthesize whitePoint;

- (id)initWithPageNumber: (int)pagenumber
{
    self = [super init];
    if (self)
    {
        indicatorNumber = pagenumber;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    for (int i=0; i< indicatorNumber; i++)
    {
        UIImageView *dot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pager_indicator_graydot.png"]];
        dot.frame = CGRectMake(i * 12, 0, 6, 6);
        [self.view addSubview:dot];
        [dot release];
    }
    
    UIImageView *point = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pager_indicator_whitedot.png"]];
    point.frame = CGRectMake(0, 0, 6, 6);
    self.whitePoint = point;
    [self.view addSubview:point];
    [point release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPageNumber: (int)number
{
    [UIView beginAnimations:@"MovePoint" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    whitePoint.frame = CGRectMake(number*12, 0, 6, 6);
    
    [UIView commitAnimations];
}

- (void)dealloc
{
    self.whitePoint = nil;
    
    [super dealloc];
    
}

@end
