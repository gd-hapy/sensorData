//
//  UIGestureRecognizer+SensorData.m
//  testdemodd
//
//  Created by Apple on 11/1/22.
//

#import "UITapGestureRecognizer+SensorsData.h"
#import <objc/runtime.h>

@implementation UITapGestureRecognizer (SensorsData)
+(void)load {
//    交换initWithTarget:action:方法
    [UITapGestureRecognizer sensorsdata_swizzleMethod:@selector(initWithTarget:action:) withMethod:@selector(sensorData_initWithTarget:action:)];
    /*交换addTarget:action:方法*/
    [UITapGestureRecognizer sensorsdata_swizzleMethod:@selector(addTarget:action:) withMethod:@selector(sensorData_addTarget:action:)];
}

- (instancetype)sensorData_initWithTarget:(id)target action:(SEL)action {
    // 调用原始的初始化方法进行对象初始化
    [self sensorData_initWithTarget:target action:action];
    // 调用添加Target-Action的方法，添加埋点的Target-Action
    // 这里其实调用的是-sensorData_addTarget:action:的实现方法，因为已经进行交换
    [self addTarget:target action:action];
    return self;
}

//- (void)printMethodList {
//    unsigned int count;
//
//    Method *methodList = class_copyMethodList([self class], &count);
//    for (unsigned int i = 0; i < count; i++) {
//        Method method = methodList[i];
//        NSLog(@"method(%d) : %@", i, NSStringFromSelector(method_getName(method)));
//    }
//
//    free(methodList);
//}


- (void)sensorData_addTarget:(id)target action:(SEL)action {
    //  调用原始的方法，添加Target-Action
    [self sensorData_addTarget:target action:action];
    //新增target-action，用于触发$AppClick事件
    [self sensorData_addTarget:self action:@selector(sensorData_trackTapGestureAction:)];
}

-(void)sensorData_trackTapGestureAction:(UITapGestureRecognizer *)sender {
    // 获取手势识别器的控件
    UIView *tapView =  sender.view;
    
    NSLog(@"sensor--->%@:clicked", NSStringFromClass([tapView class]));
    
    // todo
    // track data
}

@end
