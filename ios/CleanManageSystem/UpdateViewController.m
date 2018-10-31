//
//  UpdateViewController.m
//  CleanManageSystem
//
//  Created by akifumin on 2014/01/10.
//  Copyright (c) 2014年 akifumin. All rights reserved.
//

#import "UpdateViewController.h"
#import "UIColor+Hex.h"

@interface UpdateViewController ()

@property (weak, nonatomic) IBOutlet UITableView *updateTable;

@end

@implementation UpdateViewController

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
	// Do any additional setup after loading the view.
    
    //    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"アップデート" message:@"アプリのバージョン" delegate:self cancelButtonTitle:Nil otherButtonTitles:@"はい", nil];
    //    [alert show];
    
    //    UIImage* image = [UIImage imageNamed:@"Default-568h"];
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    //    imageView.frame = self.view.frame;
    //    [self.view addSubview:imageView];
    
    //    self.navigationItem.title = @"更新の確認";
    //
    //    UILabel*  label = [[UILabel alloc] init];
    //    label.frame = self.view.frame;
    //    CGRectMake(10, 0, 300, 10);
    //    label.text = @"本アプリを最新の状態にしてください。\n「更新」タップするとブラウザが起動しますのでそちらで、本アプリをタップしてください。\n自動的にアプリが最新の状態になります";
    //    label.numberOfLines = 0;
    //    [label sizeToFit];
    //    label.center = self.view.center;
    //
    //    [self.view addSubview:label];
    
    NSString* displayName =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    if (self.updateError) {
        // エラー
        self.navigationItem.title  = [NSString stringWithFormat:@"「%@」アプリのエラー", displayName];
    } else {
        // 正常
        self.navigationItem.title  = [NSString stringWithFormat:@"「%@」アプリの更新", displayName];
    }
    _updateTable.dataSource = self;
    _updateTable.delegate = self;
    
}



#pragma mark - セクション数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

#pragma mark - 行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* header;
    if (self.updateError) {
        // error
        header = [NSString stringWithFormat:@"%@",  @"サーバーから最新のアプリバージョン情報を取得できませんでした。\n\n「終了」をタップし一度アプリを終了させてからアプリを再度起動してください。"];
    } else {
        // 正常
        header = [NSString stringWithFormat:@"アプリが最新のバージョンではありません。\n\n「更新」をタップしてアプリを最新の状態にしてください。"];
    }
    return header;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    NSString* version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = [NSString stringWithFormat:@"ver.%@", version];
    return label;
    
    
}

#pragma mark - フッター高さ
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}





#pragma mark - 行作成
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%d_%d", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == NULL) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if (self.updateError) {
            cell.textLabel.text = @"終了";
            cell.textLabel.textColor = [UIColor redColor];
        } else {
            cell.textLabel.text = @"更新";
            cell.textLabel.textColor = [UIColor colorWithHex:@"#7fbfff"];
        }
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.updateError) {
        exit(0);
    } else {
        NSString *identifier = @"";
        NSString* urlstr = [NSString stringWithFormat:@"https://tmms.hosp.med.tottori-u.ac.jp:4343/officescan/PLS_TMMS_CGI/cgiShowApp.dll?DEVICEID=%@", identifier];
        NSURL *url = [NSURL URLWithString:urlstr];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
