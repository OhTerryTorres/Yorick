//
//  YorickStyle.m
//  Yorick
//
//  Created by TerryTorres on 2/8/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "YorickStyle.h"

@implementation YorickStyle

+(UIColor *) color1 {
    return [UIColor colorWithRed:141.0/255.0 green:171.0/255.0 blue:175.0/255.0 alpha:1];
}

+(UIColor *) color2 {
    return [UIColor colorWithRed:68.0/255.0 green:118.0/255.0 blue:125.0/255.0 alpha:1.0];
}

+(UIColor *) color3 {
    return [UIColor colorWithRed:100.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1];
}

+(UIFont *) defaultFont {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
        return [UIFont systemFontOfSize: [YorickStyle defaultFontSize] * 2];
    }
    return [UIFont systemFontOfSize: [YorickStyle defaultFontSize]];
}

+(UIFont *) defaultFontBold {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
        return [UIFont boldSystemFontOfSize: [YorickStyle defaultFontSize] * 2];
    }
    return [UIFont boldSystemFontOfSize: [YorickStyle defaultFontSize]];
}

+(UIFont *) defaultFontOfSize:(CGFloat)size {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
        size *=2;
    }
    return [UIFont systemFontOfSize: size];
}

+(UIFont *) defaultFontBoldOfSize:(CGFloat)size {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
        size *=2;
    }
    return [UIFont boldSystemFontOfSize: size];
}

+(CGFloat) defaultFontSize {
    return 17;
}
+(CGFloat) largeFontSize {
    return 24;
}
+(CGFloat) veryLargeFontSize {
    return 31;
}
+(CGFloat) largestFontSize {
    return 37;
}




@end
