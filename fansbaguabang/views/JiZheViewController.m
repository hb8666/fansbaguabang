//
//  JiZheViewController.m
//  baguabang
//
//  Created by Yorgo Sun on 13-2-1.
//  Copyright (c) 2013年 Fans Media Co. Ltd. All rights reserved.
//

#import "JiZheViewController.h"
#import "NetImageView.h"
@interface JiZheViewController ()

@end

@implementation JiZheViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-83) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    
    [self.view addSubview:tableView];
    self.mainTableView = tableView;
    
    [tableView release];
    
    [self loadData];
}

-(void)loadData
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:APIMAKER(API_URL_JIZHE)]];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    self.listdata = (NSArray *)[[responseString JSONValue] objectForKey:@"data"];
    
    [mainTableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]] autorelease];
        cell.backgroundView = nil;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 290, 30)];
        
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0];
        title.backgroundColor = [UIColor clearColor];
        title.text = [[listdata objectAtIndex:indexPath.row] objectForKey:@"name"];
        [cell.contentView addSubview:title];
        
        [title sizeToFit];
        
        UILabel *comefrom = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x + title.frame.size.width + 5, 15, 290, 15)];
        comefrom.font = [UIFont systemFontOfSize:10];
        comefrom.textColor = [UIColor grayColor];
        comefrom.backgroundColor = [UIColor clearColor];
        comefrom.text = [[listdata objectAtIndex:indexPath.row] objectForKey:@"place"];
        [cell.contentView addSubview:comefrom];
        
        [title release];
        
        NetImageView *imageView = [[NetImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
        [cell.contentView addSubview:imageView];
        [imageView getImageFromURL:[[listdata objectAtIndex:indexPath.row] objectForKey:@"head_image"]];
        [imageView release];
        
        
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, 225, 55)];
        content.font = [UIFont systemFontOfSize:12];
        content.textColor = [UIColor grayColor];
        content.backgroundColor = [UIColor clearColor];
        content.lineBreakMode = UILineBreakModeWordWrap;
        content.numberOfLines = 3;
        content.text = [[listdata objectAtIndex:indexPath.row] objectForKey:@"message"];
        [content sizeToFit];
        
        [cell.contentView addSubview:content];
        
        UILabel *weixin = [[UILabel alloc]initWithFrame:CGRectMake(80, content.frame.origin.y+content.frame.size.height+5, 225, 55)];
        weixin.font = [UIFont systemFontOfSize:12];
        weixin.textColor = [UIColor grayColor];
        weixin.backgroundColor = [UIColor clearColor];
        weixin.lineBreakMode = UILineBreakModeWordWrap;
        weixin.text = [NSString stringWithFormat:@"微信号：%@", [[listdata objectAtIndex:indexPath.row] objectForKey:@"kik"]];
        [weixin sizeToFit];
        [cell.contentView addSubview:weixin];
        
        [content release];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}



@end
