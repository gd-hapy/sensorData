//
//  UIViewController+SensorData.m
//  SensorData
//
//  Created by Apple on 11/2/22.
//

#import "UIViewController+SensorData.h"
#import "NSObject+Swizzler.h"
#import <objc/runtime.h>

@implementation UIViewController (SensorData)

+ (void)load {
    [UIViewController sensorsdata_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(sensorData_viewDidAppear:)];
}

- (void)sensorData_viewDidAppear:(BOOL)aimated {
    Class class = [self class];
    NSLog(@"sensor---sensorData_viewDidAppear:%@", class);
}

@end
