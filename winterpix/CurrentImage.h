//
//  CurrentImage.h
//  Vintage
//
//  Created by SSC on 2014/04/03.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentImage : NSObject

@property (nonatomic, assign) CGSize originalImageSize;

+ (CurrentImage*)instance;
+ (BOOL)lastSavedImageExists;
+ (UIImage*)imageAtPath:(NSString*)path;
+ (UIImage*)resizedImageForEditor;
+ (UIImage*)resizedProcessedImageForEditor;
+ (UIImage*)resizedBlurredImageForEditor;
+ (UIImage*)originalImage;
+ (UIImage*)lastSavedImage;
+ (UIImage*)dialogBgImage;
+ (UIImage*)snowImage;
+ (UIImage*)snowImageForEditor;
+ (UIImage*)fogImage;
+ (UIImage*)fogImageForEditor;
+ (BOOL)saveOriginalImage:(UIImage*)image;
+ (BOOL)saveResizedEditorImage:(UIImage*)image;
+ (BOOL)saveResizedProcessedEditorImage:(UIImage*)image;
+ (BOOL)saveResizedBlurredEditorImage:(UIImage*)image;
+ (BOOL)saveLastSavedImage:(UIImage*)image;
+ (BOOL)saveDialogBgImage:(UIImage*)image;
+ (BOOL)saveSnowImage:(UIImage*)image;
+ (BOOL)saveSnowImageForEditor:(UIImage*)image;
+ (BOOL)saveFogImage:(UIImage*)image;
+ (BOOL)saveFogImageForEditor:(UIImage*)image;
+ (CGSize)originalImageSize;
+ (CGSize)editorImageSize;
+ (BOOL)deleteImageAtPath:(NSString*)path;
+ (BOOL)deleteLastSavedImage;
+ (BOOL)deleteOriginalImage;
+ (BOOL)deleteDialogBgImage;
+ (BOOL)deleteResizedForEditorImage;
+ (BOOL)deleteResizedProcessedForEditorImage;
+ (BOOL)deleteResizedBlurredForEditorImage;
+ (BOOL)deleteSnowImage;
+ (BOOL)deleteSnowImageForEditor;
+ (BOOL)deleteFogImage;
+ (BOOL)deleteFogImageForEditor;
+ (void)clean;

@end
