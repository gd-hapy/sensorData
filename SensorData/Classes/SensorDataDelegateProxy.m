//
//  SensorDataDelegateProxy.m
//  testdemodd
//
//  Created by Apple on 11/1/22.
//

#import "SensorDataDelegateProxy.h"

@implementation SensorDataDelegateProxy

+ (instancetype)proxywithTableViewDelegate:(id<UITableViewDelegate>)delegate {
    SensorDataDelegateProxy *proxy = [SensorDataDelegateProxy alloc];
    proxy.delegate = delegate;
    return  proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    //返回delegate对象的方法签名
    return [(NSObject *)self.delegate methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.delegate];
    if (invocation.selector == @selector(tableView:didSelectRowAtIndexPath:)) {
        invocation.selector = NSSelectorFromString(@"sensorDatatableView:didSelectRowAtIndexPath:");
        [invocation invokeWithTarget:self];
    }
}

-(void)sensorDatatableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSMutableArray *dataSource = [self.delegate valueForKey:@"dataSource"];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"sensor--->%@--%@:clicked", NSStringFromClass([cell class]), dataSource[indexPath.row]);
    // todo
    // track data
}

@end



#import <objc/runtime.h>

@implementation UIScrollView (SensorData)


- (void)setSensorData_delegateProxy:(SensorDataDelegateProxy *)sensorData_delegateProxy {
    objc_setAssociatedObject(self, @selector(setSensorData_delegateProxy:), sensorData_delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SensorDataDelegateProxy *)sensorData_delegateProxy {
    return objc_getAssociatedObject(self, @selector(sensorData_delegateProxy));
}
@end
