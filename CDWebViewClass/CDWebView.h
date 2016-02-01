//
//  CDWebView.h
//  TestDemo
//
//  Created by Cindy on 15/11/9.
//  Copyright © 2015年 Cindy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CDWebViewDelegate;

#define  CDJSContextPathKey  @"documentView.webView.mainFrame.javaScriptContext"

/**
 *  系统版本
 *
 */
#define  SDK_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 *  日志输出
 *
 */
#ifdef DEBUG // 调试状态, 打开LOG功能
#define MTDetailLog(fmt, ...) NSLog((@"--------------------------> %@ [Line %d] \n"fmt "\n\n"), [[NSString stringWithFormat:@"%s",__FILE__] lastPathComponent], __LINE__, ##__VA_ARGS__);
#else // 发布状态, 关闭LOG功能
#define MTDetailLog(...)
#endif


/**
 *  常量声明
 */
UIKIT_EXTERN NSString *const CDLoadingExceptionLableDecription;
UIKIT_EXTERN NSString *const CDLoadingExceptionButtonDecription;


typedef NS_ENUM(NSInteger, CDWebViewNavigationType) {
    CDWebViewNavigationTypeLinkClicked,
    CDWebViewNavigationTypeFormSubmitted,
    CDWebViewNavigationTypeBackForward,
    CDWebViewNavigationTypeReload,
    CDWebViewNavigationTypeFormResubmitted,
    CDWebViewNavigationTypeOther
};

@interface CDWebView : UIView
@property (nonatomic,strong) NSURLRequest *request;

- (instancetype)init NS_DEPRECATED(10_0, 10_11, 2_0, 2_0, "请使用  initWithDelegate: andView: 方法来创建 CDWebView 的实例");
- (instancetype)initWithDelegate:(id<CDWebViewDelegate>)delegate andView:(UIView *)view;
- (void)evaluateJavaScriptWith:(NSString *)scriptString;

- (void)reloadRequestWebData;
- (BOOL)canGoBack;
- (BOOL)canGoForward;
- (void)goBack;
- (void)goForward;

@end



@protocol CDWebViewDelegate <NSObject>
@optional  //  loaded  web  data
- (BOOL)cdWebView:(CDWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(CDWebViewNavigationType)navigationType;
- (void)cdWebViewDidStartLoad:(CDWebView *)webView;
- (void)cdWebViewDidFinishLoad:(CDWebView *)webView;
- (void)cdWebView:(CDWebView *)webView  didLoadFailedWithError:(NSError *)error;
@optional   //  js   oc  each other
- (NSArray *)arrayOfRegisterToJSFunctionNameWithWebController:(CDWebView *)webController;
- (void)cdWebView:(CDWebView *)webController didCalledJSFunctionName:(NSString *)functionName andParam:(id)jsonString;
@end





