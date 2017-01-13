//
//  KeplerApiManager.h
//  KeplerApp
//  提供Kepler服务
//  Created by JD.K on 16/6/20.
//  Copyright © 2016年 JD.K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#define JDKepler_Deprecated(instead) NS_DEPRECATED_IOS(1_1_0, 1_2_2,instead)

/** 初始化成功回调 */
typedef void (^initSuccessCallback)();
/** 初始化失败回调 */
typedef void (^initFailedCallback)(NSError *error);
/**
 *  Kepler登录授权成功回调
 *
 *  @param token  登录授权成功后返回的token
 */
typedef void (^keplerLoginSuccessCallback)(NSString *token);
/** Kepler登录授权失败回调 */
typedef void (^keplerLoginFailureCallback)(NSError *error);



@interface KeplerApiManager : NSObject{
    
}
/**
 *  KeplerApiManager 单例
 *
 *  @return KeplerApiManager 单例
 */
+ (KeplerApiManager *)sharedKPService;
/**
 *  注册Kepler 服务
 *
 *  @param appKey      注册的appKey
 *  @param appSecret   注册的secretKey
 */
- (void)asyncInitSdk:(NSString *)appKey
           secretKey:(NSString *)appSecret
      sucessCallback:(initSuccessCallback)sucessCallback
      failedCallback:(initFailedCallback)failedCallback;
/**
 *  通过URL打开Kepler页面
 *
 *  @param url              页面url
 *  @param sourceController 当前显示的UIViewController
 *  @param jumpType         跳转类型(默认 push) 1代表present 2代表push
 *  @param customParams     自定义订单统计参数 不需要可以传nil
 */
- (void)openKeplerPageWithURL:(NSString *)url sourceController:(UIViewController *)sourceController jumpType:(NSInteger)jumpType customParams:(NSString *)customParams;

/**
 *  打开热卖页
 */
- (void)openHotSalePage:(UIViewController *)sourceController jumpType:(NSInteger)jumpType customParams:(NSString *)customParams;

/**
 *  打开导航页
 */
- (void)openNavigationPage:(UIViewController *)sourceController jumpType:(NSInteger)jumpType customParams:(NSString *)customParams;
/**
 *  根据传入的名称打开对应的分类列表
 */
- (void)openCategoryListWithName:(NSString *)categoryName sourceController:(UIViewController *)sourceController jumpType:(NSInteger)jumpType customParams:(NSString *)customParams;

/**
 *  通过SKU打开Kepler单品页
 *
 *  @param sku              商品SKU
 */
- (void)openItemDetailWithSKU:(NSString *)sku sourceController:(UIViewController *)sourceController jumpType:(NSInteger)jumpType customParams:(NSString *)customParams;

/**
 *  打开订单列表
 */
- (void)openOrderList:(UIViewController *)sourceController jumpType:(NSInteger)jumpType customParams:(NSString *)customParams;

/**
 *  根据搜索关键字打开搜索结果页
 *
 *  @param searchKey        搜索关键字
 */
- (void)openSearchResult:(NSString *)searchKey sourceController:(UIViewController *)sourceController jumpType:(NSInteger)jumpType customParams:(NSString *)customParams;

/**
 *  打开购物车界面
 *
 */
- (void)openShoppingCart:(UIViewController *)sourceController jumpType:(NSInteger)jumpType customParams:(NSString *)customParams;

/**
 *  添加到购物车
 *
 *  @param skuList 添加到购物车中的商品id
 *  @param numList 添加到购物车中商品数量,多个商品必须与skuList一一对应
 *  @param success 添加成功回调
 *  @param failure 添加失败回调
 */
- (void)addToCartWithSkuList:(NSArray *)skuList numList:(NSArray *)numList sourceController:(UIViewController *)sourceController success:(void(^)(void))success failure:(void(^)(NSError *))failure;
/**
 *  直接购买
 *  @param skuList 添加到购物车中的商品id
 *  @param numList 添加到购物车中商品数量,多个商品必须与skuList一一对应
 *
 */
- (void)directBuyWithSkuList:(NSArray *)skuList numList:(NSArray *)numList sourceController:(UIViewController *)sourceController jumpType:(NSInteger)jumpType customParams:(NSString *)customParams;

/**
 *  Kepler处理URL
 *
 *  @param url url
 *
 *  @return 处理结果
 */
- (BOOL)handleOpenURL:(NSURL*)url;
/**
 *  检测更新
 */
- (void)checkJDKeplerUpdate;

/**
 *  取消授权
 */
- (void)cancelAuth;

/**
 *  设置加载进度条颜色
 */
- (void)setKeplerProgressBarColor:(UIColor *)progressBarColor;

/**
 *  Kepler登录授权
 */
- (void)keplerLoginWithViewController:(UIViewController *)viewController success:(keplerLoginSuccessCallback)successCallback failure:(keplerLoginFailureCallback)failureCallback;

/**
 *  标识曾经登录完成过，因为服务端安全逻辑，可能这个用户登录态已经失效
 */
- (BOOL)isKeplerLogin;

@end
