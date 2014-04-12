//
//  UISaveToButton.m
//  Vintage
//
//  Created by SSC on 2014/03/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UISaveToButton.h"

@implementation UISaveToButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _selected = NO;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.70f];
        NSArray *langs = [NSLocale preferredLanguages];
        NSString *currentLanguage = [langs objectAtIndex:0];
        [self setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.85f] forState:UIControlStateNormal];
        if([currentLanguage compare:@"ja"] == NSOrderedSame) {
            self.titleLabel.font = [UIFont fontWithName:@"mplus-1c-bold" size:18.0f];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 22.0f, 0, 0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 0.0)];
        } else {
            self.titleLabel.font = [UIFont fontWithName:@"Aller-Bold" size:19.0f];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 22.0f, 0, 0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 0.0)];
        }

    }
    return self;
}
- (void)setSaveTo:(SaveTo)saveTo
{
    _saveTo = saveTo;
    switch (saveTo) {
        case SaveToCameraRoll:
            [self setImage:[UIImage imageNamed:@"photos-36-85.png"] forState:UIControlStateNormal];
            break;
        case SaveToInstagram:
            [self setImage:[UIImage imageNamed:@"camera-36-85.png"] forState:UIControlStateNormal];
            break;
        case SaveToTwitter:
            [self setImage:[UIImage imageNamed:@"twitter-36-85.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if(highlighted){
        [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.90f]];
    }else{
        //[self setBackgroundColor:[UIColor clearColor]];
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.70f];
    }
    
}

- (void)setSelected:(BOOL)selected
{
    if(selected){
        [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.90f]];
    }else{
        //[self setBackgroundColor:[UIColor clearColor]];
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.70f];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
