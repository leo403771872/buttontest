//
//  Tools.m
//  CloudPrint
//
//  Created by yy on 16/9/1.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "Tools.h"

@implementation Tools

// 图片剪切
+ (UIImage*)clipImageWithImage:(UIImage*)image inRect:(CGRect)rect {
  
  CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
  
  UIGraphicsBeginImageContext(image.size);
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextDrawImage(context, rect, imageRef);
  
  UIImage* clipImage = [UIImage imageWithCGImage:imageRef];
  
  UIGraphicsEndImageContext();
  
  return clipImage;
  
}

+ (UIColor *)colorWithRGB:(int)color alpha:(float)alpha{
  return [UIColor colorWithRed:((Byte)(color >> 16))/255.0 green:((Byte)(color >> 8))/255.0 blue:((Byte)color)/255.0 alpha:alpha];
}

//解决裁剪图片方向错误问题
+ (UIImage *)fixOrientation:(UIImage *)aImage {
  
  // No-op if the orientation is already correct
  if (aImage.imageOrientation == UIImageOrientationUp)
    return aImage;
  
  // We need to calculate the proper transformation to make the image upright.
  // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
  CGAffineTransform transform = CGAffineTransformIdentity;
  
  switch (aImage.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
      
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;
    default:
      break;
  }
  
  switch (aImage.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
      
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
    default:
      break;
  }
  
  // Now we draw the underlying CGImage into a new context, applying the transform
  // calculated above.
  CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                           CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                           CGImageGetColorSpace(aImage.CGImage),
                                           CGImageGetBitmapInfo(aImage.CGImage));
  CGContextConcatCTM(ctx, transform);
  switch (aImage.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      // Grr...
      CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
      break;
      
    default:
      CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
      break;
  }
  
  // And now we just create a new UIImage from the drawing context
  CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
  UIImage *img = [UIImage imageWithCGImage:cgimg];
  CGContextRelease(ctx);
  CGImageRelease(cgimg);
  return img;
}

+ (UIImage *)compoundImage1: (UIImage *)image1 Image1Rect: (CGRect)rect1 AndImage2: (UIImage *)image2 Image2Rect: (CGRect)rect2 InBackgrandSize: (CGSize)BGSize{
  
  UIGraphicsBeginImageContext(BGSize);
  
  [image1 drawInRect:rect1];
  
  [image2 drawInRect:rect2];
  
  UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return resultingImage;
}


@end
