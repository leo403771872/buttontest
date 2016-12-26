//
//  ViewController.m
//  buttontest
//
//  Created by yy on 16/8/3.
//  Copyright (c) 2016年 yy. All rights reserved.
//

#import "ViewController.h"
#import "IDCardPrintViewController.h"
#import "yyTools.h"
#import "yyMD5.h"

#import "ScanViewController.h"
@interface testView : UIView

@end

@implementation testView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return NO;
}

@end


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(200, 200, 100, 100);
//    button.backgroundColor = [UIColor greenColor];
//    [button addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
//    testView *coverView = [[testView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    coverView.userInteractionEnabled = YES;
//    coverView.backgroundColor = [UIColor redColor];
//    [button addSubview:coverView];
    
    
    
    //http://yunprint.me:8080
//    [self GetSalesNetworkInquiry];//获取该城市打印点列表
//    [self getChargingScheme];//获取计费方案
//    [self UserLogin];//用户登录
//    [self GetUserInfo];//获取用户信息
//    [self userRegist];//用户注册
    [self userForgetPassword];//用户忘记密码
    //12
}

- (void)userForgetPassword{//用户忘记密码
    NSString *CID = @"13904281820";
    NSString *password = [yyMD5 md5:@"00000000"];
    //@"https://172.25.73.34/testone"
    NSString *url = @"https://139.196.149.231/UserLogin";//https://139.196.149.231/UserLogin
    NSDictionary *body = @{@"access_token":@"5TyL8PmU7cX49YtUI3QwPmTw530vbYnF", @"PhoneNo":CID, @"Password":password};
    //    NSDictionary *body = @{@"abc":@"123"};
    NSLog(@"%@", body);
    [yyTools POSTWithAFHTTPResponseSerializerByURL:url body:body completion:^(id result) {
        
    } failed:^(id error) {
        
    }];
}//用户忘记密码

- (void)userRegist{//用户注册
    NSString *CID = @"13904281820";
    NSString *password = @"00000000";
    NSString *code = @"951574";
    //@"https://172.25.73.34/testone"
    NSString *url = @"https://139.196.149.231/UserRegister";//https://139.196.149.231/UserLogin
    NSDictionary *body = @{@"access_token":@"5TyL8PmU7cX49YtUI3QwPmTw530vbYnF", @"PhoneNo":CID, @"Password":password, @"VerifyCode":code};
    //    NSDictionary *body = @{@"abc":@"123"};
    NSLog(@"%@", body);
    [yyTools POSTWithAFHTTPResponseSerializerByURL:url body:body completion:^(id result) {
        
    } failed:^(id error) {
        
    }];
}//用户注册

- (void)GetUserInfo{//获取用户信息   成功  这个接口需要先登录才能调用成功
    
    NSString *CID = @"13904281820";
    NSString *password = [yyMD5 md5:@"00000000"];
    
    NSString *url = [NSString stringWithFormat:@"https://139.196.149.231/GetUserInfo?access_token=5TyL8PmU7cX49YtUI3QwPmTw530vbYnF&CID=%@&Password=%@", CID, password];
    [yyTools GETWithAFJSONResponseSerializerByURL:url completion:^(id result) {
        NSLog(@"**__**   %@", result);
    } failed:^(id error) {
        NSLog(@"222");
    }];
    
//    {
//        Account = 13904281820;
//        BirthDay = "<null>";
//        BonusPoint = 0;
//        MobileID = 13904281820;
//        Nickname = "<null>";
//        Sex = "<null>";
//    }
}//获取用户信息   成功

- (void)UserLogin{//用户登录   成功
    NSString *CID = @"13904281820";
    NSString *password = [yyMD5 md5:@"00000000"];
    //@"https://172.25.73.34/testone"
    NSString *url = @"https://139.196.149.231/UserLogin";//https://139.196.149.231/UserLogin
    NSDictionary *body = @{@"access_token":@"5TyL8PmU7cX49YtUI3QwPmTw530vbYnF", @"CID":CID, @"Password":password};
//    NSDictionary *body = @{@"abc":@"123"};
    NSLog(@"%@", body);
    [yyTools POSTWithAFHTTPResponseSerializerByURL:url body:body completion:^(id result) {
        
    } failed:^(id error) {
        
    }];
//{"Token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmb28iOiIzMDkyMDg5MDA0ODYyMTEiLCJpYXQiOjE0ODA1NzQwNzEsImV4cCI6MTQ4MDU3NzY3MX0.xSzEF1NpgQcDFRuM0b6UNozHS_au-hNjW_p3FQsgKEg","LoginSucess":"true"}
}//用户登录   成功

- (void)getChargingScheme{//获取计费方案  成功
    NSString *url = @"https://139.196.149.231/Chargingscheme?access_token=5TyL8PmU7cX49YtUI3QwPmTw530vbYnF&SerialNo=E175MB30008";
    [yyTools GETWithAFJSONResponseSerializerByURL:url completion:^(id result) {
        NSLog(@"**__**   %@", result);
    } failed:^(id error) {
        NSLog(@"222");
    }];
    
//    {
//        A3ColorDuplex = 1;
//        A3ColorSingle = "0.5";
//        A3MonoDuplex = 1;
//        A3MonoSingle = "0.5";
//        A4ColorDuplex = 1;
//        A4ColorSingle = "0.5";
//        A4MonoDuplex = 1;
//        A4MonoSingle = "0.5";
//        Discount = 1;
//        OperatorID = 7;
//        PhotoColorDuplex = 1;
//        PhotoColorSingle = "0.5";
//        PhotoMonoDuplex = 1;
//        PhotoMonoSingle = "0.5";
//    }
}//获取计费方案  成功

- (void)GetSalesNetworkInquiry{//获取该城市打印点列表  成功
    // url = https://139.196.149.231/    access_token = 5TyL8PmU7cX49YtUI3QwPmTw530vbYnF
    
    NSString *url = @"https://139.196.149.231/GetSalesNetworkInquiry?access_token=5TyL8PmU7cX49YtUI3QwPmTw530vbYnF&CityName=上海市";
    [yyTools GETWithAFJSONResponseSerializerByURL:url completion:^(id result) {
        NSLog(@"**__**   %@", result);
    } failed:^(id error) {
        NSLog(@"222");
    }];
    
//    {
//        "SalesNetworkList":[{"SalesNetworkAddress":"重庆市九龙坡区渝高未来大厦(东门)",
//            "PrinterType":"MPC4503SP",
//            "SerialNo":"E175M870063",
//            "Chargingscheme":4,
//            "PaperType":"A3/A4",
//            "ColorType":"彩色/黑白",
//            "PrinterPlace":"1501室",
//            "shophours":"08:30-21:00",
//            "Vendor":"重庆为民办公设备有限公司"}]
//    }
    
//    SalesNetworkList =     (
//                            {
//                                Chargingscheme = 11;
//                                ColorType = "\U5f69\U8272/\U9ed1\U767d";
//                                PaperType = "A3/A4/\U660e\U4fe1\U7247(A5)";
//                                PrinterPlace = "4\U697c\U897f\U533a";
//                                PrinterType = MPC4503SP;
//                                SalesNetworkAddress = "\U4e0a\U6d77\U5e02\U5f90\U6c47\U533a\U6842\U7b90\U8def7\U53f73\U53f7\U697c";
//                                SerialNo = E175MB30008;
//                                Vendor = dj;
//                                shophours = "08:30-21:00";
//                            }
//                            );
    
}//获取该城市打印点列表  成功

//- (void)buttonClicked{
//    NSLog(@"123");
//    IDCardPrintViewController *idcard = [[IDCardPrintViewController alloc] init];
//    UINavigationController *idcardNavi = [[UINavigationController alloc] initWithRootViewController:idcard];
//    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
//    [root presentViewController:idcardNavi animated:YES completion:nil];
//}

//- (void)scan{
//    ScanViewController *scanVC = [[ScanViewController alloc] init];
//    UINavigationController *scanNavi = [[UINavigationController alloc] initWithRootViewController:scanVC];
//    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
//    [root presentViewController:scanNavi animated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
