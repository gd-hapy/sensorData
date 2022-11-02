//
//  TableViewDynamicDelegate.m
//  testdemodd
//
//  Created by Apple on 11/1/22.
//

#import "TableViewDynamicDelegate.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>


/// Delegate 的子类前缀
static NSString *const kSensorsDelegatePrefix = @"cn.Sensor.";
// tableView:didSelectRowAtIndexPath: 方法指针类型
typedef void (*TableDidSelectImplementation)(id, SEL, UITableView *, NSIndexPath *);

@implementation TableViewDynamicDelegate

+ (void)proxyWithTableViewDelegate:(id <UITableViewDelegate>)delegate  {
   
    SEL originalSelector = NSSelectorFromString(@"tableView:didSelectRowAtIndexPath:");
    //当Delegate中没有实现tbaleView:didSelectRowAtIndexPath:方法时，直接返回
    if (![delegate respondsToSelector:originalSelector]) {
        NSLog(@"没有实现tbaleView:didSelectRowAtIndexPath:方法");
        return;
    }
    //动态创建一个新类
    Class originalClass =  object_getClass(delegate);
    NSString *originalClassName = NSStringFromClass(originalClass);
    
    //判断这个delegate对象是否已经动态创建的类时，无须重复设置，直接返回
    if([originalClassName hasPrefix:kSensorsDelegatePrefix])  {
        return;
    }
    
    NSString *subClassName = [kSensorsDelegatePrefix stringByAppendingString:originalClassName];
    Class subclass = NSClassFromString(subClassName);
    if (!subclass) {
        //注册一个新的子类，其父类为originalclass
        subclass = objc_allocateClassPair(originalClass, subClassName.UTF8String, 0);
        //获取TableViewDynamicDelegate中的tableView:didSelectRowAtIndexPath指针
        Method method = class_getInstanceMethod(self, originalSelector);
        //获取方法实现
        IMP methodIMP = method_getImplementation(method);
        //获取方法类型的编码
        const char *types = method_getTypeEncoding(method);
        //在subClass中添加 tableView:didSelectRowAtIndexPath: 方法
        if(!class_addMethod(subclass, originalSelector,methodIMP , types)) {
            NSLog(@"方法已经存在");
        }
        
        /*删除动态生成的前缀，动态添加方法（sensorsdata_class）*/

        // 获取 TableViewDynamicDelegate 中的 sensorsdata_class 方法指针
        Method classMethod = class_getInstanceMethod(self, @selector(sensorsdata_class));
        // 获取方法实现
        IMP classIMP = method_getImplementation(classMethod);
        //获取方法的类型编码
        const char *classTypes = method_getTypeEncoding(classMethod);
        //在subclass中添加class方法
        if (!class_addMethod(subclass, @selector(class), classIMP, classTypes)) {
            NSLog(@"添加方法失败");
        }
        //子类和原始类的大小必须一致，不能有更多的ivars或者属性
        //如果不同会导致设置新的子类时，会重新设置内存，导致重写了对象的isa指针
        if (class_getInstanceSize(originalClass) != class_getInstanceSize(subclass)) {
            return;
        }
        //将delegate对象设置为新的子类对象
        objc_registerClassPair(subclass);
    }
    if (object_setClass(delegate, subclass)) {
        NSLog(@"创建成功");
    }
}

//删除自动创建类名的私有方法
- (Class)sensorsdata_class {
    // 获取对象的类
    Class class = object_getClass(self);
    // 将类名前缀替换成空字符串，获取原始类名
    NSString *className = [NSStringFromClass(class) stringByReplacingOccurrencesOfString:kSensorsDelegatePrefix withString:@""];
    // 通过字符串获取类，并返回
    return objc_getClass([className UTF8String]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //第一步：获取原始的类
    Class cla = object_getClass(tableView.delegate);
    NSString *className = [NSStringFromClass(cla) stringByReplacingOccurrencesOfString:kSensorsDelegatePrefix withString:@""];
    Class originalClass = objc_getClass([className UTF8String]);
    
    //第二步：调用开发者自己实现的方法
    SEL originalSelector = NSSelectorFromString(@"tableView:didSelectRowAtIndexPath:");
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    IMP originalIMP = method_getImplementation(originalMethod);
    if (originalIMP) {
       ((TableDidSelectImplementation)originalIMP)(tableView.delegate,originalSelector,tableView,indexPath);
    }
    
    
    NSMutableArray *dataSource = [self valueForKey:@"dataSource"];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"sensor--->%@--%@:clicked", NSStringFromClass([cell class]), dataSource[indexPath.row]);
    // todo
    // track data
    
}

@end
