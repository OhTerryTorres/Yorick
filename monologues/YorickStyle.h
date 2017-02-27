//
//  YorickStyle.h
//  Yorick
//
//  Created by TerryTorres on 2/8/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YorickStyle : NSObject

+(UIColor *) color1;
+(UIColor *) color2;
+(UIColor *) color3;

+(UIFont *) defaultFont;
+(UIFont *) defaultFontBold;
+(UIFont *) defaultFontOfSize:(CGFloat)size;
+(UIFont *) defaultFontBoldOfSize:(CGFloat)size;
+(CGFloat) defaultFontSize;
+(CGFloat) largeFontSize;
+(CGFloat) veryLargeFontSize;
+(CGFloat) largestFontSize;


@end
