//
//  ViewController.m
//  队列
//
//  Created by 高山峰 on 15/12/10.
//  Copyright © 2015年 高山峰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *bigImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//1    [self syncSerialQuenue];
//2    [self asyncSerialQuenue];
//3    [self asyncConcurrentQuenue];
//4    [self syncConcurrentQuenue];
    [self onlyOnce];
    [self asyncGroup];

}
-(void)onlyOnce{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
}
-(void)asyncGroup{
    

   dispatch_group_t queue = dispatch_group_create();
   __block UIImage *image1 = nil;
   dispatch_group_async(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       image1 = [self imageWithURL:@""];
   });
    __block UIImage *image2 = nil;
    dispatch_group_async(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image2 = [self imageWithURL:@""];
    });

    dispatch_group_notify(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.imageView1.image = image1;
        self.imageView2.image = image2;
        // 合并
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 100), NO, 0.0);
        [image1 drawInRect:CGRectMake(0, 0, 100, 100)];
        [image2 drawInRect:CGRectMake(100, 0, 100, 100)];
        self.bigImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭上下文
        UIGraphicsEndImageContext();
    });
   
}
-(UIImage *)imageWithURL:(NSString *)imageurl{
    NSString *imageStr = imageurl;
    NSURL *imageURL = [NSURL URLWithString:imageStr];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}
///同步函数在串行队列中执行(不开线程,一一执行)
-(void)syncSerialQuenue{
    dispatch_queue_t queue = dispatch_queue_create("com.laobangenjudi", NULL);
    dispatch_sync(queue, ^{
        NSLog(@"下载图片1---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载图片2---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载图片3---%@",[NSThread currentThread]);
    });
}
//异步函数在串行队列中执行(开一条线程,同时执行)
-(void)asyncSerialQuenue{
    dispatch_queue_t queue = dispatch_queue_create("com.nimei", NULL);
    dispatch_async(queue, ^{
        NSLog(@"下载图片1---%@",[NSThread currentThread]);

    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片2---%@",[NSThread currentThread]);
        
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片3---%@",[NSThread currentThread]);
        
    });
}
//异步函数在并发队列中执行(开多条线程,同时执行)
-(void)asyncConcurrentQuenue{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"下载图片1---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片2---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片3---%@",[NSThread currentThread]);
    });
}
//同步函数在并发队列中执行(不开线程,一一执行)
-(void)syncConcurrentQuenue{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        NSLog(@"下载图片1---%@",[NSThread currentThread]);

    });
    dispatch_sync(queue, ^{
        NSLog(@"下载图片2---%@",[NSThread currentThread]);
        
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载图片3---%@",[NSThread currentThread]);
        
    });

}
@end
