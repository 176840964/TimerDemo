//
//  PushViewController.h
//  TimerDemo
//
//  Created by 张晓龙 on 2020/7/30.
//  Copyright © 2020 张晓龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Status) {
    Status1 = 0,
    Status2,
    Status3,
    Status4,
};

NS_ASSUME_NONNULL_BEGIN

@interface PushViewController : UIViewController
@property (assign, nonatomic) Status st;
@end

NS_ASSUME_NONNULL_END
