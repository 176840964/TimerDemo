//
//  PushViewController.m
//  TimerDemo
//
//  Created by 张晓龙 on 2020/7/30.
//  Copyright © 2020 张晓龙. All rights reserved.
//

#import "PushViewController.h"
#import "XLTimer.h"
#import <objc/runtime.h>
#import "TimerProxy.h"

static int num = 0;

@interface PushViewController ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) id target;
@property (nonatomic, strong) XLTimer *customTimer;
@property (nonatomic, strong) TimerProxy *proxy;
@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (self.st) {
        case Status1:
            //配合didMoveToParentViewController:方法使用
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fireHome) userInfo:nil repeats:YES];
            
            break;
        case Status2:
            //使用一个中间着，并且修改fireHome方法的IMP
            
            /**
             持有关系：两条链
            vc->target
            runloop->timer->target
             
             dealloc方法可以被调用，方法内手动调用timer的释放，所以都可以正常释放
             */
            self.target = [[NSObject alloc] init];
            class_addMethod([NSObject class], @selector(fireHome), (IMP)fireHomeObjc, "v@:");
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.target selector:@selector(fireHome) userInfo:nil repeats:YES];
            
            break;
        case Status3:
            //自定义一个类来当中间者
            self.customTimer = [[XLTimer alloc] initTimerWithTimeInterval:1 target:self selector:@selector(fireHome) userInfo:nil repeats:YES];
        
            break;
        case Status4:
            //推荐方式：使用NSProxy的子类当中间者，需要在dealloc中手动释放timer
            /**
             持有关系：与status2类似
             vc->proxy
             runloop->timer->proxy
             */
            self.proxy = [TimerProxy proxyWithTransformObject:self];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.proxy selector:@selector(fireHome) userInfo:nil repeats:YES];
        
            break;
        default:
            break;
    }
}


- (void)fireHome {
    num++;
    NSLog(@"%s - %d", __func__, num);
}

//st == status1
- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil && self.st == Status1) {
        [self.timer invalidate];
        self.timer = nil;
        NSLog(@"%s", __func__);
    }
}

//st == status2
void fireHomeObjc(id obj){
    NSLog(@"%s -- %@",__func__,obj);
}

- (void)dealloc
{
    if (self.st == Status4 || self.st == Status2) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSLog(@"%s", __func__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
