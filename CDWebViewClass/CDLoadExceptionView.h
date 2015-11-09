//
//  CDLoadExceptionView.h
//  TestDemo
//
//  Created by Cindy on 15/11/9.
//  Copyright © 2015年 Cindy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDExceptionViewDelegate;

@interface CDLoadExceptionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UIButton *buttonReload;

- (instancetype)initWithDelegate:(id <CDExceptionViewDelegate>)delegate;

@end


@protocol CDExceptionViewDelegate <NSObject>
@optional
- (void)reloadButtonPressEvent:(UIButton *)button andController:(CDLoadExceptionView *)exceptionController;
@end