//
//  UISliderThumbVIew.h
//  Vintage
//
//  Created by SSC on 2014/02/16.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISliderThumbVIew : UIView
{
    CGFloat _radius;
}

@property (nonatomic, assign) BOOL locked;

- (id)initWithRadius:(CGFloat)radius;

@end
