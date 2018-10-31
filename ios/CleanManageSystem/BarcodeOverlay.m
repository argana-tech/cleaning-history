//
//  BarcodeOverlay.m
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/08/21.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import "BarcodeOverlay.h"
#import "UIColor+Hex.h"
#import "Setting.h"
#import "Constants.h"
#import "ZBarReaderView.h"

@implementation BarcodeOverlay {
    
    BOOL lightOn;
    BOOL adjustingExposure;
    NSTimer *timer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)myView
{
    
    UINib *nib;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        NSLog(@"iPadの処理");
        nib = [UINib nibWithNibName:@"BarcodeOverlay_iPad"bundle:nil];
    }
    else{
        NSLog(@"iPhoneの処理");
        nib = [UINib nibWithNibName:@"BarcodeOverlay"bundle:nil];
    }
    // nib ファイルから読み込む
    NSArray* views = [nib instantiateWithOwner:self options:nil];
    BarcodeOverlay *view = [views objectAtIndex:0];
    view.closeLabel.textColor = [UIColor colorWithHex:@"#7FBFFF"];
    
    return view;
}

- (IBAction)closeButton:(id)sender {
    UIViewController *a  = self.zBarReaderViewController;
    [timer invalidate];
    [a  dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)light:(id)sender {
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (lightOn == NO) {
        // 点灯
        [Setting setScanLight:YES];
        
        [captureDevice lockForConfiguration:NULL];
        captureDevice.torchMode = AVCaptureTorchModeOn;
        [captureDevice unlockForConfiguration];
        lightOn = YES;
        [self.lighImage setImage:[UIImage imageNamed:@"light_on.png"]];
    } else {
        // 消灯
        [Setting setScanLight:NO];
        
        [captureDevice lockForConfiguration:NULL];
        captureDevice.torchMode = AVCaptureTorchModeOff;
        [captureDevice unlockForConfiguration];
        
        lightOn = NO;
        [self.lighImage setImage:[UIImage imageNamed:@"light_off.png"]];
    }
}



- (CGRect)getScanCropRectBasedOnTargetOverlayCropRect:(CGRect)overlayCropRect
                                   forOverlayViewSize:(CGSize)overlaySize{
    
    CGRect scanCropRect = CGRectMake(0, 0, 1, 1); /*default full screen*/
    
    CGFloat x,y,width,height;
    
    // X axis padding can be done from right to left in portrait
    // X axis padding can be done from left to right in landscape
    // Normalizing x between 0 to 1
    x = overlayCropRect.origin.x ;
//    if ((int)x%2==0){
//        x--;
////        x = x/100.0f;
//        
//    }
    
    x = x / overlaySize.width;
    
    // Normalizing y between 0 to 1
    y = ((overlayCropRect.origin.x/2) + overlayCropRect.origin.y)/overlaySize.height ;
    
    // Normalizing width between 0 to 1
    width = overlayCropRect.size.width/overlaySize.width;
    
    // Normalizing height between 0 to 1
    height = overlayCropRect.size.height/overlaySize.height ;
    
    scanCropRect = CGRectMake(y,x,height,width);
    
    return scanCropRect;
}

//-------------

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - タイトルなど初期設定を行っています
-(void) setTitle:(NSString *)title {
    
    
    // スキャン範囲の設定
    self.zBarReaderViewController.wantsFullScreenLayout = NO;
    
    CGSize size;
    if ([Constants isDeviceiPad]) {
        // ipadはライトがないのでライトを削除
        [self.lightButton removeFromSuperview];
        self.lightButton = Nil;
        [self.lighImage removeFromSuperview];
        self.lighImage = nil;
        size = [[UIScreen mainScreen] bounds].size;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.numberOfLines = 1;
    } else {
        self.zBarReaderViewController.readerView.torchMode = [Setting isScanLight];
        lightOn = [Setting isScanLight];
        // ライト点灯判断
        if (lightOn) {
            [self.lighImage setImage:[UIImage imageNamed:@"light_on.png"]];
        } else {
            [self.lighImage setImage:[UIImage imageNamed:@"light_off.png"]];
        }
        size = self.frame.size;
        
        
    }
    self.zBarReaderViewController.scanCrop = [self getScanCropRectBasedOnTargetOverlayCropRect:self.scanCrop.frame forOverlayViewSize:size];

    
    
    // ラベル
    [[self.backLabel layer] setCornerRadius:5.0];
    [self.backLabel setClipsToBounds:YES];
    
    [[self.lineLabel layer] setCornerRadius:2.3];
    [[self.lineLabel layer] setBorderColor:[UIColor redColor].CGColor];
    [[self.lineLabel layer] setBorderWidth:5];
    
    // メッセージ
    NSString *message =  [NSString stringWithFormat:@"%@のバーコードをスキャンしてください。", title];
    self.descriptionLabel.text = message;
    
    self.titleLabel.text = title;
    
    CALayer *label = [self.toolbarLabel layer];
    
    label.borderColor = [UIColor grayColor].CGColor;
    label.borderWidth = 0.5;
}

#pragma mark - タイマーセット
-(void) setFocusTimer {
    // タイマーを生成 1秒毎中心にフォーカスを当て続ける
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(setFocus)
                                           userInfo:nil
                                            repeats:YES
             ];
}

#pragma mark - フォーカスを中心に当てる
- (void) setFocus {
    
    CGPoint point = CGPointMake(0.5, 0.5);
    NSValue *val = [NSValue valueWithCGPoint:point];
    [self performSelector:@selector(setFocus:) withObject:val afterDelay:0];
    
    
}

#pragma mark - フォーカスタイマーを止める
- (void) stopFocusTimer {
    [timer invalidate];
}


#pragma mark - フォーカスを当てる
- (void) setFocus : (NSValue*) value {
    
    CGPoint pointOfInterest = [value CGPointValue];
    AVCaptureDevice *videoCaptureDevice = self.zBarReaderViewController.readerView.device;
    
    // フォーカス
    if ([videoCaptureDevice isFocusPointOfInterestSupported] &&
        [videoCaptureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        [videoCaptureDevice lockForConfiguration:&error];
        if (error) {
            LOG(@"scannerError:%@", error);
        }
        
        videoCaptureDevice.focusPointOfInterest = pointOfInterest;
        videoCaptureDevice.focusMode = AVCaptureFocusModeAutoFocus;
    }
    
    // 露出
    if ([videoCaptureDevice isExposurePointOfInterestSupported] &&
        [videoCaptureDevice isExposureModeSupported: AVCaptureExposureModeContinuousAutoExposure]){
        adjustingExposure = YES;
        videoCaptureDevice.exposurePointOfInterest = pointOfInterest;
        videoCaptureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (!adjustingExposure) {
        return;
    }
    
    if ([keyPath isEqual:@"adjustingExposure"]) {
        if ([[change objectForKey:NSKeyValueChangeNewKey] boolValue] == NO) {
            adjustingExposure = NO;
            AVCaptureDevice* videoCaptureDevice = self.zBarReaderViewController.readerView.device;
            
            NSError *error = nil;
            if ([videoCaptureDevice lockForConfiguration:&error]) {
                [videoCaptureDevice setExposureMode:AVCaptureExposureModeLocked];
                [videoCaptureDevice unlockForConfiguration];
            }
        }
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
