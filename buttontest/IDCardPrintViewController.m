//
//  IDCardPrintViewController.m
//  CloudPrint
//
//  Created by yy on 16/9/1.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "IDCardPrintViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "Tools.h"

@interface IDCardPrintViewController ()
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
@property (strong, nonatomic) UIView *backView;
//@property (strong, nonatomic) UIImageView *thumbnailImage;//缩略图(测试用)

@property (nonatomic, assign) NSInteger PicNum;//照相机点击次数
@property (nonatomic, strong) UIButton *takePhotoButton;

@property (nonatomic, strong) UIImage *finalImage;

#define CLIPRECT CGRectMake(80, 555, 940, 650)
#define BGSIZE CGSizeMake(1654, 2339)
#define WHITEBGRECT CGRectMake(0, 0, 1654, 2339)
#define FRONTIDCARDRECT CGRectMake(500, 300, 675, 430)
#define BACKIDCARDRECT CGRectMake(500, 1460, 675, 430)

@end

@implementation IDCardPrintViewController

- (void)viewWillAppear:(BOOL)animated{
  
  [super viewWillAppear:YES];
  
  if (self.session) {
    
    [self.session startRunning];
  }
}

- (void)viewDidDisappear:(BOOL)animated{
  
  [super viewDidDisappear:YES];
  
  if (self.session) {
    
    [self.session stopRunning];
  }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//  self.view.backgroundColor = [UIColor blueColor];
  [self initAVCaptureSession];
  [self navigationBarSet];
  [self initTakePhotoButton];
//  [self initCancelButton];
  
}

- (void)initCancelButton{
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelButton.frame = CGRectMake(0, 0, 50, 50);
  cancelButton.backgroundColor = [UIColor greenColor];
  cancelButton.center = CGPointMake(yyWidth / 2.0 - 100, 500);
  [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:cancelButton];
  
//  _thumbnailImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//  _thumbnailImage.center = CGPointMake(yyWidth / 2.0 + 100, 500);
//  _thumbnailImage.backgroundColor = [UIColor purpleColor];
//  [self.view addSubview:_thumbnailImage];
  
}

- (void)cancelButtonClicked{
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

- (void)navigationBarSet{//添加title时动画效果会消失
//  self.navigationController.navigationItem.title = @"身份证拍摄";
  self.title = @"身份证拍摄";
  
  _finalImage = [[UIImage alloc] init];
}

- (void)initTakePhotoButton{
  _takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _takePhotoButton.frame = CGRectMake(0, 0, 120, 120);
//  _takePhotoButton.backgroundColor = [UIColor redColor];
  _takePhotoButton.center = CGPointMake(yyWidth / 2.0, 64 + 560);
  [_takePhotoButton setImage:[UIImage imageNamed:@"IDCardFront"] forState:UIControlStateNormal];
  [_takePhotoButton addTarget:self action:@selector(takePhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_takePhotoButton];
}

- (void)initAVCaptureSession{
  
  self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, yyWidth, yyHeight)];
  [self.view addSubview:_backView];
  _backView.backgroundColor = [UIColor blackColor];
  
  
  self.session = [[AVCaptureSession alloc] init];
  
  NSError *error;
  
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  
  //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
  [device lockForConfiguration:nil];
  //设置闪光灯为自动
  [device setFlashMode:AVCaptureFlashModeAuto];
  [device unlockForConfiguration];
  
  self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
  if (error) {
    NSLog(@"%@",error);
  }
  self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
  //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
  NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
  [self.stillImageOutput setOutputSettings:outputSettings];
  
  if ([self.session canAddInput:self.videoInput]) {
    [self.session addInput:self.videoInput];
  }
  if ([self.session canAddOutput:self.stillImageOutput]) {
    [self.session addOutput:self.stillImageOutput];
  }
  
  //初始化预览图层
  self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
  //AVLayerVideoGravityResizeAspectFill
  //AVLayerVideoGravityResizeAspect
  //AVLayerVideoGravityResize
  [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
  self.previewLayer.frame = CGRectMake(0, 64 + 27 * Height, yyWidth, 461 * Height);
  self.backView.layer.masksToBounds = YES;
  [self.backView.layer addSublayer:self.previewLayer];
  
  [self limitViewSet];
  
//  ALIGN_VIEW_CONSTANT(self.view, bgView, 64.0f, 64.0f, -64.0f, -64.0f);
  
}

//限制框设置
- (void)limitViewSet{
  UIView *limitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360 * Width, 244 * Width)];
  limitView.backgroundColor = [UIColor clearColor];
  limitView.center = CGPointMake(yyCenterX, 64 + 461 * Height / 2);
  limitView.layer.borderWidth = 1;
  limitView.layer.borderColor = [Tools colorWithRGB:0xffff00 alpha:1].CGColor;
  [self.view addSubview:limitView];
}

//点击照相按钮
- (void)takePhotoButtonClick{

  NSLog(@"takephotoClick...");
  _PicNum++;
  
  AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
  
  //解析图片并存储
  [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
    
    NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
    
    UIImage *tempImage =[UIImage imageWithData:jpegData];
    //先转方向再截取是对的
    UIImage *tempImage2 = [Tools fixOrientation:tempImage];
    //截取
    UIImage *tempImage3 = [Tools clipImageWithImage:tempImage2 inRect:
                           CLIPRECT];
    //拼接
    [self compoundWithOrder:_PicNum AndImage:tempImage3];
    
    
    //保存到手机里?
//    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
//                                                                imageDataSampleBuffer,
//                                                                kCMAttachmentMode_ShouldPropagate);
//    
//    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
//      //无权限
//      return ;
//    }
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
//      
//    }];
    
  }];
  
  
  if (_PicNum >= 2) {
//    self.callback(@[@{@"type" : @"success", @"content" : @"test"}]);
//    [self cancelButtonClicked];
    return;
  } else if (_PicNum == 1) {
    [_takePhotoButton setImage:[UIImage imageNamed:@"IDCardBack"] forState:UIControlStateNormal];
  }
  
}

//合成
- (void)compoundWithOrder:(NSInteger)order AndImage:(UIImage *)image{
  
  if (order == 1) {//正面拼接
    UIImage *whiteBG = [UIImage imageNamed:@"whiteImage.jpg"];
    UIImage *tempImage = [Tools compoundImage1:whiteBG Image1Rect:WHITEBGRECT AndImage2:image Image2Rect:FRONTIDCARDRECT InBackgrandSize:BGSIZE];
    
//    [_thumbnailImage setImage:tempImage];
    
    _finalImage = tempImage;
    
  } else if (order == 2) {//反面拼接
    
    UIImage *tempImage = [Tools compoundImage1:_finalImage Image1Rect:WHITEBGRECT AndImage2:image Image2Rect:BACKIDCARDRECT InBackgrandSize:BGSIZE];
    
    _finalImage = tempImage;
    
//    testViewController *test = [[testViewController alloc] init];
//    test.testImage = tempImage;
//    [self.navigationController pushViewController:test animated:YES];
    
    [self saveToPhoneWithImage:tempImage];
    
  }
  
}
//把图片存入手机
- (void)saveToPhoneWithImage:(UIImage *)image{
  NSArray  * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  NSString * filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%.f", [[NSDate date]timeIntervalSince1970]]];   // 保存文件的名称
//  [UIImagePNGRepresentation(image)writeToFile: filePath atomically:YES];
  NSString *aimFilePath = [NSString stringWithFormat:@"%@.jpg", filePath];
  
  // 保存图片到指定的路径
  NSData *data = UIImagePNGRepresentation(image);
  [data writeToFile:aimFilePath atomically:YES];
  
  [self cancelButtonClicked];
  
  //存到相册
  UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
  NSString *message = @"呵呵";
  if (!error) {
    message = @"成功保存到相册";
  }else
  {
    message = [error description];
  }
  NSLog(@"message is %@",message);
  NSLog(@"%@", contextInfo);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
