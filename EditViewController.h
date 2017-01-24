//
//  EditViewController.h
//  monologues
//
//  Created by TerryTorres on 9/17/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController <UITextViewDelegate> {
    UIEdgeInsets noteTextViewInsets;
    UIEdgeInsets noteTextViewScrollIndicatorInsets;
    CGRect oldRect;
    NSTimer *caretVisibilityTimer;
    float noteViewBottomInset;
    // This shit helps the cursor/caret stay visible
}

@property (nonatomic, copy) NSString *text;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UINavigationBar *editNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *headerPaddingView;

@end
