//
//  GPUImageAllAdjustmentsInOneFilter.m
//  Vintage
//
//  Created by SSC on 2014/03/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageAllAdjustmentsInOneFilter.h"


#define GammaCorrection(color, gamma)								pow(color, 1.0 / gamma)

/*
 ** Levels control (input (+gamma), output)
 ** Details: http://blog.mouaif.org/2009/01/28/levels-control-shader/
 */

#define LevelsControlInputRange(color, minInput, maxInput)				min(max(color - minInput, vec3(0.0)) / (maxInput - minInput), vec3(1.0))
#define LevelsControlInput(color, minInput, gamma, maxInput)				GammaCorrection(LevelsControlInputRange(color, minInput, maxInput), gamma)
#define LevelsControlOutputRange(color, minOutput, maxOutput) 			mix(minOutput, maxOutput, color)
#define LevelsControl(color, minInput, gamma, maxInput, minOutput, maxOutput) 	LevelsControlOutputRange(LevelsControlInput(color, minInput, gamma, maxInput), minOutput, maxOutput)


#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageAllAdjustmentsInOneFilterFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform mediump float brightness;
 uniform mediump float clarityIntensity;
 uniform mediump vec3 levelsMin;
 uniform mediump vec3 levelsMid;
 uniform mediump vec3 levelsMax;
 uniform mediump vec3 levelsMinOutput;
 uniform mediump vec3 levelsMaxOutput;
 uniform mediump float contrast;
 uniform mediump float kelvin;
 uniform mediump float kelvinStrength;
 uniform mediump float saturation;
 uniform mediump float vibrance;
 
 mediump vec3 rgb2hsl(mediump vec3 color)
 {
     mediump vec3 hsl; // init to 0 to avoid warnings ? (and reverse if + remove first part)
     
     mediump float fmin = min(min(color.r, color.g), color.b);    //Min. value of RGB
     mediump float fmax = max(max(color.r, color.g), color.b);    //Max. value of RGB
     mediump float delta = fmax - fmin;             //Delta RGB value
     
     hsl.z = (fmax + fmin) / 2.0; // Luminance
     
     if (delta == 0.0)		//This is a gray, no chroma...
     {
         hsl.x = 0.0;	// Hue
         hsl.y = 0.0;	// Saturation
     }
     else                                    //Chromatic data...
     {
         if (hsl.z < 0.5)
             hsl.y = delta / (fmax + fmin); // Saturation
         else
             hsl.y = delta / (2.0 - fmax - fmin); // Saturation
         
         mediump float deltaR = (((fmax - color.r) / 6.0) + (delta / 2.0)) / delta;
         mediump float deltaG = (((fmax - color.g) / 6.0) + (delta / 2.0)) / delta;
         mediump float deltaB = (((fmax - color.b) / 6.0) + (delta / 2.0)) / delta;
         
         if (color.r == fmax )
             hsl.x = deltaB - deltaG; // Hue
         else if (color.g == fmax)
             hsl.x = (1.0 / 3.0) + deltaR - deltaB; // Hue
         else if (color.b == fmax)
             hsl.x = (2.0 / 3.0) + deltaG - deltaR; // Hue
         
         if (hsl.x < 0.0)
             hsl.x += 1.0; // Hue
         else if (hsl.x > 1.0)
             hsl.x -= 1.0; // Hue
     }
     
     return hsl;
 }
 mediump float hue2rgb(mediump float f1, mediump float f2, mediump float hue)
 {
     if (hue < 0.0)
         hue += 1.0;
     else if (hue > 1.0)
         hue -= 1.0;
     mediump float res;
     if ((6.0 * hue) < 1.0)
         res = f1 + (f2 - f1) * 6.0 * hue;
     else if ((2.0 * hue) < 1.0)
         res = f2;
     else if ((3.0 * hue) < 2.0)
         res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
     else
         res = f1;
     return res;
 }
 
 mediump vec3 hsl2rgb(mediump vec3 hsl)
 {
     mediump vec3 rgb;
     
     if (hsl.y == 0.0)
         rgb = vec3(hsl.z); // Luminance
     else
     {
         mediump float f2;
         
         if (hsl.z < 0.5)
             f2 = hsl.z * (1.0 + hsl.y);
         else
             f2 = (hsl.z + hsl.y) - (hsl.y * hsl.z);
         
         mediump float f1 = 2.0 * hsl.z - f2;
         
         rgb.r = hue2rgb(f1, f2, hsl.x + (1.0/3.0));
         rgb.g = hue2rgb(f1, f2, hsl.x);
         rgb.b= hue2rgb(f1, f2, hsl.x - (1.0/3.0));
     }
     
     return rgb;
 }
 
 mediump vec3 hsv2rgb(mediump vec3 color){
     mediump float h = color.r;
     mediump float s = color.g;
     mediump float v = color.b;
     mediump float r;
     mediump float g;
     mediump float b;
     mediump float m60 = 0.01665;
     int hi = int(mod(float(floor(h * m60)), 6.0));
     mediump float f = (h * m60) - float(hi);
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
     return mediump vec3(r, g, b);
     
 }
 
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
     
     return mediump vec3(h, s, v);
 }
 mediump vec3 rgb2yuv(mediump vec3 rgb){
     mediump float r = rgb.r * 0.8588 + 0.0625;
     mediump float g = rgb.g * 0.8588 + 0.0625;
     mediump float b = rgb.b * 0.8588 + 0.0625;
     
     mediump float y = 0.299 * r + 0.587 * g + 0.114 * b;
     mediump float u = -0.169 * r - 0.331 * g + 0.500 * b;
     mediump float v = 0.500 * r - 0.419 * g - 0.081 * b;
     return mediump vec3(y, u, v);
 }
 
 mediump vec3 yuv2rgb(mediump vec3 yuv){
     mediump float r = yuv.x + 1.402 * yuv.z - 0.0625;
     mediump float g = yuv.x - 0.344 * yuv.y - 0.714 * yuv.z - 0.0625;
     mediump float b = yuv.x + 1.772 * yuv.y - 0.0625;
     
     r *= 1.164;
     g *= 1.164;
     b *= 1.164;
     
     r = max(0.0, min(1.0, r));
     g = max(0.0, min(1.0, g));
     b = max(0.0, min(1.0, b));
     return mediump vec3(r, g, b);
 }
 
mediump vec3 rgb2xyz(mediump vec3 color){
     mediump mat3 adobe;
     adobe[0] = vec3(0.576669, 0.297345, 0.027031);
     adobe[1] = vec3(0.185558, 0.627364, 0.070689);
     adobe[2] = vec3(0.188229, 0.075291, 0.991338);
     return adobe * color;
 }
 
 mediump vec3 xyz2rgb(mediump vec3 color){
     mediump mat3 adobe;
     adobe[0] = vec3(2.041588, -0.969244, 0.013444);
     adobe[1] = vec3(-0.565007, 1.875968, -0.118362);
     adobe[2] = vec3(-0.344731, 0.041555, 1.015175);
     return adobe * color;
 }
 
mediump float xyz2labFt(mediump float t){
     if(t > 0.00885645167){
         return 116.0 * pow(t, 0.33333333333) - 16.0;
     } else{
         return 903.296296296 * t;
     }
 }
 
 mediump vec3 xyz2lab(mediump vec3 color){
     mediump float l = xyz2labFt(color.y);
     mediump float a = 4.31034482759 * (xyz2labFt(color.x / 0.9642) - l);
     mediump float b = 1.72413793103 * (l - xyz2labFt(color.z / 0.8249));
     return mediump vec3(l, a, b);
 }
 
 mediump vec3 lab2xyz(mediump vec3 color){
     mediump float fy = (color.x + 16.0) / 116.0;
     mediump float fx = fy + (color.y / 500.0);
     mediump float fz = fy - (color.z / 200.0);
     mediump float x;
     mediump float y;
     mediump float z;
     if(fy > 0.20689655172)
         y = fy * fy * fy;
     else
         y = 0.00110705645 * (116.0 * fy - 16.0);
     if(fx > 0.20689655172)
         x = fx * fx * fx * 0.9642;
     else
         x = 0.00110705645 * (116.0 * fx - 16.0) * 0.9642;
     if(fz > 0.20689655172)
         z = fz * fz * fz * 0.8249 ;
     else
         z = 0.00110705645 * (116.0 * fz - 16.0) * 0.8249;
     return mediump vec3(x, y, z);
 }
 
 mediump vec3 rgb2lab(mediump vec3 color){
     return xyz2lab(rgb2xyz(color));
 }
 
 mediump vec3 lab2rgb(mediump vec3 color){
     return xyz2rgb(lab2xyz(color));
 }
 mediump vec3 kelvinShift(const in mediump float klvn, const in mediump float strength, const in mediump vec3 color){

     mediump float luminance = max(max(color.r, color.g), color.b);
     
     if(luminance == 0.0){
         return color;
     }
     
     mediump float r = 0.0;
     mediump float g = 0.0;
     mediump float b = 0.0;
     
     // Calc red
     if(klvn <= 66.0){
         r = 255.0;
     }else{
         r = klvn - 60.0;
         r = 329.698727446 * pow(r, -0.1332047592);
     }
     if(r < 0.0){
         r = 0.0;
     }
     if(r > 255.0){
         r = 255.0;
     }
     
     // Calc green
     if(klvn <= 66.0){
         g = klvn;
         g = 99.4708025861 * log(g) - 161.1195681661;
     }else{
         g = kelvin - 60.0;
         g = 288.1221695283 * pow(g, -0.0755148492);
     }
     if(g < 0.0){
         g = 0.0;
     }
     if(g > 255.0){
         g = 255.0;
     }
     
     
     // Calc blue
     if(klvn >= 66.0){
         b = 255.0;
     }else{
         if(klvn <= 19.0){
             b = 0.0;
         }else{
             b = klvn - 10.0;
             b = 138.5177312231 * log(b) - 305.0447927307;
         }
     }
     if(b < 0.0){
         b = 0.0;
     }
     if(b > 255.0){
         b = 255.0;
     }
     mediump vec3 rgb;
     
     rgb.r = (1.0 - strength) * color.r + r / 255.0 * strength;
     rgb.g = (1.0 - strength) * color.g + g / 255.0 * strength;
     rgb.b = (1.0 - strength) * color.b + b / 255.0 * strength;
     
     rgb.r = max(min(1.0, rgb.r), 0.0);
     rgb.g = max(min(1.0, rgb.g), 0.0);
     rgb.b = max(min(1.0, rgb.b), 0.0);
     
     
     rgb = rgb2hsv(rgb);
     rgb.z = luminance;
     rgb = hsv2rgb(rgb);
     
     return rgb;
 }
 
 mediump vec3 adjustVibrance(mediump float vib, mediump vec3 color){
     mediump vec3 hsv = rgb2hsv(color);
     mediump float x = hsv.y * 2.0 - 1.0;
     mediump float y = hsv.x / 90.0;
     mediump float influence = 1.0 - x * x;
     
     mediump vec3 lab = rgb2lab(color);
     mediump vec3 baselab = rgb2lab(vec3(252.0/255.0, 226.0/255.0, 196.0/255.0));
     mediump float skin_distance = sqrt((lab.x - baselab.x) * (lab.x - baselab.x) + (lab.y - baselab.y) * (lab.y - baselab.y) + (lab.z - baselab.z) * (lab.z - baselab.z));
     skin_distance /= 376.0;
     
     baselab = rgb2lab(vec3(1.0, 0.5, 0.0));
     mediump float red_distance = sqrt((lab.x - baselab.x) * (lab.x - baselab.x) + (lab.y - baselab.y) * (lab.y - baselab.y) + (lab.z - baselab.z) * (lab.z - baselab.z));
     red_distance /= 376.0;
     
     baselab = rgb2lab(vec3(0.0, 1.0, 0.0));
     mediump float green_distance = sqrt((lab.x - baselab.x) * (lab.x - baselab.x) + (lab.y - baselab.y) * (lab.y - baselab.y) + (lab.z - baselab.z) * (lab.z - baselab.z));
     green_distance /= 376.0;
     
     baselab = rgb2lab(vec3(0.0, 0.0, 1.0));
     mediump float blue_distance = sqrt((lab.x - baselab.x) * (lab.x - baselab.x) + (lab.y - baselab.y) * (lab.y - baselab.y) + (lab.z - baselab.z) * (lab.z - baselab.z));
     blue_distance /= 376.0;
     
     mediump float distance = (skin_distance + red_distance) / (blue_distance + green_distance);
     distance = max(min(distance, 1.0), 0.0);
     
     influence *= distance;
     hsv.y *= vib;
     hsv.y = max(min(hsv.y, 1.0), 0.0);
     mediump vec3 rgb = hsv2rgb(hsv);
     
     rgb.r = influence * rgb.r + (1.0 - influence) * color.r;
     rgb.g = influence * rgb.g + (1.0 - influence) * color.g;
     rgb.b = influence * rgb.b + (1.0 - influence) * color.b;
     
     return rgb;
 }
 
 void main()
 {
     mediump vec4 basePixel = texture2D(inputImageTexture, textureCoordinate);
     
     mediump vec3 pixel = basePixel.rgb;
     mediump vec3 yuv;
     mediump vec3 tmpvec;
     mediump float lum;
     mediump float tmp;
     mediump float weight;
     
     //// Kelvin
     if(kelvinStrength != 0.0){
         pixel = kelvinShift(kelvin, kelvinStrength, pixel);
     }
     
     //// Saturation
     if(saturation != 1.0){
         tmpvec = rgb2hsv(pixel);
         mediump float x = tmpvec.y * 2.0 - 1.0;
         //mediump float y = tmpvec.x / 90.0;
         weight = 1.0 - x * x;
         
         tmpvec.y *= saturation;
         tmpvec.y = max(min(tmpvec.y, 1.0), 0.0);
         tmpvec = hsv2rgb(tmpvec);
         
         pixel.r = weight * tmpvec.r + (1.0 - weight) * pixel.r;
         pixel.g = weight * tmpvec.g + (1.0 - weight) * pixel.g;
         pixel.b = weight * tmpvec.b + (1.0 - weight) * pixel.b;
     }
     
     //// Vibrance
     if(vibrance != 1.0){
         pixel = adjustVibrance(vibrance, pixel);
     }
     
     //// Brightness
     if(brightness != 0.0){
         if(brightness > 0.0){
             pixel.rgb = log(exp(4.0 * pixel.rgb * (1.0 + brightness * 1.3) / 4.0));
             //yuv = rgb2yuv(pixel);
             //lum = yuv.x;
             //yuv.x += brightness;
             //yuv.x = max(min(yuv.x, 1.0), 0.0);
             //pixel.rgb = yuv2rgb(yuv);
         }else{
             //pixel.rgb = pixel.rgb * pow(2.0, brightness * 4.0);
             pixel.rgb = log(exp(4.0 * pixel.rgb * (1.0 + brightness) / 4.0));
         }
     }
     
     //// Levels
     if(levelsMid.x < 0.99 || levelsMid.x > 1.01){
         //yuv = rgb2yuv(pixel.rgb);
         //lum = yuv.x;
         //tmp = lum - 0.3;
         //if(tmp < 0.0){
         //    tmp = 0.0;
         //}
         //weight = 1.0 - pow(tmp, 5.0);
         pixel = LevelsControl(pixel, levelsMin, levelsMid, levelsMax, levelsMinOutput, levelsMaxOutput);
         //if(levelsMid.x > 1.0){
             //tmpvec = exp(4.0 * vec3(0.5));
             //pixel = vec3(log((exp(4.0 * pixel.rgb) - exp(4.0 * vec3(0.5))) * (1.0 + (levelsMid.x - 1.0) / 3.0) + exp(4.0 * vec3(0.5))) / 4.0);
             //pixel = vec3((pixel.rgb - vec3(0.5)) * (1.0 + (levelsMid.x - 1.0) / 3.0) + vec3(0.5));
         //}
         
         //pixel = tmpvec;
         
     }
     
     //// Contrast
     if(contrast != 1.0){
         pixel = vec3(((pixel.rgb - vec3(0.5)) * contrast + vec3(0.5)));
     }
     
     gl_FragColor = vec4(pixel, basePixel.a);
 }
 );
#else
#endif

@implementation GPUImageAllAdjustmentsInOneFilter

- (id)init;
{
    
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageAllAdjustmentsInOneFilterFragmentShaderString]))
    {
        return nil;
    }


    //// Brightness
    self.brightness = 0.0f;
    
    //// Clarity
    self.clarityIntensity = 0.0f;
    self.clarityBlurRadiusInPixels = 40.0f;
    
    //// Levels
    [self setLevelsRedMin:0.0 gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
    [self setLevelsGreenMin:0.0 gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
    [self setLevelsBlueMin:0.0 gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
    
    //// Contrast
    self.contrast = 1.0f;
    
    //// Kelvin
    self.kelvinStrength = 0.0f;
    
    //// Saturation
    self.saturation = 1.0f;
    
    //// Vibrance
    self.vibrance = 1.0f;
    
    return self;
}

#pragma mark Brightness
- (void)setBrightness:(CGFloat)brightness
{
    _brightness = brightness;
    [self setFloat:brightness forUniformName:@"brightness"];
}

#pragma mark Levels
- (void)updateUniforms {
    [self setFloatVec3:levelsMinVector forUniformName:@"levelsMin"];
    [self setFloatVec3:levelsMidVector forUniformName:@"levelsMid"];
    [self setFloatVec3:levelsMaxVector forUniformName:@"levelsMax"];
    [self setFloatVec3:levelsMinOutputVector forUniformName:@"levelsMinOutput"];
    [self setFloatVec3:levlesMaxOutputVector forUniformName:@"levelsMaxOutput"];
}

- (void)setLevelsMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut {
    [self setLevelsRedMin:min gamma:mid max:max minOut:minOut maxOut:maxOut];
    [self setLevelsGreenMin:min gamma:mid max:max minOut:minOut maxOut:maxOut];
    [self setLevelsBlueMin:min gamma:mid max:max minOut:minOut maxOut:maxOut];
}

- (void)setLevelsMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max {
    [self setLevelsMin:min gamma:mid max:max minOut:0.0 maxOut:1.0];
}

- (void)setLevelsRedMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut {
    levelsMinVector.one = min;
    levelsMidVector.one = mid;
    levelsMaxVector.one = max;
    levelsMinOutputVector.one = minOut;
    levlesMaxOutputVector.one = maxOut;
    
    [self updateUniforms];
}

- (void)setLevelsRedMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max {
    [self setLevelsRedMin:min gamma:mid max:max minOut:0.0 maxOut:1.0];
}

- (void)setLevelsGreenMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut {
    levelsMinVector.two = min;
    levelsMidVector.two = mid;
    levelsMaxVector.two = max;
    levelsMinOutputVector.two = minOut;
    levlesMaxOutputVector.two = maxOut;
    
    [self updateUniforms];
}

- (void)setLevelsGreenMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max {
    [self setLevelsGreenMin:min gamma:mid max:max minOut:0.0 maxOut:1.0];
}

- (void)setLevelsBlueMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut {
    levelsMinVector.three = min;
    levelsMidVector.three = mid;
    levelsMaxVector.three = max;
    levelsMinOutputVector.three = minOut;
    levlesMaxOutputVector.three = maxOut;
    
    [self updateUniforms];
}

- (void)setLevelsBlueMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max {
    [self setLevelsBlueMin:min gamma:mid max:max minOut:0.0 maxOut:1.0];
}

#pragma mark Contrast

- (void)setContrast:(CGFloat)newValue;
{
    _contrast = newValue;
    [self setFloat:newValue forUniformName:@"contrast"];
}

#pragma mark Kelvin

- (void)setKelvin:(float)kelvin
{
    if(kelvin < 1000.0){
        kelvin = 1000.0f;
    }
    if(kelvin > 40000.0f){
        kelvin = 40000.0f;
    }
    kelvin /= 100.0f;
    _kelvin = kelvin;
    [self setFloat:kelvin forUniformName:@"kelvin"];
}

- (void)setKelvinStrength:(float)kelvinStrength
{
    if(kelvinStrength > 100.0f){
        kelvinStrength = 100.0f;
    }
    if(kelvinStrength < 0.0f){
        kelvinStrength = 0.0f;
    }
    kelvinStrength /= 100.0f;
    [self setFloat:kelvinStrength forUniformName:@"kelvinStrength"];
}

#pragma mark Saturation

- (void)setSaturation:(CGFloat)saturation
{
    _saturation = MAX(MIN(saturation, 2.0), 0.01);
    [self setFloat:_saturation forUniformName:@"saturation"];
}

#pragma mark Vibrance

- (void)setVibrance:(CGFloat)vibrance
{
    _vibrance = MAX(MIN(vibrance, 2.0), 0.01);
    [self setFloat:_vibrance forUniformName:@"vibrance"];
}



@end
