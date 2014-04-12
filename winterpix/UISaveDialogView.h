//
//  UISaveToVIew.h
//  Vintage
//
//  Created by SSC on 2014/03/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SaveTo){
    SaveToCameraRoll = 1,
    SaveToTwitter,
    SaveToInstagram,
    SaveToFacebook
};

@class UISaveDialogView;
@class UISaveToButton;

@protocol UISaveDialogViewDelegate
- (void)saveToView:(UISaveDialogView*)view DidSelectSaveTo:(SaveTo)saveTo;
@end


@interface UISaveDialogView : UIView
{
    UISaveToButton* _buttonCameraRoll;
    UISaveToButton* _buttonInstagram;
    UISaveToButton* _buttonTwitter;
}

@property (nonatomic, assign) id<UISaveDialogViewDelegate> delegate;

- (void)didPressButton:(UISaveToButton*)button;
- (void)clearSelected;

@end
