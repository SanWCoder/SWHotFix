//
//  SWHotFix.h
//  AspectTesst
//
//  Created by SanW on 2019/10/31.
//  Copyright © 2019 SanW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWHotFix : NSObject

@property (nonatomic,strong) JSContext *jsContext;
/// 初始化
+ (SWHotFix *)sharedInstance;
/// 执行js
/// @param script js代码
- (void)evaluateScript:(NSString *)script;
@end

NS_ASSUME_NONNULL_END
