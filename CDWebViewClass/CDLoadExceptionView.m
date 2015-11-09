//
//  CDLoadExceptionView.m
//  TestDemo
//
//  Created by Cindy on 15/11/9.
//  Copyright © 2015年 Cindy. All rights reserved.
//

#import "CDLoadExceptionView.h"

@interface CDLoadExceptionView()
@property (nonatomic,assign) id<CDExceptionViewDelegate> delegate;
@end

@implementation CDLoadExceptionView

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CDLoadExceptionView" owner:self options:nil] lastObject];
    
    if (self == nil) {
        self = [super init];
    }
    
    if (self) {
        self.buttonReload.layer.borderWidth = 0.5;
        self.buttonReload.layer.borderColor = [UIColor grayColor].CGColor;
        self.buttonReload.layer.cornerRadius = 2.0f;
    }
    
    return self;
}

- (instancetype)initWithDelegate:(id <CDExceptionViewDelegate>)delegate
{
    self = [self init];
    
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)layoutSubviews
{
    //  如果不想使用 xib 来布局，也可以在此处用代码来布局
}

#pragma mark - 重新加载数据
- (IBAction)buttonPressEvent:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(reloadButtonPressEvent:andController:)]) {
        [self.delegate reloadButtonPressEvent:sender andController:self];
    }
}



@end
