//
//  KPNavigationView+hook.m
//  TestKeplerDemo
//
//  Created by xmfish on 17/1/5.
//  Copyright © 2017年 jd. All rights reserved.
//

#import "KPNavigationView+hook.h"
#import <objc/runtime.h>
@implementation KPNavigationView (hook)

+ (void)load
{

    
    Method ori_Method =  class_getInstanceMethod([KPNavigationView class], @selector(layoutSubviews));
    Method my_Method = class_getInstanceMethod([KPNavigationView class], @selector(ash_layoutSubviews));

    method_exchangeImplementations(ori_Method, my_Method);

}


- (void)ash_layoutSubviews
{
    [self ash_layoutSubviews];
    UILabel* title = [self valueForKey:@"_titleLabel"];
    title.text = @"哇哈哈";
    
    UIButton* rightButton = [self valueForKey:@"_rightButton"];
    [rightButton setTitle:@"分享" forState:UIControlStateNormal];

    
    UIButton* dotButton = [self valueForKey:@"_dotButton"];
    dotButton.hidden = YES;

}
@end
