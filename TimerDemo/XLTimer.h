//
//  XLTimer.h
//  TimerDemo
//
//  Created by 张晓龙 on 2020/7/30.
//  Copyright © 2020 张晓龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTimer : NSObject

- (instancetype)initTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

- (void)xl_invalidate;

@end

NS_ASSUME_NONNULL_END
