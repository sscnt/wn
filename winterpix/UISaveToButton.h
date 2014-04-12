//
//  UISaveToButton.h
//  Vintage
//
//  Created by SSC on 2014/03/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISaveDialogView.h"

@interface UISaveToButton : UIButton
{
    BOOL _selected;
}

@property (nonatomic, assign) SaveTo saveTo;

@end
