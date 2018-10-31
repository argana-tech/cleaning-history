//
//  BarcodeOverlay.h
//  CleanManageSystem
//
//  Created by ebase-sl on 2013/08/21.
//  Copyright (c) 2013年 ebase-sl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZBarReaderViewController.h"

@interface BarcodeOverlay : UIView

+ (id)myView;
@property (weak, nonatomic) IBOutlet UIButton *lightButton;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigartionBar;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lighImage;

@property (weak, nonatomic) IBOutlet UILabel *toolbarLabel;
@property (nonatomic, strong) NSString* title;
@property (weak, nonatomic) IBOutlet UILabel *closeLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanCrop;

@property (nonatomic) ZBarReaderViewController *zBarReaderViewController;


- (void) setFocus : (NSValue*) value;
- (void) setFocus;
- (void) setFocusTimer;
- (void) stopFocusTimer;

@end
