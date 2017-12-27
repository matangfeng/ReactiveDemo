//
//  ViewController.m
//  ReactiveDemo
//
//  Created by 马棠丰 on 2017/12/27.
//  Copyright © 2017年 未知. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self signalDemo];
    [self actionDemo];
}

- (void)actionDemo{
    //action事件
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"按钮" forState:(UIControlStateNormal)];
    button.frame = CGRectMake(40, 80, 100, 100);
    [self.view addSubview:button];
    [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"按钮点击时，此处实时响应，是将按钮的target事件封装为信号");
    }];
    
    //TextField事件
    UITextField * textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(10, CGRectGetMaxY(button.frame) + 20, self.view.frame.size.width - 20, 44);
    [self.view addSubview:textField];
    [[textField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"随着键盘的输入，此处可以实时打印键盘的输入值");
    }];
    
    //通知事件
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"通知名" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"接受到通知时的事件响应");
    }];
    
    // KVO事件
    [[self.view rac_valuesAndChangesForKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"x:%@", x);
    }];
}

- (void)signalDemo{
    //创建信号
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"123"];//发送信号
        return nil;
    }];
    
    //订阅者订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);//接收到发送者发送的信号
    }];
    
    
    //    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    //        [subscriber sendNext:@"123"];//发送信号
    //        return nil;
    //    }] subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);//接收到发送者发送的信号
    //    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.view.backgroundColor = [UIColor grayColor];
    self.view.alpha = 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
