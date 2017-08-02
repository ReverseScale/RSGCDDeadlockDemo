# RSGCDDeadlockDemo
动手实现GCD相关实现，“打假英雄”帮你验证网络泛滥的技术博文。

![](https://img.shields.io/badge/platform-iOS-red.svg) 
![](https://img.shields.io/badge/language-Objective--C-orange.svg) 
![](https://img.shields.io/badge/download-1.7MB-brightgreen.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

对国内博客里面讲到的一些东西进行一些验证。对百度一些技术点加以验证。
 
| 名称 |1.列表页 
| ------------- | ------------- | 
| 截图 | ![](http://og1yl0w9z.bkt.clouddn.com/17-8-2/72015487.jpg) | 
| 描述 | 通过 storyboard 搭建基本框架的 GCD 示例列表 | 

## 前言
说到GCD，最基本的就是四个队列，两个函数和四种队列：

* 串行队列
* dispatch_queue_t q = dispatch_queue_create("aaaaa", DISPATCH_QUEUE_SERIAL);
* 并行队列
* dispatch_queue_t q = dispatch_queue_create("cccccc", DISPATCH_QUEUE_CONCURRENT);
* 全局并行队列
* dispatch_get_global_queue(0, 0)
* 主队列
* dispatch_get_main_queue()

但实际上这四个队列可以归结为串行+并行，因为主队列就是一种串行队列（关于这一点我待会回来进行验证），全局并行队列实际上是并行队列。

## Requirements 要求
* iOS 7+
* Xcode 8+


## 实现方法
### 同步派遣+串行队列
```
///同步派遣+串行队列
- (void)func0{
    dispatch_queue_t q1 = dispatch_queue_create("aaaaa", DISPATCH_QUEUE_SERIAL);

    dispatch_sync(q1, ^{
        
        NSLog(@"1 我是 同步派遣 的 串行队列");
        
    });
    
    NSLog(@"2 是的，你在正确的运行着");
    
}
```
### 异步派遣+串行队列
```
///异步派遣+串行队列
- (void)func1{
    
    dispatch_queue_t q2 = dispatch_queue_create("bbbbbb", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(q2, ^{
        
        NSLog(@"1 我是 异步派遣 的 串行队列");
        
    });
    
    NSLog(@"2 是的，你在正确的运行着");
    
}
```
### 同步派遣+并行队列
```
///同步派遣+并行队列
- (void)func2{
    
    dispatch_queue_t q3 = dispatch_queue_create("cccccc", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(q3, ^{
        
        NSLog(@"1 我是 同步派遣 的 并行队列");
        
    });
    
    NSLog(@"2 是的，你在正确的运行着");
    
}
```
### 异步派遣+并行队列
```
///异步派遣+并行队列
- (void)func3{
    
    dispatch_queue_t q4 = dispatch_queue_create("ddddddd", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(q4, ^{
        
        NSLog(@"1 我是 异步派遣 的 并行队列");
        
    });
    
    NSLog(@"2 是的，你在正确的运行着");
    
}
```

## 关于如下死锁的思考：
1. 串行队列里面只可能有一个线程，并行队列里面可能有多个。
2. 队列里面可能没有线程，线程总是跑来跑去的。
3. 不管是同步函数或者是异步函数，都会将block里面的内容派遣到对应的队列的最下面。
4. 同步函数里面维护了一套信号量，信号量的single操作被套在异步函数里面
5. dispatch_async(queue, ^{
     dispatch_semaphore_signal(semaphore);
6. });
7. 同步函数的的其他操作在同步函数所处的外面的队列里面去执行，只有
     dispatch_semaphore_signal(semaphore);
     
### 死锁的第一种情况
```
///死锁的第一种情况
// 死锁了
- (void)func4{
    NSLog(@"1 我要死锁了吗？ 啊啊~~");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2 死锁了吗");
    });
}
```
### 死锁的第二种情况
```
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
```

使用简单、效率高效、进程安全~~~如果你有更好的建议,希望不吝赐教!


## License 许可证
RSGCDDeadlockDemo 使用 MIT 许可证，详情见 LICENSE 文件。


## Contact 联系方式:
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io
