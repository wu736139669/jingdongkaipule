//
//  ViewController.m
//  JDKeplerDevApp
//
//  Created by Lemon on 16/1/20.
//  Copyright © 2016年 jd. All rights reserved.
//

#import "ViewController.h"
#import <JDKeplerSDK/KeplerApiManager.h>

@interface ViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UITextField *testField;
@property (nonatomic, strong) UITextField *textFieldSKUList;
@property (nonatomic, strong) UITextField *textFieldNumList;
@property (nonatomic, strong) UITextField *currentTextField;
@property(nonatomic, weak) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    self.scrollView = scrollView;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    CGFloat height = 60.0f;
    
    self.testField = [[UITextField alloc]initWithFrame:CGRectMake(15, 30, self.view.frame.size.width-30, 30)];
    self.testField.textAlignment = NSTextAlignmentLeft;
    self.testField.font = [UIFont systemFontOfSize:14.0f];
    self.testField.backgroundColor = [UIColor whiteColor];
    self.testField.layer.borderWidth = 1.0f;
    self.testField.layer.borderColor =[UIColor orangeColor].CGColor;
    self.testField.placeholder = @"请输入Url／Sku编号／分类名称/搜索名 不输入使用默认值";
    self.testField.layer.cornerRadius = 2.0f;
    self.testField.delegate = self;
    [self.scrollView addSubview:self.testField];
    
    CGFloat left = (self.view.frame.size.width - 200)/3.0f;
    CGFloat right = self.view.frame.size.width - left - 100.0f;
    
    [self addButton:@"清除" xPos:left yPos:65 action:@selector(clearTextField)];
    [self addButton:@"粘贴" xPos:right yPos:65 action:@selector(pasteToTextField)];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 65+45, self.view.frame.size.width, 1)];
    lineView1.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:lineView1];
    
    [self addButton:@"商详页" xPos:right yPos:65+height*1 action:@selector(skuClick)];
    [self addButton:@"URL跳转" xPos:left yPos:65+height*1 action:@selector(urlJumpClick)];
    [self addButton:@"分类列表" xPos:right yPos:65+height*2 action:@selector(categoryList)];
    [self addButton:@"搜索" xPos:left yPos:65+height*2 action:@selector(search)];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 65+height*3+45, self.view.frame.size.width, 1)];
    lineView2.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:lineView2];
    
    [self addButton:@"导航页" xPos:left yPos:65+height*4 action:@selector(homeClick)];
    [self addButton:@"热卖页" xPos:right yPos:65+height*4 action:@selector(hotClick)];
    [self addButton:@"取消授权" xPos:left yPos:65+height*6 action:@selector(cancelClick)];
    [self addButton:@"订单列表" xPos:left yPos:65+height*5 action:@selector(orderList)];
    [self addButton:@"打开购物车" xPos:right yPos:65+height*5 action:@selector(openShoppingCart)];
    [self addView:@"登录授权" yPos:65+height*7 action:@selector(loginSwitchAction:)];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 65+height*7+45, self.view.frame.size.width, 1)];
    lineView3.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:lineView3];
    
    self.textFieldSKUList = [[UITextField alloc] initWithFrame:CGRectMake(15, 65+height*8, self.view.frame.size.width-30, 30)];
    self.textFieldSKUList.layer.borderWidth = 1.0f;
    self.textFieldSKUList.layer.borderColor = [UIColor orangeColor].CGColor;
    self.textFieldSKUList.layer.cornerRadius = 2.0f;
    self.textFieldSKUList.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldSKUList.placeholder = @"SKUList 用空格隔开 不填写使用默认值";
    self.textFieldSKUList.delegate = self;
    [self.scrollView addSubview:self.textFieldSKUList];
    
    self.textFieldNumList = [[UITextField alloc] initWithFrame:CGRectMake(15, 65+height*9, self.view.frame.size.width-30, 30)];
    self.textFieldNumList.layer.borderWidth = 1.0f;
    self.textFieldNumList.layer.borderColor = [UIColor orangeColor].CGColor;
    self.textFieldNumList.layer.cornerRadius = 2.0f;
    self.textFieldNumList.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldNumList.placeholder = @"NumList 用空格隔开 不填写使用默认值";
    self.textFieldNumList.delegate = self;
    [self.scrollView addSubview:self.textFieldNumList];
    
    [self addButton:@"加入购物车" xPos:left yPos:65+height*10 action:@selector(addToCart)];
    [self addButton:@"直接购买" xPos:right yPos:65+height*10 action:@selector(directBuy)];
    
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([self.scrollView.subviews lastObject].frame) + 50);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

- (void)addButton:(NSString *)title xPos:(CGFloat)x yPos:(CGFloat)y action:(SEL)action{
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 100, 30)];
    [testButton setTitle:title forState:UIControlStateNormal];
    testButton.backgroundColor = [UIColor blueColor];
    testButton.showsTouchWhenHighlighted =YES;
    [self.scrollView addSubview:testButton];
    [testButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addView:(NSString *)title yPos:(CGFloat)y action:(SEL)action{
    
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, y, 200, 30)];
    containView.backgroundColor = [UIColor blueColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [containView addSubview:label];
    
    UISwitch *loginSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, 0, 0)];
    [loginSwitch addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [containView addSubview:loginSwitch];
    
    [self.scrollView addSubview:containView];
    
}
- (void)clearTextField
{
    self.testField.text = nil;
}
- (void)pasteToTextField
{
    self.testField.text = [[UIPasteboard generalPasteboard] string];
}
- (void)loginSwitchAction:(UISwitch *)loginSwitch
{
    BOOL isSwitchOn = loginSwitch.isOn;
    if (isSwitchOn) {
        [[KeplerApiManager sharedKPService] keplerLoginWithViewController:self success:^(NSString *token) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录授权" message:@"登录授权成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } failure:^(NSError *error) {
            loginSwitch.on = NO;
        }];
    }else{
        [[KeplerApiManager sharedKPService] cancelAuth];
    }
}


- (void)skuClick{
    NSString *sku = self.testField.text.length?self.testField.text:@"1152042";
    [[KeplerApiManager sharedKPService] openItemDetailWithSKU:sku sourceController:self jumpType:2 customParams:nil];
}


- (void)hotClick{
    //    NSString *json = @"{\"type\": \"2\",\"blockId\":\"0\"}";
    [[KeplerApiManager sharedKPService] openHotSalePage:self jumpType:2 customParams:nil];
}

- (void)homeClick{
    //    NSString *json = @"{\"type\": \"3\",\"blockId\":\"0\"}";
    [[KeplerApiManager sharedKPService] openNavigationPage:self jumpType:2 customParams:nil];
}

- (void)cancelClick{
    [[KeplerApiManager sharedKPService] cancelAuth];
}

- (void)urlJumpClick {
    
    //修改url并且重定向
    NSString *url = @"http://m.jd.com";
    
    url = @"http://union.click.jd.com/jdc?p=AyIOZRprFQoSAlcZWCVGTV8LRGtMR1dGXgVFSR1JUkpJBUkcU0QLTh9HRwwHXRteFwARGAxeB0gMVQsQDAFBSkVEC0dXZUNTcRFFBEFaakIBR2tOX1RkHUU5XWFuVyIYC00AZFsJXidlDh43VhleHAYSB1UfaxUFFjdlfSYlVHwHVBpaFAMTBFASaxQyEgJRHV4cBBoFVBNfEjIVNwpPHkFSUFMdRR9AUkw3ZRo%3D&t=W1dCFBBFC14NXAAECUteDEYWRQ5RUFcZVRNbEAAQBEpCHklfHEBZXkxPVlpQFkUHGXJTRiNfBUpWSn8QTwc%3D&e=25840255236224";
    url = @"http://baidu.com1";
    NSString *text = self.testField.text;
    if (text.length > 0) {
        url = text;
    }
    //    NSString *json = [NSString stringWithFormat:@"{\"type\": \"4\",\"url\":\"%@\"}",url];
    
    [[KeplerApiManager sharedKPService] openKeplerPageWithURL:url sourceController:self jumpType:2 customParams:@"from_os=iOS"];
}

- (void)loginAuth
{
    [[KeplerApiManager sharedKPService] keplerLoginWithViewController:self success:^(NSString *token) {
        NSLog(@"登录授权成功");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录授权" message:@"登录授权成功" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"OK", nil];
        [alert show];
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录授权" message:@"登录授权失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"OK", nil];
        [alert show];
    }];
}

- (void)orderList
{
    [[KeplerApiManager sharedKPService] openOrderList:self jumpType:1 customParams:@"统计参数"];
}

- (void)categoryList
{
    NSString *categoryName = self.testField.text.length>0?self.testField.text:@"手机";
    [[KeplerApiManager sharedKPService] openCategoryListWithName:categoryName sourceController:self jumpType:2 customParams:nil];
}

- (void)search
{
    NSString *text = self.testField.text.length>0?self.testField.text:@"macbookPro";
    [[KeplerApiManager sharedKPService] openSearchResult:text sourceController:self jumpType:2 customParams:nil];
}

- (void)addToCart
{
    NSString *skuListStr = self.textFieldSKUList.text.length?self.textFieldSKUList.text:@"1152042 1564869";
    NSArray *skuListArray = [skuListStr componentsSeparatedByString:@" "];
    NSString *numListStr = self.textFieldNumList.text.length?self.textFieldNumList.text:@"3 10";
    NSArray *numListArray = [numListStr componentsSeparatedByString:@" "];
    [[KeplerApiManager sharedKPService] addToCartWithSkuList:skuListArray numList:numListArray sourceController:self success:^{
        NSLog(@"添加成功");
    } failure:^(NSError *error) {
        
        NSInteger code = error.code;
        switch (code) {
            case 1003: //token不存在
            case 1004: //token过期
            case 1022: //缺少token参数
                //需先调用登录授权接口,成功后再调用该添加购物车方法.
                break;
                
                
            case 8969: //购物车商品达到最上限
                break;
            case 500: //添加失败
                break;
                
            case 1005: //app_key不存在
            case 1020: //缺少app_key参数
            case 1021: //无效app_key
                break;
                
            case 3038: //系统错误
                break;
            default:
                break;
        }
        
    }];
}

- (void)directBuy
{
    NSString *skuListStr = self.textFieldSKUList.text.length?self.textFieldSKUList.text:@"1152042 1564869";
    NSArray *skuListArray = [skuListStr componentsSeparatedByString:@" "];
    NSString *numListStr = self.textFieldNumList.text.length?self.textFieldNumList.text:@"3 10";
    NSArray *numListArray = [numListStr componentsSeparatedByString:@" "];
    [[KeplerApiManager sharedKPService] directBuyWithSkuList:skuListArray numList:numListArray sourceController:self jumpType:2 customParams:nil];
}

- (void)openShoppingCart
{
    [[KeplerApiManager sharedKPService] openShoppingCart:self jumpType:2 customParams:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.testField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 键盘事件
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    CGFloat textField_maxY = CGRectGetMaxY(self.currentTextField.frame);
    CGFloat space = - self.scrollView.contentOffset.y + textField_maxY;
    CGFloat transformY = height - space;
    if (transformY < 0) {
        CGRect frame = self.view.frame;
        frame.origin.y = transformY ;
        self.view.frame = frame;
    }
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentTextField = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end
