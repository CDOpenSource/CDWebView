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

- (void)loadRequestWebData;
- (BOOL)canGoBack;
- (BOOL)canGoForward;
- (void)goBack;
- (void)goForward;
- (void)reload;

@end



@protocol CDWebViewDelegate <NSObject>
/*********************************************  loaded  web  data  ********************************************/
@optional
/**
 *  是否允许加载请求页面的代理回调方法
 *
 *  @param webView        显示页面的web控件
 *  @param request        请求封装对象
 *  @param navigationType 导航类型
 *
 *  @return 是否允许加载的布尔值
 */
- (BOOL)cdWebView:(CDWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(CDWebViewNavigationType)navigationType;

/**
 *  已经开始加载页面的代理回调方法
 *
 *  @param webView 显示页面的web控件
 */
- (void)cdWebViewDidStartLoad:(CDWebView *)webView;

/**
 *  页面已经加载完成的代理回调方法
 *
 *  @param webView 显示页面的web控件
 */
- (void)cdWebViewDidFinishLoad:(CDWebView *)webView;

/**
 *  页面加载失败的代理回调方法
 *
 *  @param webView 显示页面的web控件
 *  @param error   加载失败的错误信息
 */
- (void)cdWebView:(CDWebView *)webView  didLoadFailedWithError:(NSError *)error;


/*****************************************  js   oc  each other  ***************************************************/
/**
 *  获取要注册到后台html网页中js执行环境里面的一系列js的名字
 *
 *  @param webController 显示页面的web控件
 *
 *  @return 要注册的js名字的数组对象
 */
- (NSArray *)arrayOfRegisterToJSFunctionNameWithWebController:(CDWebView *)webController;

/**
 *  html页面调用了之前注册的js，会触发的客户端回调方法
 *
 *  @param webController 显示页面的web控件
 *  @param functionName  html触发的js的名字
 *  @param jsonString    由html传递过来的json参数
 */
- (void)cdWebView:(CDWebView *)webController didCalledJSFunctionName:(NSString *)functionName andParam:(id)jsonString;

@end





