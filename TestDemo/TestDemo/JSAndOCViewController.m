//
//  JSAndOCViewController.m
//  TestDemo
//
//  Created by Cindy on 15/11/9.
//  Copyright © 2015年 Cindy. All rights reserved.
//

#import "JSAndOCViewController.h"

#import "CDWebView.h"
#import "MBProgressHUD.h"

@interface JSAndOCViewController () <CDWebViewDelegate>
{
@private
    CDWebView *_webView;
    MBProgressHUD *_loadingWebView;
}
@end

@implementation JSAndOCViewController

- (void)startLoadingWeb
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test"ofType:@"html"];
    
    NSURL *localURL=[[NSURL alloc] initFileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:localURL];

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
    
    self.title = @"Test JS OC Each Other";
    
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

#pragma mark - delegate
- (BOOL)cdWebView:(CDWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(CDWebViewNavigationType)navigationType
{
    return YES;
}

- (NSArray *)arrayOfRegisterToJSFunctionNameWithWebController:(CDWebView *)webController
{
    return @[@"TestJsCalledOCFunctionName"];
}

//  js  called  oc
- (void)cdWebView:(CDWebView *)webController didCalledJSFunctionName:(NSString *)functionName andParam:(NSString *)jsonString
{
    if ([functionName isEqualToString:@"TestJsCalledOCFunctionName"]) {
        MTDetailLog(@"js called oc success !   param:%@",jsonString);
    }
}

@end
