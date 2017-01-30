//
//  DTCustomColoredAccessory.h
//  Yorick
//
//  Created by TerryTorres on 12/5/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTCustomColoredAccessory : UIControl
{
    UIColor *_accessoryColor;
    UIColor *_highlightedColor;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

+ (DTCustomColoredAccessory *)accessoryWithColor:(UIColor *)color;

@end
