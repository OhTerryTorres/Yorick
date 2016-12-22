//
//  PSPDFTextView.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
// http://petersteinberger.com/blog/2014/fixing-uitextview-on-ios-7/

#import <UIKit/UIKit.h>

// Subclass of `UITextView` that fixes the most glaring bugs in iOS 7.
@interface PSPDFTextView : UITextView

// Scrolls to caret position, considering insets.
- (void)scrollToVisibleCaretAnimated:(BOOL)animated;

// Scroll to visible range, considering insets.
- (void)scrollRangeToVisibleConsideringInsets:(NSRange)range animated:(BOOL)animated;

@end