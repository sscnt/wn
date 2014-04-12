//
//  GPUImageReplaceColorFilter.h
//  Winterpix
//
//  Created by SSC on 2014/04/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

@interface GPUImageReplaceColorFilter : GPUImageFilter

@property (nonatomic, assign) float hue;
@property (nonatomic, assign) float saturation;
@property (nonatomic, assign) float lightness;

- (void)setSelectionColorRed:(float)red Green:(float)green Blue:(float)blue;

@end
