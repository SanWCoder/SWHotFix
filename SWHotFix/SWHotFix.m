//
//  SWHotFix.m
//  SWHotFix
//
//  Created by SanW on 2019/11/1.
//  Copyright © 2019 SanW. All rights reserved.
//

#import "SWHotFix.h"
#import "Aspects.h"
#import <JavaScriptCore/JavaScriptCore.h>

#ifdef DEBUG
// 打印
#define SWLog(fmt, ...) NSLog((@"\n👉[SWHotFix]func: %s \n  line: %d \n  message: "fmt"👈"), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
// 打印
#define SWLog(...)
#endif


@implementation SWHotFix

/// 初始化
+ (SWHotFix *)sharedInstance
{
    static SWHotFix *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[SWHotFix alloc] init];
    });
    return instance;
}
- (JSContext *)jsContext{
    if (!_jsContext) {
        _jsContext = [[JSContext alloc]init];
        [_jsContext setExceptionHandler:^(JSContext *context, JSValue *exception) {
            SWLog(@"context = %@,exception = %@",context,exception)
        }];
        [self fixInit];
    }
    return _jsContext;
}
// 初始化
- (void)fixInit{
    __weak typeof(self)weakSelf = self;
    self.jsContext[@"fixMethodPositionBefore"] = ^(NSString *instanceName,NSString *selName,JSValue *jsValue){
        [weakSelf fixMethodWithInstanceName:instanceName selName:selName jsValue:jsValue aspectOptions:AspectPositionBefore];
    };
    self.jsContext[@"fixMethodPositionInstead"] = ^(NSString *instanceName,NSString *selName,JSValue *jsValue){
        [weakSelf fixMethodWithInstanceName:instanceName selName:selName jsValue:jsValue aspectOptions:AspectPositionInstead];
    };
    self.jsContext[@"fixMethodPositionAfter"] = ^(NSString *instanceName,NSString *selName,JSValue *jsValue){
        [weakSelf fixMethodWithInstanceName:instanceName selName:selName jsValue:jsValue aspectOptions:AspectPositionAfter];
    };
    self.jsContext[@"fixMethodPositionRemoval"] = ^(NSString *instanceName,NSString *selName,JSValue *jsValue){
        [weakSelf fixMethodWithInstanceName:instanceName selName:selName jsValue:jsValue aspectOptions:AspectOptionAutomaticRemoval];
    };
    // 修复返回值
    self.jsContext[@"fixReturnValue"] = ^(NSInvocation *invocation,id newReturnValue){
        [invocation setReturnValue:&newReturnValue];
    };
    // 继续运行
    self.jsContext[@"runInvocation"] = ^(NSInvocation *invocation){
        [invocation invoke];
    };
    // 继续运行
    self.jsContext[@"fixArguments"] = ^(NSInvocation *invocation,id argument){
        [invocation invoke];
    };
    self.jsContext[@"console"][@"log"] = ^(id message) {
        SWLog(@"message = %@",message);
    };
}
/// 执行js
/// @param script js代码
- (void)evaluateScript:(NSString *)script{
    if (script && script.length) {
        [self.jsContext evaluateScript:script];
    }
}
- (void)fixMethodWithInstanceName:(NSString *)instanceName selName:(NSString *)selName jsValue:(JSValue *)jsValue aspectOptions:(AspectOptions)aspectOptions{
    if (instanceName && instanceName.length && selName && selName.length && jsValue) {
        Class class = NSClassFromString(instanceName);
        SEL sel = NSSelectorFromString(selName);
        [class aspect_hookSelector:sel withOptions:aspectOptions usingBlock:^(id<AspectInfo> aspectInfo){
            [jsValue callWithArguments:@[aspectInfo.instance,aspectInfo.arguments,aspectInfo.originalInvocation]];
        } error:NULL];
    }
}
@end
