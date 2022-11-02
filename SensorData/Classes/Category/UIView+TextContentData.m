//
//  UIView+TextContentData.m
//  testdemodd
//
//  Created by Apple on 11/1/22.
//

#import "UIView+TextContentData.h"

@implementation UIView (TextContentData)

- (NSString *)elementType {
    return  NSStringFromClass([self class]);
}

- (NSString *)elementContent {
    // 如果是隐藏控件，不获取控件内容
    if (self.isHidden || self.alpha == 0) { return nil; }
    // 初始化数组，用于保存子控件的内容
    NSMutableArray *contents = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        // 获取子控件的内容
        // 如果子类有内容，例如UILabel的text，获取到的就是text属性
        // 如果子类没有内容，就递归调用该方法，获取其子控件的内容
        NSString *content = view.elementContent;
        if (content.length > 0) {
            // 当该子控件有内容时，保存在数组中
            [contents addObject:content];
        }
    }
    // 当未获取到子控件内容时，返回nil。如果获取到多个子控件内容时，使用"-"拼接
    return contents.count == 0 ? nil : [contents componentsJoinedByString:@"-"];
}

- (UIViewController *)myViewController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return  nil;
}
@end

@implementation  UIButton (TextContentData)

- (NSString *)elementContent {
    return self.titleLabel.text ?: super.elementContent;
}

@end


@implementation UISwitch (TextContentData)

- (NSString *)elementContent {
    return self.on ? @"checked":@"unchecked";
}

@end

@implementation UILabel (TextContentData)

- (NSString *)elementContent {
    
    return self.text ?: super.elementContent;
}

@end
