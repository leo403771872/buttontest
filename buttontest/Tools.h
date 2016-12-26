//
//  Tools.h
//  CloudPrint
//
//  Created by yy on 16/9/1.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


//Size
#define Width [UIScreen mainScreen].bounds.size.width / 414
#define Height [UIScreen mainScreen].bounds.size.height / 736

#define yyWidth [UIScreen mainScreen].bounds.size.width
#define yyHeight [UIScreen mainScreen].bounds.size.height
#define yyScreen [UIScreen mainScreen].bounds
#define yyCenter CGPointMake(yyWidth / 2.0, yyHeight / 2.0)
#define yyCenterX yyWidth / 2.0
#define yyCenterY yyHeight / 2.0

#define ALIGN_VIEW_LEFT_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeLeft multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_RIGHT_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeRight multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_TOP_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeTop multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_BOTTOM_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeBottom multiplier:1.0f constant:CONSTANT]]
//test
#define ALIGN_VIEW_CONSTANT(PARENT, VIEW, TOP, LEFT, BOTTOM, RIGHT) {ALIGN_VIEW_TOP_CONSTANT(PARENT, VIEW, TOP); ALIGN_VIEW_LEFT_CONSTANT(PARENT, VIEW, LEFT);ALIGN_VIEW_BOTTOM_CONSTANT(PARENT, VIEW, BOTTOM);ALIGN_VIEW_RIGHT_CONSTANT(PARENT, VIEW, RIGHT);}

/**
 *图片截取
 */
+ (UIImage*)clipImageWithImage:(UIImage*)image inRect:(CGRect)rect;

/**
 *颜色赋值
 */
+ (UIColor *)colorWithRGB:(int)color alpha:(float)alpha;

/**
 *处理图片方向问题
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 *图片合成
 */
+ (UIImage *)compoundImage1: (UIImage *)image1 Image1Rect: (CGRect)rect1 AndImage2: (UIImage *)image2 Image2Rect: (CGRect)rect2 InBackgrandSize: (CGSize)BGSize;

@end
