//
//  ViewController.m
//  SWHotFix
//
//  Created by SanW on 2019/11/1.
//  Copyright © 2019 SanW. All rights reserved.
//

#import "ViewController.h"
#import "SWHotFix.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
    // 待解决问题
    // 1.修改参数
    // 2.修改参数是自定义参数
    // 3.修改具体实现
    
    // demo
    // 1.修改返回值
    //  [[SWHotFix sharedInstance] evaluateScript:@"fixMethodPositionInstead('ViewController','collectView:isFollow:',function(instance,argumet,invocation){fixReturnValue(invocation,'im bad');});"];
    // 2.替换空方法
    // [[SWHotFix sharedInstance] evaluateScript:@"fixMethodPositionInstead('ViewController','collectView:isFollow:',function(instance,argumet,invocation){console.log('☁️🚲✨zero goes here')});"];
    // 3.修改参数值
    [[SWHotFix sharedInstance] evaluateScript:@"fixMethodPositionBefore('ViewController','collectView:isFollow:',function(instance,argumet,invocation){console.log(argumet);if(argumet[0] == 1) {argumet[0] = 0;console.log(argumet);};runInvocation(invocation)});"];
    NSString *value = [self collectView:YES isFollow:@"are you ok"];
    NSLog(@"value == %@",value);
}
- (NSString *)collectView:(BOOL )isBool isFollow:(NSString *)isFollow{
    NSLog(@"继续执行 : isBool = %d,isFollow = %@",isBool,isFollow);
    isFollow = @"";
    return @"完成执行";
}

@end
