//
//  MainAppDelegate.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/08/12.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "MainAppDelegate.h"
#import "VersionCheck.h"
#import "UpdateViewController.h"
#import "Config.h"
#import "VersionCheckWindow.h"
#import "Reachability.h"
#import "SVProgressHUD.h"

@implementation MainAppDelegate {
    
    // 更新画面表示フラグ
    BOOL isDispUpdateView;
    // アラート画面表示フラグ
    BOOL isDispAlertView;
    
    BOOL isCheckError;
}
@synthesize sbName;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    // 背景をテーブルと同じ色にする
    UIWindow* mainWindow = (((MainAppDelegate*) [UIApplication sharedApplication].delegate).window);
    mainWindow.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1];
    
    // iPhone, iPad
//    [self storyboardSetting];
    
    
    
    return YES;
}

//- (void) storyboardSetting {
//    
//    UIStoryboard *storyboard;
//    // StoryBoardの名称設定用
//    NSString * storyBoardName;
//    
//    // 機種の取得
//    NSString *modelname = [[UIDevice currentDevice] model];
//    
//    // iPadかどうか判断する
//    if ( ![modelname hasPrefix:@"iPad"] ) {
//        
//        // Windowスクリーンのサイズを取得
//        CGRect r = [[UIScreen mainScreen] bounds];
//        // 縦の長さが480の場合、古いiPhoneだと判定
//        if(r.size.height == 480)
//        {
//            storyBoardName = @"Main_iPhone";
//        }
//        else
//        {
//            storyBoardName = @"Main_iPhone";
//        }
//    }
//    else
//    {
//        storyBoardName = @"Main_iPad";
//    }
//    
//    sbName = storyBoardName;
//    
//    // StoryBoardのインスタンス化
//    storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
//    
//    // 画面の生成
//    UIViewController *mainViewController = [storyboard instantiateInitialViewController];
//    
//    // ルートウィンドウにひっつける
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = mainViewController;
//    [self.window makeKeyAndVisible];
//
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [self versionCheck];
    
    
}

- (void) versionCheck {
    
    
    if (isDispAlertView == NO) {
        // アラート表示画面が表示されていない
        
        Reachability *curReach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        LOG(@"ネットワーク状況:%d:",netStatus);
        if (netStatus == NotReachable) {
            // ネットワーク接続なし
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle:@"ネットワーク接続エラー"
                                  message:@"ネットワークへの接続ができませんでした。\nネットワーク接続を確認してから\n「確認」を押してください。"
                                  delegate:self cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
            [alert show];
            
            // アラートを表示
            isDispAlertView = YES;
            isCheckError = YES;
            
        } else {
            // ネットワーク接続あり
            
            // バージョンチェック機能確認
            if (IS_VERSION_CHECK) {
                // バージョンチェックを行う
                
                if (isDispUpdateView == NO) {
                    // バージョンチェック
                    if (isCheckError) {
                        [self performSelector:@selector(dispProgress) withObject:nil];
                    }
                    
                    NSError *updateError = nil;
                    if ( [VersionCheck isUpdateVersion:&updateError]) {
                        // 最新でない or エラー 更新画面へ遷移
                        if (updateError) {
                            [SVProgressHUD showErrorWithStatus:@"バージョンチェックエラー"];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"最新のバージョンではありません"];
                        }
                        
                        // 最新のバージョンがあるので更新画面へ遷移させる
                        UpdateViewController* updateView = [UpdateViewController new];
                        UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:updateView];
                        [navigationController setNavigationBarHidden:NO animated:NO];
                        [navigationController setToolbarHidden:YES animated:NO];
                        updateView.updateError = updateError;
                        
                        
                        self.window = [[VersionCheckWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                        self.window.rootViewController = navigationController;
                        [self.window addSubview:updateView.view];
                        [self.window makeKeyAndVisible];
                        
                        // 更新画面を表示
                        isDispUpdateView = YES;
                        isCheckError = NO;
                    } else {
                        // 最新
                        if (isCheckError) {
                            [SVProgressHUD showSuccessWithStatus:@"最新のバージョンです"];
                        } else {
                            [SVProgressHUD dismiss];
                        }
                        
                        isCheckError = NO;
                    }
                }
            }
        }
    }
}
# pragma mark - alertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    isDispAlertView = NO;
    [self versionCheck];
    
}

- (void) dispProgress {
    [SVProgressHUD showWithStatus:@"バージョンチェック中" maskType:SVProgressHUDMaskTypeGradient];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}



@end
