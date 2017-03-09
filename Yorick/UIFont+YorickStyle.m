//
//  UIFont+YorickStyle.m
//  Yorick
//
//  Created by TerryTorres on 2/20/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "UIFont+YorickStyle.h"

@implementation UIFont (YorickStyle)


// Swizzling!!
// These calls, for whatever reason, cause a EXC_BAD_ACCESS
// apparently the way the methods are nested might lead to an infinite loop?
/*******

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [YorickStyle defaultFontBoldOfSize:fontSize];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    return [YorickStyle defaultFontOfSize:fontSize];
}
*/

@end
