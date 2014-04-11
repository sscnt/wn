//
//  UIScrollView+m.h
//  Minority
//
//  Created by SSC on 2013/03/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (extend)

-(void)append:(UIView*)view;
-(void)adjustContentSize;
-(void)removeAllSubviews;

@end
