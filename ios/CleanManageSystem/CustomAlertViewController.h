//
//  CustomAlertViewController.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/11/25.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <UIKit/UIKit.h>

// ボタン種類
typedef enum TOUCH_BUTTON_TYPE : NSUInteger {
    CANCELL = 0,
    OK = 1
} TOUCH_BUTTON_TYPE;

@protocol CustomAlertViewControllerDelegate;

@interface CustomAlertViewController : UIViewController

@property (nonatomic, weak) id<CustomAlertViewControllerDelegate> delegate;

// メッセージ *必須
@property (nonatomic) NSString* message;
// タイトル
@property (nonatomic) NSString* alertTitle;
// メッセージとタイトルの色 *必須
@property (nonatomic) UIColor* messageColor;

// キャンセルボタンのタイトル
@property (nonatomic) NSString* cancellButtonTitle;
// 確定ボタンのタイトル *必須
@property (nonatomic) NSString* okButtonTitle;
// タグ
@property (nonatomic) NSInteger tag;
// フォント
@property (nonatomic) UIFont *font;

@end


@protocol CustomAlertViewControllerDelegate <NSObject>


// ボタンを押下した際に呼ばれるデリゲートメソッド
@required
-(void) touchAlertViewButton : (TOUCH_BUTTON_TYPE) buttonType tag:(NSInteger)tag ;

// ダイアログを閉じるメソッド
@required
-(void) closeAlertView :(CustomAlertViewController *)controller;

@end
