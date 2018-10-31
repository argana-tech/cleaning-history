//
//  BarcodeSegue.m
//  CleanManageSystem
//
//  Created by akifumin on 2013/08/21.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import "BarcodeSegue.h"

@implementation BarcodeSegue

- (void)perform {
    UIViewController *sourceViewController = (UIViewController *)self.sourceViewController;
    UIViewController *destinationViewController = (UIViewController *)self.destinationViewController;
    [UIView transitionWithView:sourceViewController.navigationController.view
                      duration:0.2
                       options:UIViewAnimationOptionTransitionNone
                    animations:^{
                        [sourceViewController.navigationController pushViewController:destinationViewController animated:NO];
                    }
                    completion:nil];
}

@end
