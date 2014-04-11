//
//  UIImage+extend.h
//  Vintage
//
//  Created by SSC on 2014/02/16.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (extend)

+ (UIImage *)resizedImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height;
+ (UIImage*)animatedGIFNamed:(NSString*)name;
+ (UIImage*)animatedGIFWithData:(NSData *)data;

- (UIImage*)animatedImageByScalingAndCroppingToSize:(CGSize)size;

- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end
