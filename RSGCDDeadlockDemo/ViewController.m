//
//  ViewController.m
//  RSGCDDeadlockDemo
//
//  Created by WhatsXie on 2017/8/2.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self runFuncWithTypeName:[NSString stringWithFormat:@"func%ld", self.type]];
}

///同步派遣+串行队列
- (void)func0{
    dispatch_queue_t q1 = dispatch_queue_create("aaaaa", DISPATCH_QUEUE_SERIAL);

    dispatch_sync(q1, ^{
        
        NSLog(@"1 我是 同步派遣 的 串行队列");
        
    });
    
    NSLog(@"2 是的，你在正确的运行着");
    
}

///异步派遣+串行队列
- (void)func1{
    
    dispatch_queue_t q2 = dispatch_queue_create("bbbbbb", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(q2, ^{
        
        NSLog(@"1 我是 异步派遣 的 串行队列");
        
    });
    
    NSLog(@"2 是的，你在正确的运行着");
    
}

///同步派遣+并行队列
- (void)func2{
    
    dispatch_queue_t q3 = dispatch_queue_create("cccccc", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(q3, ^{
        
        NSLog(@"1 我是 同步派遣 的 并行队列");
        
    });
    
    NSLog(@"2 是的，你在正确的运行着");
    
}

///异步派遣+并行队列
- (void)func3{
    
    dispatch_queue_t q4 = dispatch_queue_create("ddddddd", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(q4, ^{
        
        NSLog(@"1 我是 异步派遣 的 并行队列");
        
    });
    
    NSLog(@"2 是的，你在正确的运行着");
    
}
///死锁的第一种情况
// 死锁了
- (void)func4{
    NSLog(@"1 我要死锁了吗？ 啊啊~~");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2 死锁了吗");
    });
    
}

///死锁的第二种情况
// 并没有死锁
- (void)func5{
    
    dispatch_queue_t q = dispatch_queue_create("1111111", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(q, ^{
        
        NSLog(@"1 外层 dispatch_async 开始执行");
        dispatch_async(q, ^{
            NSLog(@"2 内层 dispatch_async 执行");
        });
        NSLog(@"3 外层 dispatch_async，执行完毕");
    });
    
    NSLog(@"4 我并没有死锁");
    NSLog(@"5 啊哈哈哈");
}

- (void)runFuncWithTypeName:(NSString *)typeName {
    SEL method = NSSelectorFromString(typeName);
    if ([self respondsToSelector:method]) {
        [self performSelector:method];
    } else {
        NSLog(@"%@ is not method", typeName);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
