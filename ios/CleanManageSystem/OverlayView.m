//
//  OverlayView.m
//  Control
//
//  Created by akifumin on 2013/07/31.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView
@synthesize zbr, inputBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *top = [[NSBundle mainBundle] loadNibNamed:@"Overlay" owner:self options:nil];
        UIView *view = top[0];
        
        view.frame = CGRectMake(0, 20,  view.frame.size.width,  view.frame.size.height);
        
        //[[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:self options:nil];
        //view.frame = CGRectMake(0, 300, view.frame.size.width, 200);

        [self addSubview:view];

    }
    return self;
}

-(void)setViewValue:(NSString*) title enable:(BOOL) enable ZBarReaderViewController:(ZBarReaderViewController*) zbrvc barButtonName:(NSString *)barButtonName {
    
    
    [[self.dispBackLabel layer] setCornerRadius:5.0];
    [self.dispBackLabel setClipsToBounds:YES];
    
    NSString *message =  [NSString stringWithFormat:@"%@のバーコードをスキャンしてください。", title];
    self.label.text = message;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@", title];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    inputBtn.title = barButtonName;

    [self setZbr:zbrvc];
    inputBtn.enabled = enable;
    
}

- (IBAction)clickInput:(id)sender {
    [zbr dismissViewControllerAnimated:YES completion:nil];
}
@end
