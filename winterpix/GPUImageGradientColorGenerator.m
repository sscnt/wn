//
//  GPUGradientColorFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/03.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageGradientColorGenerator.h"

@implementation GPUImageGradientColorGenerator

NSString *const kGPUImageGradientColorGeneratorFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float locations[20];
 uniform mediump float midpoints[20];
 uniform mediump vec4 colors[20];
 uniform mediump float angle;
 uniform mediump float scale;
 uniform mediump float baselineLength;
 uniform int stopsCount;
 uniform mediump float offsetX;
 uniform mediump float offsetY;
 uniform int style;
 
 float round(float a){
     float b = floor(a);
     b = floor((a - b) * 10.0);
     if(int(b) < 5){
         return floor(a);
     }
     return ceil(a);
 }
 
 int index(float x){
     if(x < 0.0){
         return 0;
     }
     if(x > 1.0){
         return stopsCount - 1;
     }
     mediump float loc = 0.0;
     for(int i = 1;i < 20;i++){
         loc = locations[i];
         if(x < loc){
             return i - 1;
         }
     }
     return 0;
 }
 
 vec4 colorAtDistance(mediump float d){
     int index = index(d);
     mediump float startLocation = locations[index];
     mediump float endLocation = locations[index + 1];
     mediump vec4 startColor = colors[index];
     mediump vec4 endColor = colors[index + 1];
     mediump float midpoint = midpoints[index + 1];
     
     
     mediump float r = startColor.r;
     mediump float g = startColor.g;
     mediump float b = startColor.b;
     mediump float a = startColor.a;
     mediump float rdiff = endColor.r - startColor.r;
     mediump float gdiff = endColor.g - startColor.g;
     mediump float bdiff = endColor.b - startColor.b;
     mediump float adiff = endColor.a - startColor.a;
     mediump float rmid = rdiff / 2.0;
     mediump float gmid = gdiff / 2.0;
     mediump float bmid = bdiff / 2.0;
     mediump float amid = adiff / 2.0;
     
     
     if(d >= 1.0){
         r = colors[stopsCount - 1].r;
         g = colors[stopsCount - 1].g;
         b = colors[stopsCount - 1].b;
         a = colors[stopsCount - 1].a;
     } else if(d < 0.0){
         r = startColor.r;
         g = startColor.g;
         b = startColor.b;
         a = startColor.a;
     } else{
         mediump float relativeX;
         relativeX = (d - startLocation) / (endLocation - startLocation);
         if(relativeX > midpoint){
             relativeX = (relativeX - midpoint) / (1.0 - midpoint);
             mediump float weight = -cos(M_PI_2 + relativeX * M_PI_2);
             relativeX = relativeX + (weight - relativeX) * 0.8;
             r += rmid * (relativeX + 1.0);
             g += gmid * (relativeX + 1.0);
             b += bmid * (relativeX + 1.0);
             a += amid * (relativeX + 1.0);
         } else{
             relativeX = relativeX / midpoint;
             mediump float weight = 1.0 - cos(relativeX * M_PI_2);
             relativeX = relativeX + (weight - relativeX) * 0.8;
             r += rmid * relativeX;
             g += gmid * relativeX;
             b += bmid * relativeX;
             a += amid * relativeX;
         }
     }
     
     r = max(0.0, min(1.0, r));
     g = max(0.0, min(1.0, g));
     b = max(0.0, min(1.0, b));
     a = max(0.0, min(1.0, a));
     
     return mediump vec4(r, g, b, a);

 }

 vec4 radial(mediump float x, mediump float y){
     mediump float d = sqrt((x - 0.5) * (x - 0.5) + (y - 0.5) * (y - 0.5)) * 2.0;
     d /= scale;
     return colorAtDistance(d);
 }
 
 vec4 linear(mediump float x, mediump float y){
     mediump float m60 = 0.01665;
     mediump float slope = tan(M_PI-angle);
     mediump float d;
     mediump float _y;
     if(slope != 0.0){
         mediump float vSlope = -1.0 / slope;
         /*
          y - 0.5 = vSlope * (x - 0.5);
          */
         d = abs(-vSlope * x + y + 0.5 * (vSlope - 1.0)) / sqrt(vSlope * vSlope + 1.0);
         _y = vSlope * (x - 0.5) + 0.5;
         if(y > _y){
             d = 0.5 - d / scale;
         } else{
             d = 0.5 + d / scale;
         }
     } else{
         d = x / scale;
     }
     if(angle >= M_PI){
         d = 1.0 - d;
     }
     if(style == 3){
         if (d > 1.0){
             d = 1.0;
             /*
             if(d > 2.0){
                 d = 2.0;
             }
             d = 1.0 - (d - 1.0);
              */
         }
         if(d < 0.0){
             if(d < -1.0){
                 d = -1.0;
             }
             d = -1.0 * d;
         }
     }
     return colorAtDistance(d);
 }
  
 void main()
 {
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump float m60 = 0.01665;

     mediump float x = textureCoordinate.x - offsetX;
     mediump float y = textureCoordinate.y - offsetY;

     if(style == 1){
         gl_FragColor = linear(x, y);
     } else if(style == 2){
         gl_FragColor = radial(x, y);
     } else if(style == 3){
         gl_FragColor = linear(x, y);
     } else{
         gl_FragColor = pixel;
     }
 }
 );


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageGradientColorGeneratorFragmentShaderString]))
    {
        return nil;
    }
    locationsUniform = [filterProgram uniformIndex:@"locations"];
    midpointUniform = [filterProgram uniformIndex:@"midpoints"];
    colorsUniform = [filterProgram uniformIndex:@"colors"];
    angleUniform = [filterProgram uniformIndex:@"angle"];
    scaleUniform = [filterProgram uniformIndex:@"scale"];
    baselineLengthUniform = [filterProgram uniformIndex:@"baselineLength"];
    stopsCountUniform = [filterProgram uniformIndex:@"stopsCount"];
    offsetXUniform = [filterProgram uniformIndex:@"offsetX"];
    offsetYUniform = [filterProgram uniformIndex:@"offsetY"];
    styleUniform = [filterProgram uniformIndex:@"style"];
    self.style = GradientStyleLinear;
    index = 0;
    
    [self setFloat:0.0f forUniform:offsetXUniform program:filterProgram];
    [self setFloat:0.0f forUniform:offsetYUniform program:filterProgram];
    
    return self;
}

- (void)addColorRed:(float)red Green:(float)green Blue:(float)blue Opacity:(float)opacity Location:(int)location Midpoint:(int)midpoint
{
    GPUVector4 vec = {red / 255.0f, green / 255.0f, blue / 255.0f, opacity / 100.0f};
    colors[index] = vec;
    locations[index] = (float)location / 4096.0f;
    midpoints[index] = (float)midpoint / 100.0f;
    index++;
    [self setFloatArray:locations length:20 forUniform:locationsUniform program:filterProgram];
    [self setFloatArray:midpoints length:20 forUniform:midpointUniform program:filterProgram];
    [self setVec4Array:colors length:20 forUniform:colorsUniform program:filterProgram];
    [self setInteger:index forUniform:stopsCountUniform program:filterProgram];
}

- (void)setAngleDegree:(float)angle
{
    _angle = angle - floorf(angle / 360.0f) * 360.0f;
    _angle = _angle / 180.0f * M_PI;
    //_angle = (angle < 0.0f) ? -_angle : _angle;
    [self setFloat:_angle forUniform:angleUniform program:filterProgram];
}

- (void)setScalePercent:(float)scale
{
    _scale = scale / 100.0f;
    [self setFloat:_scale forUniform:scaleUniform program:filterProgram];
}

- (void)setOffsetX:(float)x Y:(float)y
{
    [self setFloat:x / 100.0f forUniform:offsetXUniform program:filterProgram];
    [self setFloat:y / 100.0f forUniform:offsetYUniform program:filterProgram];
}

- (void)setStyle:(GradientStyle)style
{
    _style = style;
    [self setInteger:style forUniform:styleUniform program:filterProgram];
}

- (void)setup
{
    baselineLength = 0.0f;
    float angleThreshold = atanf(imageHeight / imageWidth);
    float angle = (_angle < 0.0f) ? -_angle : _angle;
    float angleInput = angle - floorf(angle / M_PI) * M_PI;
    if(angleInput > angleThreshold && angleInput < M_PI - angleThreshold){
        baselineLength = imageHeight / cosf(M_PI_2 - angleInput);
    } else{
        baselineLength = imageWidth / cosf(angleInput);
    }
    baselineLength = (baselineLength < 0.0f) ? -baselineLength : baselineLength;
    [self setFloat:baselineLength forUniform:baselineLengthUniform program:filterProgram];
}

- (UIImage *)imageFromCurrentlyProcessedOutput
{
    [self setup];
    return [super imageFromCurrentlyProcessedOutput];
}

- (void)forceProcessingAtSize:(CGSize)frameSize;
{
    [super forceProcessingAtSize:frameSize];
    imageWidth = frameSize.width;
    imageHeight = frameSize.height;
    
    if (!CGSizeEqualToSize(inputTextureSize, CGSizeZero))
    {
        [self newFrameReadyAtTime:kCMTimeIndefinite atIndex:0];
    }
}

- (void)addTarget:(id<GPUImageInput>)newTarget atTextureLocation:(NSInteger)textureLocation;
{
    [super addTarget:newTarget atTextureLocation:textureLocation];
    
    if (!CGSizeEqualToSize(inputTextureSize, CGSizeZero))
    {
        [newTarget setInputSize:inputTextureSize atIndex:textureLocation];
        [newTarget newFrameReadyAtTime:kCMTimeIndefinite atIndex:textureLocation];
    }
}

@end
