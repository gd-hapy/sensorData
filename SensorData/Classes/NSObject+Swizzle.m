//
//  NSObject+Swizzler.m
//  testdemodd
//
//  Created by Apple on 11/1/22.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzler)

+ (BOOL)sensorsdata_swizzleMethod:(SEL)originalSEL withMethod:(SEL)alternateSEL {
   
    //获取原始的方法
    Method originalMethod = class_getInstanceMethod(self, originalSEL);
    if (!originalMethod) {
        return NO;
    }
    //获取将要交换的方法
    Method alternateMethod = class_getInstanceMethod(self, alternateSEL);
    if (!alternateMethod) {
        return NO;
    }
    
    //交换两个方法的实现
    if (class_addMethod(self, originalSEL, method_getImplementation(alternateMethod), method_getTypeEncoding(alternateMethod))) {
        class_replaceMethod(self, alternateSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, alternateMethod);
    }
        
    //返回yes，方法交换成功
    return YES;
}

+ (BOOL)sensorsdata_swizzleMethodOriginalClass:(Class)originalClass withOriginalSel:(SEL)originalSEL withAlternalClass:(Class)alternateClass withMethod:(SEL)alternateSEL {
   
    //获取原始的方法
    Method originalMethod = class_getInstanceMethod(self, originalSEL);
    if (!originalMethod) {
        return NO;
    }
    //获取将要交换的方法
    Method alternateMethod = class_getInstanceMethod(alternateClass, alternateSEL);
    if (!alternateMethod) {
        return NO;
    }
    
    //交换两个方法的实现
    if (class_addMethod(self, originalSEL, method_getImplementation(alternateMethod), method_getTypeEncoding(alternateMethod))) {
        class_replaceMethod(self, alternateSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, alternateMethod);
    }
        
    //返回yes，方法交换成功
    return YES;
}

@end
