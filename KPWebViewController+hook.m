//
//  KPWebViewController+hook.m
//  TestKeplerDemo
//
//  Created by xmfish on 17/1/5.
//  Copyright © 2017年 jd. All rights reserved.
//

#import "KPWebViewController+hook.h"
#import <objc/runtime.h>
@implementation KPWebViewController (hook)

+ (void)load
{
    Method ori_Method =  class_getInstanceMethod([KPWebViewController class], @selector(viewWillAppear:));
    Method my_Method = class_getInstanceMethod([KPWebViewController class], @selector(ash_viewWillAppear:));
    
    method_exchangeImplementations(ori_Method, my_Method);
}

- (void)ash_viewWillAppear:(BOOL)animal
{
    [self ash_viewWillAppear:animal];
    
    UIView* navigationview = [[self valueForKey:@"_kpView"] valueForKey:@"_navigationView"];
    navigationview.hidden = YES;
    UINavigationController* nav = self.navigationController;
    
    self.title = @"我才是navigationtitle";
    nav.navigationBar.hidden = NO;
    [nav setNavigationBarHidden:NO];
}
@end
