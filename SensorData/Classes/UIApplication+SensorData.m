//
//  UIApplication+SensorData.m
//  testdemodd
//
//  Created by Apple on 11/1/22.
//

#import "UIApplication+SensorData.h"
#import "NSObject+Swizzle.h"
#import "UIView+TextContentData.h"

@implementation UIApplication (SensorData)

+ (void)load {
    [UIApplication sensorsdata_swizzleMethod:@selector(sendAction:to:from:forEvent:) withMethod:@selector(sensorData_sendAction:to:from:forEvent:)];
}

- (BOOL)sensorData_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    
    UIView *view = (UIView *)sender;
    NSMutableDictionary *prams = [[NSMutableDictionary alloc] init];
    //获取控件类型
    prams[@"$elementtype"] = view.elementType;
    //获取控件的内容
    prams[@"element_content"] = view.elementContent;
    //获取所属的页面
    UIViewController *vc = view.myViewController;
    prams[@"element_screen"] = NSStringFromClass(vc.class);

    NSLog(@"sensor--->%@:clicked", NSStringFromClass([view class]));

    return  [self sensorData_sendAction:action to:target from:sender forEvent:event];

}

@end

