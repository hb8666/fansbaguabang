//
//  SetupViewController.m
//  fansbaguabang
//
//  Created by huangbiao on 13-2-20.
//  Copyright (c) 2013年 fans. All rights reserved.
//

#import "SetupViewController.h"
#import "DCRoundSwitch.h"

@interface SetupViewController ()

@end

@implementation SetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"backbuttonclicked.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(5, 2, 40, 40);
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    

    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(135, 0, 50, 43)];
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"设置";
    title.center = navBar.center;
    [navBar addSubview:title];
    [title release];
        
    [navBar release];
    
    
    UIView *fontView = [[UIView alloc] init];
    [self.view addSubview:fontView];
    fontView.frame = CGRectMake(10, navBar.frame.size.height+10, self.view.frame.size.width-20, 60);
    fontView.backgroundColor = [UIColor clearColor];
    fontView.layer.borderColor = [UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1].CGColor;
    fontView.layer.borderWidth = 1;
    
    UILabel *zwFont = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 60)];
    zwFont.text = @"正文字号";
    zwFont.font = [UIFont boldSystemFontOfSize:17];
    [fontView addSubview:zwFont];
    [zwFont release];
    
    UISegmentedControl *fontSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"特大",@"大",@"中",@"小",nil]];
    fontSegment.frame = CGRectMake(120, 10, 160, 40);
    fontSegment.backgroundColor = [UIColor clearColor];
    fontSegment.segmentedControlStyle = UISegmentedControlStyleBezeled;
    fontSegment.tintColor = [UIColor whiteColor];
    /*
    [fontSegment insertSegmentWithTitle:@"特大" atIndex:0 animated:NO];
    [fontSegment insertSegmentWithTitle:@"大" atIndex:1 animated:NO];
    [fontSegment insertSegmentWithTitle:@"中" atIndex:2 animated:NO];
    [fontSegment insertSegmentWithTitle:@"小" atIndex:3 animated:NO];
     */
    [fontSegment addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventValueChanged];
    
    [fontView addSubview:fontSegment];
    [fontView release];
    
    UIView *modeView = [[UIView alloc] init];
    [self.view addSubview:modeView];
    modeView.frame = CGRectMake(10, fontView.frame.size.height+fontView.frame.origin.y-1, self.view.frame.size.width-20, 60);
    modeView.backgroundColor = [UIColor clearColor];
    modeView.layer.borderColor = [UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1].CGColor;
    modeView.layer.borderWidth = 1;
    
    UILabel *rymode = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 60)];
    rymode.text = @"日夜模式";
    rymode.font = [UIFont boldSystemFontOfSize:17];
    [modeView addSubview:rymode];
    [rymode release];
    
    UILabel *day = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 20, 60)];
    day.text = @"日";
    day.font = [UIFont boldSystemFontOfSize:17];
    [modeView addSubview:day];
    [day release];
    
    DCRoundSwitch *dayOrNight = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(145, 20, 45, 20)];
    [dayOrNight addTarget:self action:@selector(selectDayOrNight:) forControlEvents:UIControlEventValueChanged];
   
    [modeView addSubview:dayOrNight];
    
    UILabel *night = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 20, 60)];
    night.text = @"夜";
    night.font = [UIFont boldSystemFontOfSize:17];
    [modeView addSubview:night];
    [night release];
    
   
    [modeView release];
}

- (void)backButtonClicked: (id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
  //  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selectFont:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    int index = segment.selectedSegmentIndex;
    NSLog(@"您选择的是:%d",index);
}

-(void)selectDayOrNight:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isNight = [switchButton isOn];
    if (!isNight) {
        NSLog(@"日间模式");
    }else{
        NSLog(@"夜间模式");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
