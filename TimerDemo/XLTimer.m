//
//  XLTimer.m
//  TimerDemo
//
//  Created by 张晓龙 on 2020/7/30.
//  Copyright © 2020 张晓龙. All rights reserved.
//

#import "XLTimer.h"
#import <objc/message.h>

@interface XLTimer ()
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL aSelector;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation XLTimer

- (instancetype)initTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    self = [super init];
    if (self) {
        
        /**
         外部
         vc->XLTimer
         内部
         runloop->timer->self(XLTimer)
         */
        
        self.target = aTarget;
        self.aSelector = aSelector;
        
        if ([self.target respondsToSelector:aSelector]) {
            Method method = class_getInstanceMethod([aTarget class], aSelector);
            const char *type = method_getTypeEncoding(method);
            class_addMethod([self class], aSelector, (IMP)fire, type);

            self.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:aSelector userInfo:userInfo repeats:yesOrNo];
        }
    }
    return self;
}

void fire(XLTimer *t) {
    //如果外部vc存在，发送消息
    if (t.target) {
        void (*tmp_msgSend)(void *, SEL, id) = (void*)objc_msgSend;
        tmp_msgSend((__bridge void*)t.target, t.aSelector, t.timer);
    } else {
        //vc不存在，就释放timer
        [t.timer invalidate];
        t.timer = nil;
    }
}


- (void)xl_invalidate {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
