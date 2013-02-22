//
//  MainViewController.m
//  baguabang
//
//  Created by Yorgo Sun on 13-1-29.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "ImageLoopView.h"
#import "SetupViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize mingxingController,jizheController,yejieController;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        MingXingViewController *mingxing = [[MingXingViewController alloc]init];
        [mingxing setMainController:self];
        self.mingxingController = mingxing;
        [mingxing release];
        
        JiZheViewController *jizhe = [[JiZheViewController alloc]init];
        [jizhe setMainController: self];
        self.jizheController = jizhe;
        [jizhe release];
        
        YeJieViewController *yejie = [[YeJieViewController alloc]init];
        [yejie setMainController: self];
        self.yejieController = yejie;
        [yejie release];
        
    }
    return self;
}

- (void)dealloc
{
    self.mingxingController = nil;
    self.jizheController = nil;
    self.yejieController = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //顶导航
    UIImageView *navBar = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"toptoolbar.png"]];
    navBar.frame = CGRectMake(0, 0, 320, 43);
    navBar.userInteractionEnabled = YES;
    [self.view addSubview:navBar];
    
    UIImageView *logo = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"logo.png"]];
    logo.frame = CGRectMake(14,12,66,21);
    [navBar addSubview:logo];
    [logo release];
    
    UILabel *channeltitle = [[UILabel alloc]initWithFrame:CGRectMake(96, 10, 100, 30)];
    channeltitle.font = [UIFont boldSystemFontOfSize:17];
    channeltitle.textColor = [UIColor whiteColor];
    channeltitle.backgroundColor = [UIColor clearColor];
    channeltitle.text = @"明星";
    channeltitle.tag = 900000;
    [navBar addSubview:channeltitle];
    [channeltitle release];
    
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"refreshbutton.png"] forState:UIControlStateNormal];
    refreshButton.frame = CGRectMake(276, 2, 40, 40);
    [refreshButton addTarget:self action:@selector(refreshButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:refreshButton];
    
    
    [navBar release];
    
    self.mingxingController.view.frame = CGRectMake(0, 43, 320, self.view.frame.size.height-83);
    NSLog(@"main width: %f", self.view.frame.size.height-83);
    
    self.mingxingController.view.tag = BottomToolbarStatusMingXing;
    [self.view addSubview:mingxingController.view];
    toolbarStatus = BottomToolbarStatusMingXing;
    
    
    //顶导航阴影，注意保证放在最上面
    UIImageView *navBarShadow = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"toptoolbar_shadow.png"]];
    navBarShadow.frame = CGRectMake(0, 43, 320, 3);
    navBarShadow.tag = 900009;
    [self.view addSubview:navBarShadow];
    
    [navBarShadow release];
    
    //最底下的工具条
    UIImageView *toolbar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foottoolbar.png"]];
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-40, 320, 40);
    toolbar.userInteractionEnabled = YES;
    [self.view addSubview:toolbar];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toolbarSingleGesture:)];
    singleTapGesture.numberOfTapsRequired = 1;
    [toolbar addGestureRecognizer:singleTapGesture];
    [singleTapGesture release];
    
    
    
    UILabel *menu1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    menu1.font = [UIFont boldSystemFontOfSize:17];
    menu1.textColor = [UIColor whiteColor];
    menu1.backgroundColor = [UIColor clearColor];
    menu1.textAlignment = NSTextAlignmentCenter;
    menu1.text = @"明星";
    [toolbar addSubview:menu1];
    [menu1 release];
    
    UILabel *menu2 = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 70, 40)];
    menu2.font = [UIFont boldSystemFontOfSize:17];
    menu2.textColor = [UIColor whiteColor];
    menu2.backgroundColor = [UIColor clearColor];
    menu2.textAlignment = NSTextAlignmentCenter;
    menu2.text = @"业界";
    [toolbar addSubview:menu2];
    [menu2 release];
    
    UILabel *menu3 = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 70, 40)];
    menu3.font = [UIFont boldSystemFontOfSize:17];
    menu3.textColor = [UIColor whiteColor];
    menu3.backgroundColor = [UIColor clearColor];
    menu3.textAlignment = NSTextAlignmentCenter;
    menu3.text = @"记者";
    [toolbar addSubview:menu3];
    [menu3 release];
    
    UIButton *setupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setupButton setImage:[UIImage imageNamed:@"setupbutton.png"] forState:UIControlStateNormal];
    setupButton.frame = CGRectMake(265, 0, 40, 40);
    [setupButton addTarget:self action:@selector(setupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:setupButton];
    
    
    UIImageView *clickedbg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foottoolbar_clicked_bg.png"]];
    clickedbg.tag = 10001;
    clickedbg.frame = CGRectMake(0, 0, 70, 40);
    [toolbar insertSubview:clickedbg atIndex:0];
    
    [toolbar release];
    
}

- (void)toolbarSingleGesture: (UIGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:recognizer.view];
    
    if (point.x < 70)
    {
        if (toolbarStatus != BottomToolbarStatusMingXing)
        {
            UIView *dropView = [self.view viewWithTag:toolbarStatus];
            dropView.hidden = YES;
            
            UIView *mingxingView = [self.view viewWithTag:BottomToolbarStatusMingXing];
            
            if (!mingxingView)
            {
                self.mingxingController.view.frame = CGRectMake(0, 43, 320, self.view.frame.size.height-83);
                self.mingxingController.view.tag = BottomToolbarStatusMingXing;
                [self.view insertSubview:mingxingController.view belowSubview:[self.view viewWithTag:900009]];
                
            }
            else
            {
                mingxingView.hidden = NO;
            }
            
            UILabel *channelTitle = (UILabel *)[self.view viewWithTag:900000];
            channelTitle.text = @"明星";
            
            toolbarStatus = BottomToolbarStatusMingXing;
            
            UIView *clickedBG = [self.view viewWithTag:10001];
            clickedBG.frame = CGRectMake(0, 0, 70, 40);
        }
    }
    else if (point.x > 70 && point.x < 140)
    {
        if (toolbarStatus != BottomToolbarStatusYeJie)
        {
            UIView *dropView = [self.view viewWithTag:toolbarStatus];
            dropView.hidden = YES;
            
            UIView *yejieView = [self.view viewWithTag:BottomToolbarStatusYeJie];
            
            if (!yejieView)
            {
                self.yejieController.view.frame = CGRectMake(0, 43, 320, self.view.frame.size.height-83);
                self.yejieController.view.tag = BottomToolbarStatusYeJie;
                [self.view insertSubview:yejieController.view belowSubview:[self.view viewWithTag:900009]];
                
            }
            else
            {
                yejieView.hidden = NO;
            }
            
            UILabel *channelTitle = (UILabel *)[self.view viewWithTag:900000];
            channelTitle.text = @"业界";
            
            toolbarStatus = BottomToolbarStatusYeJie;
            
            UIView *clickedBG = [self.view viewWithTag:10001];
            clickedBG.frame = CGRectMake(70, 0, 70, 40);
        }
    }
    else if (point.x > 140 && point.x < 210)
    {
        if (toolbarStatus != BottomToolbarStatusJiZhe)
        {
            UIView *dropView = [self.view viewWithTag:toolbarStatus];
            dropView.hidden = YES;
            
            UIView *jizheView = [self.view viewWithTag:BottomToolbarStatusJiZhe];
            
            if (!jizheView)
            {
                self.jizheController.view.frame = CGRectMake(0, 43, 320, self.view.frame.size.height-83);
                self.jizheController.view.tag = BottomToolbarStatusJiZhe;
                [self.view insertSubview:jizheController.view belowSubview:[self.view viewWithTag:900009]];
            }
            else
            {
                jizheView.hidden = NO;
            }
            
            UILabel *channelTitle = (UILabel *)[self.view viewWithTag:900000];
            channelTitle.text = @"记者";
            
            toolbarStatus = BottomToolbarStatusJiZhe;
            
            UIView *clickedBG = [self.view viewWithTag:10001];
            clickedBG.frame = CGRectMake(140, 0, 70, 40);
        }
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshButtonClicked: (id)sender
{
    NSLog(@"refresh button clicked");
    
    if (toolbarStatus == BottomToolbarStatusMingXing)
    {
        [self.mingxingController performSelector:@selector(didRefreshButtonClicked:)];
    }
    else if (toolbarStatus == BottomToolbarStatusYeJie)
    {
        [self.yejieController performSelector:@selector(didRefreshButtonClicked:)];
    }
    else if (toolbarStatus == BottomToolbarStatusJiZhe)
    {
        [self.jizheController performSelector:@selector(didRefreshButtonClicked:)];
    }
}

- (void)setupButtonClicked: (id)sender
{
    NSLog(@"setup button clicked");
    SetupViewController *setupController = [[SetupViewController alloc] init];
    [self.navigationController pushViewController:setupController animated:YES];
   // [self presentViewController:setupController animated:YES completion:nil];
}



@end
