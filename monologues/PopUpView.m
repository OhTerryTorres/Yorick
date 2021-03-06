//
//  PopUpView.m
//  Yorick
//
//  Created by TerryTorres on 2/13/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "PopUpView.h"

@implementation PopUpView


// The PopUpView should display a title over a colored field with rounded corners,
// then disappear.

- (id)initWithFrame:(CGRect)frame andTitle:(NSString*)title {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [YorickStyle color3];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.text = title;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.cornerRadius = 20;
    self.alpha = 0.98;
    self.layer.masksToBounds = YES;
    self.center = CGPointMake(self.superview.frame.size.width/2, self.superview.frame.size.height/2);
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [YorickStyle color2];
    self.titleLabel.font = [YorickStyle defaultFont];
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2.0);
    [self addSubview:self.titleLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:0.7
                                     target:self
                                   selector:@selector(fadeAway)
                                   userInfo:nil
                                    repeats:NO];
}

- (id)initWithTitle:(NSString*)title {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBound.size.width;
    CGFloat screenHeight = screenBound.size.height;
    CGRect frame = CGRectMake(0, 0, screenWidth / 1.5, screenHeight / 6);
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [YorickStyle color3];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.text = title;
    }
    return self;
}

-(void)fadeAway {
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}


@end
