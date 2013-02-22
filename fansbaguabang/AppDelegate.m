//
//  AppDelegate.m
//  fansbaguabang
//
//  Created by huangbiao on 13-2-19.
//  Copyright (c) 2013年 fans. All rights reserved.
//

#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "MainViewController.h"

@implementation AppDelegate
@synthesize sinaweibo,isCai,isDing;
- (void)dealloc
{
    self.sinaweibo = nil;
    [_window release];
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        isCai = NO;
        isDing = NO;
    }
    return self;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //create a uuid if users not have
    NSString *deviceuserid = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceuserid"];
    if (deviceuserid == nil || deviceuserid == NULL)
    {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        [[NSUserDefaults standardUserDefaults] setObject:(NSString *)string forKey: @"deviceuserid"];
    }
    
    //Setup Push
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    
    //setup http request cache
    ASIDownloadCache *cache = [ASIDownloadCache sharedCache];
    [cache setShouldRespectCacheControlHeaders:NO];
    [ASIHTTPRequest setDefaultCache:cache];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    MainViewController *mainViewController = [[MainViewController alloc]init];
    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    rootViewController.navigationBarHidden = YES;
    
    
    
    self.window.rootViewController = rootViewController;
    [self.window addSubview:rootViewController.view];

    //init sinaweibo sdk
    SinaWeibo *weibo = [[SinaWeibo alloc]initWithAppKey:SinaWeiboAppKey appSecret:SinaWeiboAppSecret appRedirectURI:SinaWeiboRedirectURI andDelegate:self];
    NSDictionary *sinaweiboInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiboAuthData"];
    
    if ([sinaweiboInfo objectForKey:@"UserID"] && [sinaweiboInfo objectForKey:@"AccessToken"] && [sinaweiboInfo objectForKey:@"ExpirationDate"])
    {
        weibo.accessToken = [sinaweiboInfo objectForKey:@"AccessToken"];
        weibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDate"];
        weibo.userID = [sinaweiboInfo objectForKey:@"UserID"];
        
        NSLog(@"%@ %@ %@", [sinaweiboInfo objectForKey:@"AccessToken"], [sinaweiboInfo objectForKey:@"ExpirationDate"], [sinaweiboInfo objectForKey:@"UserID"]);
    }
    
    self.sinaweibo = weibo;
    [weibo release];
    
    //init weixin sdk
    [WXApi registerApp:@"wxbfb544440cb02157"];
    
    
    [mainViewController release];

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    [[NSUserDefaults standardUserDefaults] setObject:(NSString *)token forKey: @"pushtoken"];
    NSLog(@"pushtoken: %@", token);
    
    //NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceuserid"];
    
    NSString *requesturl = [NSString stringWithFormat:@"%@&token=%@", APIMAKER(API_URL_TOKEN), [token URLEncodedString]];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:requesturl]];
    request.delegate = self;
    [request startAsynchronous];

}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"%@", url);
    
    if ([[url absoluteString] rangeOfString:@"sinaweibosso"].location != NSNotFound)
    {
        return [self.sinaweibo handleOpenURL:url];
    }
    
    if ([[url absoluteString] rangeOfString:@"wxbfb544440cb02157"].location != NSNotFound)
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@", url);
    
    if ([[url absoluteString] hasPrefix:@"sinaweibosso"])
    {
        return [self.sinaweibo handleOpenURL:url];
    }
    
    if ([[url absoluteString] hasPrefix:@"wxbfb544440cb02157"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return NO;
}

#pragma mark - SinaWeibo Block
- (void)sinaweiboDidLogIn:(SinaWeibo *)_sinaweibo
{
    //将获取的信息打印log。
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    //NSDictionary *sinaweiboInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", sinaweibo.userID], @"UserID", [NSString stringWithFormat:@"%@", sinaweibo.accessToken] ,@"AccessToken", [NSString stringWithFormat:@"%@", sinaweibo.expirationDate], @"ExpirationDate", nil];
    
    //[[NSUserDefaults standardUserDefaults] setObject:sinaweiboInfo forKey:@"SinaWeiboAuthData"];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessToken",
                              sinaweibo.expirationDate, @"ExpirationDate",
                              sinaweibo.userID, @"UserID",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SinaWeiboUserLogined" object:nil]];
}

#pragma mark - Weixin Block

- (void)onResp:(BaseResp *)resp
{
    NSLog(@"%@", resp);
}

- (void)onReq:(BaseReq *)req
{
    NSLog(@"%@", req);
}


@end
