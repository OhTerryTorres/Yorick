//
//  EditViewController.h
//  Yorick
//
//  Created by TerryTorres on 9/17/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "YorickStyle.h"
#import "MonologueViewController.h"

@interface EditViewController : UIViewController <UITextViewDelegate> {
    UIEdgeInsets noteTextViewInsets;
    UIEdgeInsets noteTextViewScrollIndicatorInsets;
    CGRect oldRect;
    NSTimer *caretVisibilityTimer;
    float noteViewBottomInset;
    // This shit helps the cursor/caret stay visible
}


@property (weak, nonatomic) MonologueManager *manager;
@property (nonatomic) Monologue *currentMonologue;

@property (nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UINavigationBar *editNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *headerPaddingView;

@end
