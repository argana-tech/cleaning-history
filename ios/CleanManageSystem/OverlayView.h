//
//  OverlayView.h
//  Control
//
//  Created by akifumin on 2013/07/31.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import <QuartzCore/QuartzCore.h>

@interface OverlayView : UIView
- (IBAction)clickInput:(id)sender;
- (void)setViewValue:(NSString*) title enable:(BOOL)enable ZBarReaderViewController:(ZBarReaderViewController*)zbr barButtonName:(NSString*)barButtonName;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *inputBtn;
@property (nonatomic) ZBarReaderViewController *zbr;
@property (weak, nonatomic) IBOutlet UILabel *dispBackLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
