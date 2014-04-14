//
//  GPUimageTumblinBrightnessFilter.m
//  Vintage
//
//  Created by SSC on 2014/02/18.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUimageTumblinBrightnessFilter.h"

@implementation GPUimageTumblinBrightnessFilter

NSString *const kGPUImageTumblinBrightnessFilterFragmentShaderString = SHADER_STRING
(
 precision mediump float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float brightness;
 
 void main()
 {
     // Sample the input pixel
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     if(brightness > 0.0){
         pixel.rgb = log(exp(4.0 * pixel.rgb * (1.0 + brightness * 1.3) / 4.0));
     }else{
         pixel.rgb = log(exp(4.0 * pixel.rgb * (1.0 + brightness) / 4.0));
     }
     gl_FragColor = pixel;
 }
 );

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageTumblinBrightnessFilterFragmentShaderString]))
    {
        return nil;
    }
    
    brightnessUniform = [filterProgram uniformIndex:@"brightness"];
    self.brightness = 0.0f;
    return self;
}

- (void)setBrightness:(CGFloat)brightness
{
    _brightness = brightness;
    [self setFloat:brightness forUniform:brightnessUniform program:filterProgram];
}

@end
