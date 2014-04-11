//
//  GPUImageLinearDodgeBlendFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/03.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageLinearDodgeBlendFilter.h"

NSString *const kGPUImageLinearDodgeBlendFilterFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     mediump vec3 result = base.rgb + overlay.rgb;
     result.r = min(result.r, 1.0);
     result.g = min(result.g, 1.0);
     result.b = min(result.b, 1.0);
     
     gl_FragColor = vec4(result * overlay.a + base.rgb * (1.0 - overlay.a), 1.0);
 }
 );



@implementation GPUImageLinearDodgeBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageLinearDodgeBlendFilterFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}
@end
