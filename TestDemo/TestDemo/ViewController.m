//
//  ViewController.m
//  TestDemo
//
//  Created by Cindy on 15/11/9.
//  Copyright © 2015年 Cindy. All rights reserved.
//
//
//
//
//
//
//
//  众所周知，UIWebView存在内存泄露的诟病，而ios8.0以后苹果推出了WKWebView有效的解决了这个问题，但是它只支持8.0以上的版本，but现在的app至少也得兼容到7.0；

//  而本人最近开发的项目又需要大量加载web页面，so我抽出了时间对这两个加载webview的控件进行了封装，使用时完全不用考虑SDK版本问题，内部已经集成了版本判断，且使用方式十分简单;

//  CDWebView会在当前运行的sdk支持WKWebView的情况下优先使用WK加载web；
//

#import "ViewController.h"


#import "WebLoadedViewController.h"
#import "JSAndOCViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Select  Function  Test";
    CGPoint center = self.view.center;
    UIButton *buttonOne = [[UIButton alloc] initWithFrame:CGRectMake(10.0, center.y - 100, self.view.bounds.size.width - 10*2.0, 35.0)];
    [buttonOne setTitle:@"演示CDWebView的web加载功能" forState:UIControlStateNormal];
    [buttonOne setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonOne.tag = 1;
    [buttonOne addTarget:self action:@selector(buttonPressEvent:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
    [self.view addSubview:buttonOne];
    
    UIButton *buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(10.0, center.y + 100, self.view.bounds.size.width - 10*2.0, 35.0)];
    [buttonTwo setTitle:@"演示CDWebView的js-oc交互功能" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonTwo.tag = 2;
    [buttonTwo addTarget:self action:@selector(buttonPressEvent:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
    [self.view addSubview:buttonTwo];
}

- (void)buttonPressEvent:(UIButton *)button
{
    if (button.tag == 1) {
        WebLoadedViewController *webLoaded = [[WebLoadedViewController alloc] init];
        [self.navigationController pushViewController:webLoaded animated:YES];
    } else if (button.tag == 2) {
        JSAndOCViewController *jsAndOc = [[JSAndOCViewController alloc] init];
        [self.navigationController pushViewController:jsAndOc animated:YES];
    }
}

@end
