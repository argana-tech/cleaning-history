//
//  NSMutableURLRequest+UserAgent.h
//  CleanManageSystem
//
//  Created by akifumin on 2013/12/20.
//  Copyright (c) 2013年 akifumin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (UserAgent)
+ (id)requestWithURLUserAgent:(NSURL *)URL;
@end
