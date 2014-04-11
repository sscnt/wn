#import "GPUImageFilterGroup.h"

@class GPUImageGaussianBlurFilter;

/// A simulated tilt shift lens effect
@interface GPUImageFocusFilter : GPUImageFilterGroup
{
    GPUImageGaussianBlurFilter *blurFilter;
    GPUImageFilter *tiltShiftFilter;
}

/// The radius of the underlying blur, in pixels. This is 7.0 by default.
@property(readwrite, nonatomic) CGFloat blurRadiusInPixels;

/// The rate at which the image gets blurry away from the in-focus region, default 0.2
@property(readwrite, nonatomic) CGFloat distance;

@property(readwrite, nonatomic) int color;

@end
