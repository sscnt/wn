//
//  UIView+Gravy.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extend)
- (CGFloat)bottom;
- (CGFloat)right;
- (void)setShadow;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setCenterX:(CGFloat)x;
- (void)setCenterY:(CGFloat)y;
- (void)setWidth:(NSInteger)width;
- (void)setHeight:(NSInteger)height;
- (void)setOrigin:(CGPoint)point;
- (void)setSize:(CGSize)size;

- (UIImage *) imageByRenderingViewOpaque:(BOOL) opaque Rect:(CGRect)rect;
- (UIImage *) imageByRenderingView;
- (UIImage *) imageByRenderingViewWithRect:(CGRect)rect;

@end
