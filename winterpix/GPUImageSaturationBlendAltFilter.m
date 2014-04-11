//
//  GPUImageSaturationBlendAltFilter.m
//  Vintage
//
//  Created by SSC on 2014/03/31.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageSaturationBlendAltFilter.h"
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageSaturationBlendAltFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 
 
 mediump vec3 rgb2hsv(mediump vec3 color){
     mediump float r = color.r;
     mediump float g = color.g;
     mediump float b = color.b;
     
     mediump float max = max(r, max(g, b));
     mediump float min = min(r, min(g, b));
     mediump float h = 0.0;
     if(max < min){
         max = 0.0;
         min = 0.0;
     }
     
     if(max == min){
         
     } else if(max == r){
         h = 60.0 * (g - b) / (max - min);
     } else if(max == g){
         h = 60.0 * (b - r) / (max - min) + 120.0;
     } else if(max == b){
         h = 60.0 * (r - g) / (max - min) + 240.0;
     }
     if(h < 0.0){
         h += 360.0;
     }
     h = mod(h, 360.0);
     
     mediump float s;
     if(max == 0.0) {
         s = 0.0;
     } else {
         s = (max - min) / max;
     }
     mediump float v = max;
     
     return vec3(h, s, v);
 }
 
 mediump vec3 hsv2rgb(mediump vec3 color){
     mediump float h = color.r;
     mediump float s = color.g;
     mediump float v = color.b;
     mediump float r;
     mediump float g;
     mediump float b;
     int hi = int(mod(float(floor(h / 60.0)), 6.0));
     mediump float f = (h / 60.0) - float(hi);
     mediump float p = v * (1.0 - s);
     mediump float q = v * (1.0 - s * f);
     mediump float t = v * (1.0 - s * (1.0 - f));
     
     if(hi == 0){
         r = v;
         g = t;
         b = p;
     } else if(hi == 1){
         r = q;
         g = v;
         b = p;
     } else if(hi == 2){
         r = p;
         g = v;
         b = t;
     } else if(hi == 3){
         r = p;
         g = q;
         b = v;
     } else if(hi == 4){
         r = t;
         g = p;
         b = v;
     } else if(hi == 5){
         r = v;
         g = p;
         b = q;
     } else {
         r = v;
         g = t;
         b = p;
     }
     return vec3(r, g, b);
     
 }
 
 
 void main()
 {
	 mediump vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
	 mediump vec4 overlayColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     mediump vec3 baseHsv = rgb2hsv(baseColor.rgb);
     mediump vec3 overlayHsv = rgb2hsv(overlayColor.rgb);
     mediump float weight = baseHsv.y;
     weight = weight * weight;
     baseHsv.y = overlayHsv.y * weight + (1.0 - weight) * baseHsv.y;
     
     baseHsv = hsv2rgb(baseHsv);
     
     gl_FragColor = vec4(baseHsv * overlayColor.a + baseColor.rgb * (1.0 - overlayColor.a), baseColor.a);
 }
 );
#else
NSString *const kGPUImageSaturationBlendAltFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 
 
 vec3 rgb2hsv(vec3 color){
     float r = color.r;
     float g = color.g;
     float b = color.b;
     
     float max = max(r, max(g, b));
     float min = min(r, min(g, b));
     float h = 0.0;
     if(max < min){
         max = 0.0;
         min = 0.0;
     }
     
     if(max == min){
         
     } else if(max == r){
         h = 60.0 * (g - b) / (max - min);
     } else if(max == g){
         h = 60.0 * (b - r) / (max - min) + 120.0;
     } else if(max == b){
         h = 60.0 * (r - g) / (max - min) + 240.0;
     }
     if(h < 0.0){
         h += 360.0;
     }
     h = mod(h, 360.0);
     
     float s;
     if(max == 0.0) {
         s = 0.0;
     } else {
         s = (max - min) / max;
     }
     float v = max;
     
     return vec3(h, s, v);
 }
 
 vec3 hsv2rgb(vec3 color){
     float h = color.r;
     float s = color.g;
     float v = color.b;
     float r;
     float g;
     float b;
     int hi = int(mod(float(floor(h / 60.0)), 6.0));
     float f = (h / 60.0) - float(hi);
     float p = v * (1.0 - s);
     float q = v * (1.0 - s * f);
     float t = v * (1.0 - s * (1.0 - f));
     
     if(hi == 0){
         r = v;
         g = t;
         b = p;
     } else if(hi == 1){
         r = q;
         g = v;
         b = p;
     } else if(hi == 2){
         r = p;
         g = v;
         b = t;
     } else if(hi == 3){
         r = p;
         g = q;
         b = v;
     } else if(hi == 4){
         r = t;
         g = p;
         b = v;
     } else if(hi == 5){
         r = v;
         g = p;
         b = q;
     } else {
         r = v;
         g = t;
         b = p;
     }
     return vec3(r, g, b);
     
 }
 
 
 void main()
 {
	 vec4 baseColor = texture2D(inputImageTexture, textureCoordinate);
	 vec4 overlayColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     vec3 baseHsv = rgb2hsv(baseColor.rgb);
     vec3 overlayHsv = rgb2hsv(overlayColor.rgb);
     baseHsv.y = overlayHsv.y;
     
     baseHsv = hsv2rgb(baseHsv);
     
     gl_FragColor = vec4(baseHsv * overlayColor.a + baseColor.rgb * (1.0 - overlayColor.a), baseColor.a);
 }
 );

#endif
@implementation GPUImageSaturationBlendAltFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageSaturationBlendAltFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
