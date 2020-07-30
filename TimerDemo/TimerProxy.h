//
//  TimerProxy.h
//  TimerDemo
//
//  Created by 张晓龙 on 2020/7/30.
//  Copyright © 2020 张晓龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerProxy : NSProxy

+ (instancetype)proxyWithTransformObject:(id)object;

@end

NS_ASSUME_NONNULL_END
