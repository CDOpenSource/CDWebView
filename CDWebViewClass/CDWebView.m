//
//  CDWebView.m
//  TestDemo
//
//  Created by Cindy on 15/11/9.
//  Copyright © 2015年 Cindy. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

#import "CDWebView.h"
#import "CDLoadExceptionView.h"


NSString *const CDLoadingExceptionLableDecription = @"网络不给力，加载失败啦！";
NSString *const CDLoadingExceptionButtonDecription = @"重新加载";

@interface CDWebView() <WKNavigationDelegate,WKScriptMessageHandler,UIWebViewDelegate,CDExceptionViewDelegate>
{
    @private
    UIView *_superView;
    CDLoadExceptionView *_exceptionView;
    
    UIWebView *_webView;
    WKWebView *_wkWebView;
}
@property (nonatomic,assign) id<CDWebViewDelegate> delegate;
@property (nonatomic,strong) NSArray *jsFunctionNameArray;
@property (nonatomic,strong) JSContext *jsContext;
@end

@implementation CDWebView

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithDelegate:(id<CDWebViewDelegate>) delegate andView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        _superView = view;
        
        [self initViewAndData];
    }
    return self;
}

- (void)initViewAndData
{
    /**
     * 初始化web   、设置web代理
     */
    if (SDK_VERSION >= 8.0) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.bounds];
        [self addSubview:_wkWebView];
        _wkWebView.navigationDelegate = self;
        _wkWebView.backgroundColor = [UIColor whiteColor];
    } else {
        _webView = [[UIWebView alloc] initWithFrame:self.bounds];
        [self addSubview:_webView];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    
    /**
     *  初始化js
     *
     */
    if ([self.delegate respondsToSelector:@selector(arrayOfRegisterToJSFunctionNameWithWebController:)]) {
        self.jsFunctionNameArray = [self.delegate arrayOfRegisterToJSFunctionNameWithWebController:self];
        
        if (SDK_VERSION >= 8.0 && [_jsFunctionNameArray count] > 0) {
            WKWebViewConfiguration* webViewConfig = [[WKWebViewConfiguration alloc] init];
            for (NSString *name in _jsFunctionNameArray) {
                [webViewConfig.userContentController addScriptMessageHandler:self name:name];
            }
            
            [_wkWebView  removeFromSuperview];
            _wkWebView = nil;
            _wkWebView = [[WKWebView alloc] initWithFrame:self.bounds configuration:webViewConfig];
            [self addSubview:_wkWebView];
            _wkWebView.navigationDelegate = self;
            _wkWebView.backgroundColor = [UIColor whiteColor];
        }
    } else {
        _jsFunctionNameArray = @[];
    }
    
    
    /**
     * 初始化加载异常的view
     */
    [_exceptionView removeFromSuperview];
    _exceptionView = [[CDLoadExceptionView alloc] initWithDelegate:self];
    _exceptionView.labelDescription.text = CDLoadingExceptionLableDecription;
    [_exceptionView.buttonReload setTitle:CDLoadingExceptionButtonDecription forState:UIControlStateNormal];
    
}

#pragma mark -  oc  called  js
- (void)evaluateJavaScriptWith:(NSString *)scriptString
{
    if (scriptString == nil || scriptString.length == 0) {
        return;
    } else {
        if (SDK_VERSION >= 8.0) {
            [_wkWebView evaluateJavaScript:scriptString completionHandler:^(id _Nullable returnValue, NSError * _Nullable error) {
                MTDetailLog(@"evaluateJavaScript result : \n error : %@  \nreturnValue:%@",error,returnValue);
            }];
        } else {
            NSString *result = [_webView stringByEvaluatingJavaScriptFromString:scriptString];
            MTDetailLog(@"stringByEvaluatingJavaScriptFromString result : \n error : %@",result);
        }
    }
}

- (void)reloadRequestWebData
{
    if (self.request == nil) {
        return;
    } else {
        if (SDK_VERSION >= 8.0) {
            MTDetailLog(@"【 WKWeb 】 --> URL=%@",self.request.URL.absoluteString);
            if (self.request.URL.isFileURL) {
                NSString * htmlCont = [NSString stringWithContentsOfFile:self.request.URL.path encoding:NSUTF8StringEncoding error:nil];
                [_wkWebView loadHTMLString:htmlCont baseURL:nil];
            } else {
                [_wkWebView loadRequest:self.request];
            }
            
        } else {
            MTDetailLog(@"【 UIWeb 】 --> URL=%@",self.request.URL.absoluteString);
            [_webView loadRequest:self.request];
        }
    }
}

#pragma mark - view
- (void)layoutSubviews
{
    if (SDK_VERSION >= 8.0) {
        _wkWebView.frame = self.bounds;
    } else {
        _webView.frame = self.bounds;
    }
    _exceptionView.frame = self.bounds;
}


#pragma mark - web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([self.delegate respondsToSelector:@selector(cdWebView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.delegate cdWebView:self shouldStartLoadWithRequest:request navigationType:(CDWebViewNavigationType)navigationType];
    } else {
        return YES;
    }
}

//  已经开始加载网页内容
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(cdWebViewDidStartLoad:)]) {
        [self.delegate cdWebViewDidStartLoad:self];
    }
}

//  网页内容加载完毕
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(cdWebViewDidFinishLoad:)]) {
        [self.delegate cdWebViewDidFinishLoad:self];
    }
    [_exceptionView removeFromSuperview];
    
    
    //  更新 js 的执行环境变量
    _jsContext = [webView valueForKeyPath:CDJSContextPathKey];
    MTDetailLog(@"JSContext         %@",_jsContext);
    _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        MTDetailLog(@"JSContext  Exception Handler Info : \n%@", exception);
        context.exception = exception;
    };
    _jsContext[@"log"] = ^() {
        MTDetailLog(@"+++++++Begin  Js  Log+++++++");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            MTDetailLog(@"%@", jsVal);
        }
        JSValue *this = [JSContext currentThis];
        MTDetailLog(@"this: %@",this);
        MTDetailLog(@"-------End  Js  Log-------");
    };
    
    //  向 js 注入 oc 的 代码
    __weak CDWebView *weakSelf = self;
    for (NSString *name in _jsFunctionNameArray) {
        _jsContext[name] = ^(id jsonParam){
            MTDetailLog(@"%@ ---> called back : %@",name,jsonParam);
            if ([weakSelf.delegate respondsToSelector:@selector(cdWebView:didCalledJSFunctionName:andParam:)]) {
                [weakSelf.delegate cdWebView:weakSelf didCalledJSFunctionName:name andParam:jsonParam];
            }
        };
    }
    
}

//  网页内容加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(cdWebView:didLoadFailedWithError:)]) {
        [self.delegate cdWebView:self didLoadFailedWithError:error];
    }
    [_exceptionView removeFromSuperview];
    _exceptionView.frame = self.bounds;
    [self addSubview:_exceptionView];
}

//  ios 8.0 以上的版本
#pragma mark  - WKWebView  NavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([self.delegate respondsToSelector:@selector(cdWebView:shouldStartLoadWithRequest:navigationType:)]) {
        if ([self.delegate cdWebView:self shouldStartLoadWithRequest:navigationAction.request navigationType:(CDWebViewNavigationType)navigationAction.navigationType]) {
            decisionHandler(WKNavigationActionPolicyAllow);
        } else {
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    MTDetailLog(@"didStartProvisionalNavigation");
    if ([self.delegate respondsToSelector:@selector(cdWebViewDidStartLoad:)]) {
        [self.delegate cdWebViewDidStartLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    MTDetailLog(@"didFinishNavigation");
    if ([self.delegate respondsToSelector:@selector(cdWebViewDidFinishLoad:)]) {
        [self.delegate cdWebViewDidFinishLoad:self];
    }
    [_exceptionView removeFromSuperview];
}

//  请求开始时发生错误
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    MTDetailLog(@"didFailProvisionalNavigation  Error:%@",error);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(cdWebView:didLoadFailedWithError:)]) {
            [self.delegate cdWebView:self didLoadFailedWithError:error];
        }
        [_exceptionView removeFromSuperview];
        _exceptionView.frame = self.bounds;
        [self addSubview:_exceptionView];
    });
}

//  请求期间发生错误
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    MTDetailLog(@"didFailNavigation   Error:%@",error);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(cdWebView:didLoadFailedWithError:)]) {
            [self.delegate cdWebView:self didLoadFailedWithError:error];
        }
        [_exceptionView removeFromSuperview];
        _exceptionView.frame = self.bounds;
        [self addSubview:_exceptionView];
    });
}

#pragma mark   wkWebView   js  called oc  (ScriptMessage Handler)
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    MTDetailLog(@"message.body : %@ \nmessage.name:%@",message.body,message.name);
    if ([self.delegate respondsToSelector:@selector(cdWebView:didCalledJSFunctionName:andParam:)]) {
        [self.delegate cdWebView:self didCalledJSFunctionName:message.name andParam:message.body];
    }
}

#pragma mark - some  web  mothed

#pragma mark - Exception Controller Delegate
- (void)reloadButtonPressEvent:(UIButton *)button andController:(CDLoadExceptionView *)exceptionController
{
    MTDetailLog(@"重新加载web数据！");
    //  重新发起请求web页面
    [self reloadRequestWebData];
}

@end
