#import "GPUImageFocusFilter.h"
#import "GPUImageFilter.h"
#import "GPUImageTwoInputFilter.h"
#import "GPUImageGaussianBlurFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageFocusFilterFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform highp float dist;
 uniform highp int color;
 
 void main()
 {
     mediump vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     mediump float x = textureCoordinate.x - 0.5;
     mediump float y = textureCoordinate.y - 0.5;
     mediump float d = sqrt(x * x + y * y) / 0.70710678118 + (dist - 1.0);
     
     d = 1.0 / (1.0 + pow(3.0, -d * 20.0 - 10.0 * dist));
     
     gl_FragColor = vec4(sharpImageColor.rgb * (1.0 - d) + blurredImageColor.rgb * d, sharpImageColor.a);
     if(color == 0){
         //gl_FragColor = vec4(sharpImageColor.rgb * (1.0 - d) + vec3(1.0, 0.0, 0.0) * d, sharpImageColor.a);
     }
     if(color == 1){
         //gl_FragColor = vec4(sharpImageColor.rgb * (1.0 - d) + vec3(0.0, 0.0, 1.0) * d, sharpImageColor.a);
     }
     if(color == 2){
         //gl_FragColor = vec4(sharpImageColor.rgb * (1.0 - d) + vec3(0.0, 1.0, 0.0) * d, sharpImageColor.a);
     }
 }
 );
#else
NSString *const kGPUImageFocusFilterFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 varying vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float topFocusLevel;
 uniform float bottomFocusLevel;
 uniform float focusFallOffRate;
 
 void main()
 {
     vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
     vec4 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     float blurIntensity = 1.0 - smoothstep(topFocusLevel - focusFallOffRate, topFocusLevel, textureCoordinate2.y);
     blurIntensity += smoothstep(bottomFocusLevel, bottomFocusLevel + focusFallOffRate, textureCoordinate2.y);
     
     gl_FragColor = mix(sharpImageColor, blurredImageColor, blurIntensity);
 }
 );
#endif

@implementation GPUImageFocusFilter

@synthesize blurRadiusInPixels;
@synthesize distance = _distance;

- (id)init;
{
    if (!(self = [super init]))
    {
		return nil;
    }
    
    // First pass: apply a variable Gaussian blur
    blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [self addFilter:blurFilter];
    
    // Second pass: combine the blurred image with the original sharp one
    tiltShiftFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:kGPUImageFocusFilterFragmentShaderString];
    [self addFilter:tiltShiftFilter];
    
    // Texture location 0 needs to be the sharp image for both the blur and the second stage processing
    [blurFilter addTarget:tiltShiftFilter atTextureLocation:1];
    
    // To prevent double updating of this filter, disable updates from the sharp image side
    //    self.inputFilterToIgnoreForUpdates = tiltShiftFilter;
    
    self.initialFilters = [NSArray arrayWithObjects:blurFilter, tiltShiftFilter, nil];
    self.terminalFilter = tiltShiftFilter;
    
    self.distance = 0.50f;
    self.blurRadiusInPixels = 7.0;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setBlurRadiusInPixels:(CGFloat)newValue;
{
    blurFilter.blurRadiusInPixels = newValue;
}

- (CGFloat)blurRadiusInPixels;
{
    return blurFilter.blurRadiusInPixels;
}

- (void)setDistance:(CGFloat)distance
{
    _distance = distance;
    [tiltShiftFilter setFloat:distance forUniformName:@"dist"];
}

- (void)setColor:(int)color
{
    [tiltShiftFilter setInteger:color forUniformName:@"color"];
}

@end