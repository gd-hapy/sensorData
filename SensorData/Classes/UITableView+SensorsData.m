//
//  UITableView+SensorsData.m
//  testdemodd
//
//  Created by Apple on 10/31/22.
//

#define __scheme 1
#import "UITableView+SensorsData.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"
#import "UIView+TextContentData.h"

#import "TableViewDynamicDelegate.h"
#import "SensorDataDelegateProxy.h"

@implementation UITableView (SensorsData)

+ (void)load {
    [UITableView sensorsdata_swizzleMethod:@selector(setDelegate:) withMethod:@selector(sensorData_setDelegate:)];
}


#if __scheme == 1
#pragma mark --方案一 方法交换
- (void)sensorData_setDelegate:(id<UITableViewDelegate>)delegate {
    /* 方法交换 */
    [self sensorData_setDelegate:delegate];
    [self sensorData_swizzleDidSelectRowAtIndexPathMethodWithDelegate:delegate];
}

#elif __scheme == 2
#pragma mark --方案二 动态子类
- (void)sensorData_setDelegate:(id<UITableViewDelegate>)delegate {
    /* 方案2 动态子类 */
    [self sensorData_setDelegate:delegate];
    //设置delegate的动态子类
    [TableViewDynamicDelegate proxyWithTableViewDelegate:delegate];
}

#else
#pragma mark --方案三 消息转发
- (void)sensorData_setDelegate:(id<UITableViewDelegate>)delegate {

    /* NSProxy 消息转发 */
    self.sensorData_delegateProxy = nil;
    if (delegate) {
        SensorDataDelegateProxy *proxy = [SensorDataDelegateProxy proxywithTableViewDelegate:delegate];
        self.sensorData_delegateProxy = proxy;
        [self sensorData_setDelegate:(id)proxy];
    }else {
        [self sensorData_setDelegate:nil];
    }
}
#endif

//添加交换方法
static void sensorData_tableViewDidSelectRow(id object,SEL selector,UITableView *tableView,NSIndexPath *indexPath) {
    SEL destinationSelector = NSSelectorFromString(@"sensorData_tableView:didSelectRowAtIndexPath:");
    //发送消息，调用原始的tableView:didSelectRowAtIndexPath:方法实现
    ((void (*)(id,SEL,id,id))objc_msgSend)(object,destinationSelector,tableView,indexPath);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *dataSource = [object valueForKey:@"dataSource"];
    
//    cell.elementType
//    cell.elementContent;
    NSLog(@"sensor--->%@--%@:clicked--%@-%@", NSStringFromClass([cell class]), dataSource[indexPath.row], cell.elementType, cell.elementContent);
    // todo
    // track data
}

- (void)sensorData_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"original:didSelectRowAtIndexPath");
//    [self sensorData_tableView:tableView didSelectRowAtIndexPath:indexPath];/
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSMutableArray *dataSource = [object valueForKey:@"dataSource"];
    
//    cell.elementType
//    cell.elementContent;
//    NSLog(@"sensor--->%@--%@:clicked--%@-%@", NSStringFromClass([cell class]), dataSource[indexPath.row], cell.elementType, cell.elementContent);
    NSLog(@"%@-%@", cell.elementType, cell.elementContent);

    [tableView sensorData_tableView:tableView didSelectRowAtIndexPath:indexPath];
    
}

#pragma mark- 私有方法，负责给delegate对象添加一个方法并进行交换
-(void)sensorData_swizzleDidSelectRowAtIndexPathMethodWithDelegate:(id)delegate {
   //获取delegate对象的类
    
    Class delegateClass = [delegate class];
    //方法名
    SEL sourceSelector = @selector(tableView:didSelectRowAtIndexPath:);
    //当delegate对象中没有实现方法tableView:didSelectRowAtIndexPath:,直接返回
    if (![delegate respondsToSelector:sourceSelector]) {
        NSLog(@"没有实现tableView:didSelectRowAtIndexPath方法");
        return;
    }
    
    SEL destinationSelector = NSSelectorFromString(@"sensorData_tableView:didSelectRowAtIndexPath:");
    //当delegate对象已经存在了sensorData_tableView:didSelectRowAtIndexPath:，说明已经交换，可以直接返回
    if ([delegate respondsToSelector:destinationSelector]) {
        return;
    }
    

    Method sourceMethod = class_getInstanceMethod(delegateClass, sourceSelector);
    const char *encoding = method_getTypeEncoding(sourceMethod);
    //当类中已经存在相同的方法时，则会添加方法失败。当时前面已经判断过方法是否存在。因此，此处一定会添加成功
//    if (!class_addMethod([delegate class], destinationSelector,(IMP)sensorData_tableViewDidSelectRow, encoding)) {
//        return;
//    }
    
    //方法添加之后，进行方法交换
//    [delegateClass sensorsdata_swizzleMethod:sourceSelector withMethod:destinationSelector];
    [delegateClass sensorsdata_swizzleMethodOriginalClass:delegate withOriginalSel:sourceSelector withAlternalClass:[self class] withMethod:destinationSelector];
    [self methodList];
}

- (void)methodList {
    
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(UITableView.class, &count);
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        [list addObject:NSStringFromSelector(sel)];
    }
    
    free(methodList);
    NSLog(@"~~~~~~:%@", list);
}
@end
