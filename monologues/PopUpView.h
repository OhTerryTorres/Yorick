//
//  PopUpView.h
//  Yorick
//
//  Created by TerryTorres on 2/13/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YorickStyle.h"

@interface PopUpView : UIView

@property (nonatomic) UILabel *titleLabel;

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*)title;
- (id)initWithTitle:(NSString*)title;

@end
