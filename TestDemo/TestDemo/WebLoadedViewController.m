//
//  WebLoadedViewController.m
//  TestDemo
//
//  Created by Cindy on 15/11/9.
//  Copyright © 2015年 Cindy. All rights reserved.
//

#import "WebLoadedViewController.h"

#import "CDWebView.h"
#import "MBProgressHUD.h"

@interface WebLoadedViewController () <CDWebViewDelegate>
{
@private
    CDWebView *_webView;
    MBProgressHUD *_loadingWebView;
}
@end

@implementation WebLoadedViewController


- (void)startLoadingWeb
{
    NSString *urlString = @"https://www.baidu.com/";
    NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:6];
    _webView.request = request;
    [_webView reloadRequestWebData];
}

#pragma mark - view
- (void)viewWillLayoutSubviews
{
    _webView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Test Web Loaded";
    
    /**
     * 初始化 webView
     */
    _webView = [[CDWebView alloc] initWithDelegate:self andView:self.view];
    [self.view addSubview:_webView];
    
    
    /**
     *  初始化加载框
     */
    _loadingWebView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_loadingWebView];
    
    
    /**
     *  开始请求数据
     */
    [self startLoadingWeb];
}

#pragma mark - CDWebView Delegate
- (BOOL)cdWebView:(CDWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(CDWebViewNavigationType)navigationType
{
    return YES;
}

- (void)cdWebViewDidStartLoad:(CDWebView *)webView
{
    [_loadingWebView hide:NO];
    _loadingWebView.mode = MBProgressHUDModeIndeterminate;
    _loadingWebView.detailsLabelText = @"数据加载中...";
    [_loadingWebView show:YES];
}

- (void)cdWebViewDidFinishLoad:(CDWebView *)webView
{
    [_loadingWebView hide:YES];
}

- (void)cdWebView:(CDWebView *)webView didLoadFailedWithError:(NSError *)error
{
    [_loadingWebView hide:NO];
    _loadingWebView.mode = MBProgressHUDModeText;
    _loadingWebView.detailsLabelText = @"加载失败，请稍后重试！";
    [_loadingWebView show:YES];
    [_loadingWebView hide:NO afterDelay:1.5f];
}

- (NSArray *)arrayOfRegisterToJSFunctionNameWithWebController:(CDWebView *)webController
{
    return @[];
}

//  js  called  oc
- (void)cdWebView:(CDWebView *)webController didCalledJSFunctionName:(NSString *)functionName andParam:(NSString *)jsonString
{
    
}

@end
