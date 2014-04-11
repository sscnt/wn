//
//  GPUImageSelectiveColorFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/07.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUImageSelectiveColorFilterFragmentShaderString;

@interface GPUImageSelectiveColorFilter : GPUImageFilter

- (void)setRedsCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setYellowsCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setGreensCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setCyansCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setBluesCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setMagentasCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setWhitesCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setNeutralsCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;
- (void)setBlacksCyan:(int)cyan Magenta:(int)magenta Yellow:(int)yellow Black:(int)black;

@end
