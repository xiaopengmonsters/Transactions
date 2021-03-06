//
//  XPAppDelegate.m
//  Transactions
//
//  Created by xiaopengmonsters on 09/03/2020.
//  Copyright (c) 2020 xiaopengmonsters. All rights reserved.
//

#import "XPAppDelegate.h"
#import "GCTRunLoop.h"
#import "Transaction.h"
#import "TransactionGroup.h"

@implementation XPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    __weak __typeof(self)weakSelf = self;
//
//    for (int i = 0; i < 1000; i++) {
//
//        [[GCTRunLoop shareInstance] addTask:^BOOL{
//            [weakSelf nslogmes:i];
//            return YES;
//        }];
//    }
    
    
//    ASDK 提供了一个私有的管理事务的机制，由三部分组成 _ASAsyncTransactionGroup、_ASAsyncTransactionContainer 以及 _ASAsyncTransaction，这三者各自都有不同的功能：
//    _ASAsyncTransactionGroup 会在初始化时，向 Runloop 中注册一个回调，在每次 Runloop 结束时，执行回调来提交 displayBlock 执行的结果
//    _ASAsyncTransactionContainer 为当前 CALayer 提供了用于保存事务的容器，并提供了获取新的 _ASAsyncTransaction 实例的便利方法
//    _ASAsyncTransaction 将异步操作封装成了轻量级的事务对象，使用 C++ 代码对 GCD 进行了封装
    
    dispatch_queue_t  queue = dispatch_queue_create("1111", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i<10; i++) {
        dispatch_async(queue, ^{
            sleep(1);
            NSLog(@"----------------------%d",i);
        });
    }
    
    NSLog(@"----------------------A");
    
    dispatch_sync(queue, ^{
        NSLog(@"----------------------B");
    });
    
    NSLog(@"----------------------C");
    
    for (int i = 0; i < 10000; i++) {

        // 0
        
        Transaction *transaction0 = [[Transaction alloc] initWithCallbackQueue:dispatch_get_main_queue() completionBlock:^(Transaction *completedTransaction, BOOL cancelled) {
            NSLog(@"----事务%d执行完成----",i);
        }];
        [transaction0 addCompletionBlock:^(Transaction * _Nonnull completedTransaction, BOOL canceled) {
            NSLog(@"CompletionBlock-%d",i);
        }];
        [[TransactionGroup mainTransactionGroup] addTransaction:transaction0];
        
        
        // 1
        
//        Transaction *transaction = [[Transaction alloc] initWithCallbackQueue:dispatch_get_main_queue() completionBlock:^(Transaction *completedTransaction, BOOL cancelled) {
//            NSLog(@"----事务%d执行完成----",i);
//        }];
//
//        async_transaction_operation_block_t displayBlock = ^id{
//            NSLog(@"同步操作Block%d",i);
//            return [NSString stringWithFormat:@"%d",i];
//        };
//        async_transaction_operation_completion_block_t completionBlock = ^(id<NSObject> value, BOOL canceled){
//            NSLog(@"同步操作完成Block%d: %@", i,value);
//        };
//        [transaction addOperationWithBlock:displayBlock priority:0 queue:[self displayQueue] completion:completionBlock];
//
//        [transaction addCompletionBlock:^(Transaction * _Nonnull completedTransaction, BOOL canceled) {
//            //当所有事务中的操作已完成。在callbackQueue上执行并释放。
//            NSLog(@"CompletionBlock-%d",i);
//        }];
//
//        [[TransactionGroup mainTransactionGroup] addTransaction:transaction];
        
        
        
        // 2
        
//        Transaction *transaction2 = [[Transaction alloc] initWithCallbackQueue:dispatch_get_main_queue() completionBlock:^(Transaction *completedTransaction, BOOL cancelled) {
//            NSLog(@"----事务%d执行完成----",i);
//        }];
//
//        [transaction2 addAsyncOperationWithBlock:^(async_transaction_complete_async_operation_block_t  _Nonnull completeOperationBlock) {
//
//            //自定义并行队列
//            dispatch_queue_t queue2 = dispatch_queue_create("CONCURRENT", DISPATCH_QUEUE_CONCURRENT);
//            dispatch_async(queue2, ^{
//                sleep(3);
//                NSLog(@"异步操作Block%d",i);
//                completeOperationBlock([NSString stringWithFormat:@"%d",i]);
//            });
//
//        } priority:0 queue:[self displayQueue] completion:^(id<NSObject>  _Nullable value, BOOL canceled) {
//            NSLog(@"同步操作完成Block%d: %@", i,value);
//        }];
//
//        [[TransactionGroup mainTransactionGroup] addTransactionContainer:transaction2];

    }


    return YES;
}

- (void)nslogmes:(int)i {
    NSLog(@"%d",i);
}

#pragma mark -

- (dispatch_queue_t)displayQueue
{
  static dispatch_queue_t displayQueue = NULL;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    displayQueue = dispatch_queue_create("org.AsyncDisplayKit.ASDisplayLayer.displayQueue", DISPATCH_QUEUE_CONCURRENT);
    // we use the highpri queue to prioritize UI rendering over other async operations
//    dispatch_set_target_queue(displayQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
  });

  return displayQueue;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
