//
//  CustomAlertViewController.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/11/25.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "CustomAlertViewController.h"
#import "NSString+Replace.h"


@interface CustomAlertViewController ()



@end

@implementation CustomAlertViewController {
    
    
    UILabel* alertView;
    UIButton* okButton;
    UIButton* cancellButton;
    
    UIButton* dummyOkButton;
    UIButton* dummyCancellButton;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // アラートの幅
    float alertWidth = 270;
    // アラートのx
    float x = (320 - alertWidth ) / 2;
    
    // タイトル
    float labelX = 7;
    float labelWidth = alertWidth - (labelX * 2);
    UILabel* alertTitle = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 10, labelWidth, 24)];
    alertTitle.text = self.alertTitle;
    alertTitle.textAlignment = NSTextAlignmentCenter;
    CGFloat fontSize = self.font.pointSize + 2;
    alertTitle.font = [UIFont boldSystemFontOfSize:fontSize];
    alertTitle.textColor = self.messageColor;

    // メッセージ
    float messegeY = 20;
    if ( 0 < [self.alertTitle length]) {
        messegeY = alertTitle.frame.origin.y + alertTitle.frame.size.height + 5;
    }
    UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, messegeY, labelWidth, 10)];
    NSString *message = [NSString replaceBr:self.message];
    messageLabel.text = message;
    messageLabel.numberOfLines = 0;
    
    messageLabel.font = self.font?self.font:[UIFont systemFontOfSize:15];
    [messageLabel sizeToFit];
    CGRect tmp = messageLabel.frame;
    tmp.size.width = labelWidth;
    messageLabel.frame = tmp;
    
    messageLabel.textColor = self.messageColor;
   
    
    // アラート
    float height = messageLabel.frame.size.height;
    height += 100;
    alertView = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, alertWidth, height)];
    alertView.center = self.view.center;
    alertView.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1];
    CALayer* layer = [alertView layer];
    [layer setCornerRadius:7];
    [layer setMasksToBounds:YES];
    alertView.alpha = 0.1;
    
    
    // addSubViewタイトルの追加
    if ( 0 < [self.alertTitle length]) {
        [alertView addSubview:alertTitle];
    }
    [alertView addSubview:messageLabel];
    [self.view addSubview:alertView];
    
    // ボタンの上の横線
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, (height - 45), alertWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [alertView addSubview:line];
    
    
    // ボタン
    int buttonCount = 0;
    float buttonY = alertView.frame.origin.y + alertView.frame.size.height - 45;
    float buttonX = alertView.frame.origin.x;
    if (0 < [self.cancellButtonTitle length]) {
        // キャンセル
        buttonCount++;
        cancellButton = [UIButton buttonWithType:UIButtonTypeSystem];//self.cancellButton;
        [cancellButton setTitle:self.cancellButtonTitle forState:UIControlStateNormal];
        [cancellButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [cancellButton addTarget:self action:@selector(touchCancell:) forControlEvents:UIControlEventTouchUpInside];
        cancellButton.frame = CGRectMake(buttonX, buttonY, alertWidth / 2, 45);
        cancellButton.hidden = YES;
        [self.view addSubview:cancellButton];
        
        dummyCancellButton = [UIButton buttonWithType:UIButtonTypeSystem];//self.cancellButton;
        [dummyCancellButton setTitle:self.cancellButtonTitle forState:UIControlStateNormal];
        [dummyCancellButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        dummyCancellButton.frame = CGRectMake(0, alertView.frame.size.height - 45, alertWidth / 2, 45);
        [alertView addSubview:dummyCancellButton];
        
    }
    
    if (0 < [self.okButtonTitle length]) {
        // OK
        buttonCount++;
        // okbutton
        okButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [okButton setTitle:self.okButtonTitle forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(touchOk:) forControlEvents:UIControlEventTouchUpInside];
        [okButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        
        // dummy
        dummyOkButton = [UIButton buttonWithType:UIButtonTypeSystem];//self.cancellButton;
        [dummyOkButton setTitle:self.okButtonTitle forState:UIControlStateNormal];
        [dummyOkButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        
        if (1 < buttonCount) {
            // キャンセルあり
            okButton.frame = CGRectMake(buttonX + alertWidth / 2, buttonY, alertWidth / 2, 45);
            dummyOkButton.frame = CGRectMake(alertWidth / 2, alertView.frame.size.height - 45, alertWidth / 2, 45);
            // ボタンのしきり縦線
            UILabel* line_v = [[UILabel alloc] initWithFrame:CGRectMake(alertWidth / 2, (height - 45), 0.5, 45)];
            line_v.backgroundColor = [UIColor lightGrayColor];
            [alertView addSubview:line_v];
            
        } else {
            okButton.frame = CGRectMake(buttonX, buttonY, alertWidth, 45);
            dummyOkButton.frame = CGRectMake(0, alertView.frame.size.height - 45, alertWidth, 45);
        }
        
        okButton.hidden = YES;
        [alertView addSubview:dummyOkButton];
        [self.view addSubview:okButton];
    }
    
    

    
    
    /* 拡大・縮小 */
    // 拡大縮小を設定
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // アニメーションのオプションを設定
    animation.duration = 0.2; // アニメーション速度
    animation.repeatCount = 1; // 繰り返し回数
    animation.autoreverses = NO; // アニメーション終了時に逆アニメーション
    
    // 拡大・縮小倍率を設定
    animation.fromValue = [NSNumber numberWithFloat:1.2]; // 開始時の倍率
    animation.toValue = [NSNumber numberWithFloat:1.0]; // 終了時の倍率
    
    // アニメーションを追加
    [alertView.layer addAnimation:animation forKey:@"scale-layer"];
    
    
    [UIView animateWithDuration:0.2
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn| // EaseInカーブ
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         alertView.alpha = 1;
                         
                     }
                     completion:^(BOOL finished) {
                         cancellButton.hidden = NO;
                         okButton.hidden = NO;
                         
                         dummyCancellButton.hidden = YES;
                         dummyOkButton.hidden = YES;
                     }];
}

#pragma mark - キャンセルボタン
-(void) touchCancell : (UIButton*) button {
    [self closeAnime];
    [self.delegate touchAlertViewButton:CANCELL tag:self.tag];
    [self.delegate closeAlertView:self];
}

#pragma mark - okボタン
-(void) touchOk :(UIButton*) button {
    [self closeAnime];
    [self.delegate touchAlertViewButton:OK tag:self.tag];
    [self.delegate closeAlertView:self];
}

#pragma mark - 閉じるアニメーション
-(void) closeAnime {
    
    cancellButton.hidden = YES;
    okButton.hidden = YES;
    
    dummyCancellButton.hidden = NO;
    dummyOkButton.hidden = NO;
    
    
    // 拡大縮小を設定
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // アニメーションのオプションを設定
    animation.duration = 0.2; // アニメーション速度
    animation.repeatCount = 1; // 繰り返し回数
    animation.autoreverses = NO; // アニメーション終了時に逆アニメーション
    
    // 拡大・縮小倍率を設定
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 開始時の倍率
    animation.toValue = [NSNumber numberWithFloat:0.5]; // 終了時の倍率
    
    
    // アニメーションを追加
    [alertView.layer addAnimation:animation forKey:@"scale-layer"];
    
    [UIView animateWithDuration:0.2
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn| // EaseInカーブ
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         alertView.alpha = 0.5;
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
