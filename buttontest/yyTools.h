//
//  yyTools.h
//  态度旅行
//
//  Created by yy on 15/12/17.
//  Copyright © 2015年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

// Center along axis
#define CENTER_VIEW_H(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW_V(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW(PARENT, VIEW) {CENTER_VIEW_H(PARENT, VIEW); CENTER_VIEW_V(PARENT, VIEW);}

//Color
#define ClearColor [UIColor clearColor]
#define BlackColor [UIColor blackColor]
#define WhiteColor [UIColor whiteColor]
#define GreenColor [UIColor greenColor]
#define RedColor [UIColor redColor]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//Phone
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//Size
#define Width [UIScreen mainScreen].bounds.size.width / 375
#define Height [UIScreen mainScreen].bounds.size.height / 667

#define yyWidth [UIScreen mainScreen].bounds.size.width
#define yyHeight [UIScreen mainScreen].bounds.size.height
#define yyScreen [UIScreen mainScreen].bounds
#define yyCenter CGPointMake(yyWidth / 2.0, yyHeight / 2.0)
#define yyCenterX yyWidth / 2.0
#define yyCenterY yyHeight / 2.0


#define navigationBarHeight self.navigationController.navigationBar.frame.size.height

@interface yyTools : NSObject

/**
 *获取当前时间
 */
+ (NSString *)getCurrentTime;

/**
 *后台向web传cookie 态度旅行专用
 */
+ (void)postForPass;

/**
 *邮箱是否正确
 */
+ (BOOL)isEmail:(NSString *)email;

/**
 *比较两个日期, 返回1前者大, 返回-1后者大, 返回0一样大
 */
+ (int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;
/**
 *改变指定字符串字体颜色
 */
+ (void)ChangeColor:(UIColor *)vaColor FontNumber:(id)font OfStr:(NSString *)string InLabel:(UILabel *)labell;
/**
 *根据Range设置不同字体颜色
 */
+ (void)ColorFontOfLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;
/**
 *判断是否包含非法字符
 */
+ (BOOL)isHaveIllegalChar:(NSString *)str;
/**
 *正则判断手机号码地址格式
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 *根据指定分割符将一个字符串分割成两个字符串
 */
+ (NSArray *)breakUpString:(NSString *)string ByDecollator:(NSString *)decollator;

//根据图片url获取图片尺寸(png, jpg, gif)
+ (CGSize)getImageSizeWithURL:(id)imageURL;

/**
 *已知Label宽度, Center, 行数快速集成Label
 */
+ (UILabel *)fastLabelWithWidth: (float)width Center: (CGPoint)center Font: (UIFont *)font TextColor: (UIColor *)textcolor Text: (NSString *)text NumberOfLines: (NSInteger)number;
//shortLabel快速集成
+ (UILabel *)fastShortLabelWithOriginPoint: (CGPoint)startPoint EndPoint: (CGPoint)endPoint Font: (UIFont *)font TextColor: (UIColor *)textcolor Text: (NSString *)text;
/**
 *已知Label的Center, 快速集成单行文字Label
 */
+ (UILabel *)fastCenterShortLabelWithText: (NSString *)text Center: (CGPoint)center Font: (UIFont *)font TextColor: (UIColor *)textcolor;
/**
 *网络图片ImageView快速集成
 */
+ (UIImageView *)fastImageViewWithSize: (CGSize)size Center: (CGPoint)center ImageNameURL: (NSString *)imageNameURL;
/**
 *本地图片ImageView快速集成
 */
+ (UIImageView *)fastImageViewWithSize: (CGSize)size Center: (CGPoint)center localImageName: (NSString *)localImageName;
/**
 *UIView快速集成
 */
+ (UIView *)fastViewWithSize: (CGSize)size Center: (CGPoint)center BackgrandColor: (UIColor *)color;
//居中Title快速集成
//+ (UILabel *)centerTitleWithCenterY: (float)centerY Font: (UIFont *)font TextColor: (UIColor *)textcolor Text: (NSString *)text NumberOfLines: (NSInteger)number;
/**
 *在子视图中获取父视图的ViewController (带入self就行)
 */
+ (UIViewController *)viewControllerWithSelf: (id)Self;
/**
 *计算文字的长宽
 */
+ (CGSize)sizeOfCellWithText:(NSString *)text AndFont:(UIFont *)font;
/**
 *计算文字的高度
 */
+ (float)heightOfCellWithText:(NSString *)text width:(float)width AndFont:(UIFont *)font;

//#EE1289颜色赋值  [UIColor colorWithRGB:0xEE1289 alpha:1]
+ (UIColor *)colorWithRGB:(int)color alpha:(float)alpha;
/**
 *获取时间戳
 */
+ (nullable NSString *)getTimestamp;

+ (void)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id)delegate cancelButtonTitle:(nullable NSString *)name otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");

#warning 即使收到的是JSON, 也可以先变成二进制再变回JSON (GET POST都是如此, 有待考证)
/**
 *get请求 申明接收二进制
 */
+ (void)GETWithAFHTTPResponseSerializerByURL:(nullable NSString *)urlStr completion:(void(^)(id result))block failed:(void(^)(id error))failBlock;
/**
 *get请求 申明接收JSON
 */
+ (void)GETWithAFJSONResponseSerializerByURL:(NSString *)urlStr completion:(void(^)(id result))block failed:(void(^)(id error))failBlock;
/**
 *post请求 申明接收二进制
 */
+ (void)POSTWithAFHTTPResponseSerializerByURL:(NSString *)urlStr body:(NSDictionary *) parmaters completion:(void(^)(id result))block failed:(void(^)(id error))failBlock;
/**
 *post请求 申明接收JSON
 */
+ (void)POSTWithAFJSONResponseSerializerByURL:(NSString *)urlStr body:(NSDictionary *) parmaters completion:(void(^)(id result))block failed:(void(^)(id error))failBlock;

@end
