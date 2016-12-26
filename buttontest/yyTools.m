//
//  yyTools.m
//  态度旅行
//
//  Created by yy on 15/12/17.
//  Copyright © 2015年 yy. All rights reserved.
//

#import "yyTools.h"
#import "yyMD5.h"


@implementation yyTools

+ (NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

//传token  (后台向web传cookie)态度旅行专用
+ (void)postForPass{
    
    NSString *tempID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"IUserID"];
    //时间戳
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    NSLog(@"timeString   %@", timeString);
    
    NSString *tempS = [NSString stringWithFormat:@"%@%@taidutrip", tempID, timeString];
    NSLog(@"tempS    %@", tempS);
    
    NSString *token = tempS;
    for (int i = 1; i <= 5; i++) {
        token = [yyMD5 md5:token];
    }
    
    NSDictionary *parameter = @{@"IUserID":tempID, @"token":token};
    
}


//邮箱
+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = oneDay;
    NSString *anotherDayStr = anotherDay;
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
//    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

//设置不同字体颜色
+ (void)ColorFontOfLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
}

+ (void)ChangeColor:(UIColor *)vaColor FontNumber:(id)font OfStr:(NSString *)string InLabel:(UILabel *)labell
{
    NSRange range = [labell.text rangeOfString:string];
    
    if (range.location > 100000) {//没有这个字符串
        return;
    }
    
//    NSString *string1 = [string substringToIndex:(range.location)];
//    NSString *string2 = [string substringFromIndex:(range.location + 1)];
    [self ColorFontOfLabel:labell FontNumber:font AndRange:range AndColor:vaColor];
}

//判断是否包含非法字符
+ (BOOL)isHaveIllegalChar:(NSString *)str{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+?!@`:;'\" "];
    NSRange range = [str rangeOfCharacterFromSet:doNotWant];
    return range.location<str.length;
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1[34578]\\d{9}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSArray *)breakUpString:(NSString *)string ByDecollator:(NSString *)decollator{
    
    NSRange tempRange = [string rangeOfString:decollator];
//    NSLog(@"```%lu       %lu", (unsigned long)tempRange.length, (unsigned long)tempRange.location);
    
    if (tempRange.location > 100000) {//没有这个字符串
        NSArray *arr;
        return arr;
    }
    
    NSRange range = [string rangeOfString:decollator];
    
    NSString *string1 = [string substringToIndex:(range.location)];
    NSString *string2 = [string substringFromIndex:(range.location + 1)];
    
    NSArray *array = @[string1, string2];
    return array;
}

// 根据图片url获取图片尺寸
+ (CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];

        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

+ (UILabel *)fastCenterShortLabelWithText: (NSString *)text Center: (CGPoint)center Font: (UIFont *)font TextColor: (UIColor *)textcolor{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    label.center = center;
    label.font = font;
    label.textColor = textcolor;
    label.text = text;
    return label;
}

+ (UILabel *)fastLabelWithWidth: (float)width Center: (CGPoint)center Font: (UIFont *)font TextColor: (UIColor *)textcolor Text: (NSString *)text NumberOfLines: (NSInteger)number {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, rect.size.height)];
    label.center = center;
    label.font = font;
    label.textColor = textcolor;
    label.text = text;
    label.numberOfLines = number;
    return label;
}

//iOS 8.的系统这个方法会崩溃, 原因未知
+ (UILabel *)fastShortLabelWithOriginPoint: (CGPoint)startPoint EndPoint: (CGPoint)endPoint Font: (UIFont *)font TextColor: (UIColor *)textcolor Text: (NSString *)text{
    CGRect rect;
    if (CGPointEqualToPoint(CGPointZero, endPoint)) {
        NSLog(@"*%@*%@%@", font, textcolor, text);
        rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    } else {
        rect = [text boundingRectWithSize:CGSizeMake(endPoint.x - startPoint.x, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    }
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, rect.size.width, rect.size.height + 1)];
//    if ((rect.size.width + point.x) > [UIScreen mainScreen].bounds.size.width) {//超出屏幕了
//        label.frame = CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width - point.x - 20 * [UIScreen mainScreen].bounds.size.height / 667, rect.size.height);
//    }
    label.font = font;
    label.textColor = textcolor;
    label.text = text;
    return label;
}

+ (UIImageView *)fastImageViewWithSize: (CGSize)size Center: (CGPoint)center ImageNameURL: (NSString *)imageNameURL{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.center = center;
    
    if (imageNameURL == nil || [imageNameURL isEqualToString:@""]) {
        return imageView;
    }
    return imageView;
    
}

+ (UIImageView *)fastImageViewWithSize: (CGSize)size Center: (CGPoint)center localImageName: (NSString *)localImageName{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.center = center;
    imageView.image = [UIImage imageNamed:localImageName];
    return imageView;
}

+ (UIView *)fastViewWithSize: (CGSize)size Center: (CGPoint)center BackgrandColor: (UIColor *)color{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.center = center;
    view.backgroundColor = color;
    return view;
}

//如何在子视图中获取父视图的ViewController
+ (UIViewController *)viewControllerWithSelf: (id)Self{
    for (UIView *next = [Self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

/* 返回文字的size */
+ (CGSize)sizeOfCellWithText:(NSString *)text AndFont:(UIFont *)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];

    return rect.size;
}

/* 返回文字的height */
+ (float)heightOfCellWithText:(NSString *)text width:(float)width AndFont:(UIFont *)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height;
}

+ (UIColor *)colorWithRGB:(int)color alpha:(float)alpha{
    return [UIColor colorWithRed:((Byte)(color >> 16))/255.0 green:((Byte)(color >> 8))/255.0 blue:((Byte)color)/255.0 alpha:alpha];
}

//获取时间戳
+ (NSString *)getTimestamp {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
//    NSLog(@"timeString   %@", timeString);

    return timeString;
}

+ (void)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id)delegate cancelButtonTitle:(nullable NSString *)name otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead."){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:name otherButtonTitles:otherButtonTitles, nil];
    [alert show];
}

/* get请求 申明接收二进制 */
+ (void)GETWithAFHTTPResponseSerializerByURL:(NSString *)urlStr completion:(void(^)(id result))block failed:(void(^)(id error))failBlock{
    
    //转码 避免有汉字
    NSString *str = [urlStr stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding];
    NSLog(@"URL       %@", str);
    //创建请求管理类
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置响应解析对象 二进制
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //忽略证书
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    session.securityPolicy.allowInvalidCertificates = YES;
    [session.securityPolicy setValidatesDomainName:NO];
    
    //支持类型
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil];
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            //此处用于修改后台bug
            NSLog(@"**__**   %@", responseObject);
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"*****%@", aString);
            
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            block(result);
        } else {
            NSLog(@"data is empty");
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"request fail error : %@", error);
        failBlock(error);
    }];
    
}

/* get请求 申明接收JSON */
+ (void)GETWithAFJSONResponseSerializerByURL:(NSString *)urlStr completion:(void(^)(id result))block failed:(void(^)(id error))failBlock{
    //转码 避免有汉字
    NSString *str = [urlStr stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding];
//    NSString *str = urlStr;
    //创建请求管理类
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置响应解析对象 JSON
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //忽略证书
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    session.securityPolicy.allowInvalidCertificates = YES;
    [session.securityPolicy setValidatesDomainName:NO];
    
    //支持类型
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil];
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            //此处用于修改后台bug
//            NSLog(@"**__**   %@", responseObject);
//            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"*****%@", aString);
            
            block(responseObject);
        } else {
            NSLog(@"data is empty");
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"request fail error : %@", error);
        failBlock(error);
    }];

}

/* post请求 申明接收二进制 */
+ (void)POSTWithAFHTTPResponseSerializerByURL:(NSString *)urlStr body:(id) parmaters completion:(void(^)(id result))block failed:(void(^)(id error))failBlock{
    //转码 避免有汉字
    NSString *str = [urlStr stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding];
    //创建请求管理类
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //忽略证书
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    session.securityPolicy.allowInvalidCertificates = YES;
    [session.securityPolicy setValidatesDomainName:NO];
    //设置响应解析对象 二进制
//    [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [session.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //支持类型
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [session POST:str parameters:parmaters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //此处用于修改后台bug
        NSLog(@"**__**   %@", responseObject);
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"*****%@", aString);
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                block(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error  %@", error);
        failBlock(error);
    }];
    
    
//    [session POST:str parameters:parmaters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //此处用于修改后台bug
////        NSLog(@"**__**   %@", responseObject);
////        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
////        NSLog(@"*****%@", aString);
////        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
////        block(result);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////        NSDictionary *dic = [task.response.URL];
//        NSLog(@"error  %@", error);
////        NSLog(@"---- --- %@", task.response.internal);
//        
//        failBlock(error);
//    }];
    
}

/* post请求 申明接收JSON */
+ (void)POSTWithAFJSONResponseSerializerByURL:(NSString *)urlStr body:(NSDictionary *) parmaters completion:(void(^)(id result))block failed:(void(^)(id error))failBlock{
    //转码 避免有汉字
    NSString *str = [urlStr stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding];
    //创建请求管理类
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置响应解析对象 二进制
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    //支持类型
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [session POST:str parameters:parmaters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //此处用于修改后台bug
        NSLog(@"**__**   %@", responseObject);
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error  %@", error);
        failBlock(error);
    }];

}

@end
