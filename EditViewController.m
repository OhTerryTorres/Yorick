//
//  EditViewController.m
//  Yorick
//
//  Created by TerryTorres on 9/17/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//  

#import "EditViewController.h"

@interface EditViewController ()

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define is_iOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define is_iOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

@end

@implementation EditViewController


#pragma mark: View Changing Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"self.currentMonologue.title is %@", self.currentMonologue.title);
    NSLog(@"self.currentMonologue.text is %@", self.currentMonologue.text);
    [self setUpHeader];
    [self setUpTextView];
}


#pragma mark: Display Setup

-(void)setUpHeader {
    self.headerPaddingView.backgroundColor = [UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:1.0];
    self.editNavigationBar.tintColor = [UIColor colorWithRed:141.0/255.0 green:171.0/255.0 blue:175.0/255.0 alpha:1];
}

-(void)setUpTextView {
    self.textView.text = self.currentMonologue.text;
    
    // All this is going to help us fit the text onto the screen, prep it for editing mode, and have it appear where it's supposed it.
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,320,450)];
    [self.textView setContentSize:CGSizeMake(self.textView.frame.size.width, self.textView.frame.size.height)];
    
    CGRect frame = self.textView.frame;
    frame.size.height = self.textView.contentSize.height;
    self.textView.frame = frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // http://justabunchoftyping.com/fix-for-ios7-uitextview-issues
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
    
    [self.textView becomeFirstResponder];
}


#pragma mark: TextView Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textView = textView;
    
    // dealing with the caret
    oldRect = [self.textView caretRectForPosition:self.textView.selectedTextRange.end];
    noteViewBottomInset =self.textView.contentInset.bottom;
    caretVisibilityTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(scrollCaretToVisible) userInfo:nil repeats:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.textView = nil;
    
    // dealing with the caret
    [caretVisibilityTimer invalidate];
    caretVisibilityTimer = nil;
}

- (void)scrollCaretToVisible
{
    // This is where the cursor is at.
    CGRect caretRect = [self.textView caretRectForPosition:self.textView.selectedTextRange.end];
    
    // test if the caret has moved OR the bottom inset has changed
    if(CGRectEqualToRect(caretRect, oldRect) && noteViewBottomInset == self.textView.contentInset.bottom)
        return;
    
    // reset these for next time this method is called
    oldRect = caretRect;
    noteViewBottomInset = self.textView.contentInset.bottom;
    
    // this is the visible rect of the textview.
    CGRect visibleRect = self.textView.bounds;
    visibleRect.size.height -= (self.textView.contentInset.top + self.textView.contentInset.bottom);
    visibleRect.origin.y = self.textView.contentOffset.y;
    
    // We will scroll only if the caret falls outside of the visible rect.
    if (!CGRectContainsRect(visibleRect, caretRect))
    {
        CGPoint newOffset = self.textView.contentOffset;
        newOffset.y = MAX((caretRect.origin.y + caretRect.size.height) - visibleRect.size.height, 0);
        [self.textView setContentOffset:newOffset animated:NO]; // must be non-animated to work, not sure why
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect bkgndRect = self.textView.superview.frame;
    bkgndRect.size.height += kbFrame.size.height;
    [self.textView.superview setFrame:bkgndRect];
    
    [self.textView setContentInset:UIEdgeInsetsMake((self.textView.contentInset.top), self.textView.contentInset.left, (self.textView.contentInset.bottom + kbFrame.size.height), self.textView.contentInset.right)];

    
    // Let's see how this goes
    UIEdgeInsets insets = self.textView.scrollIndicatorInsets;
    insets.bottom += kbFrame.size.height;
    self.textView.scrollIndicatorInsets = insets;
    
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.textView.contentInset = contentInsets;
    self.textView.scrollIndicatorInsets = contentInsets;
    
    UIEdgeInsets insets = self.textView.scrollIndicatorInsets;
    insets.bottom -= [aNotification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    self.textView.scrollIndicatorInsets = insets;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ( [segue.identifier isEqualToString:@"saveEdit"] ) {
        Monologue *editedMonologue = [[Monologue alloc] initWithidNumber:[self.currentMonologue.idNumber intValue] title:self.currentMonologue.title authorFirst:self.currentMonologue.authorFirst authorLast:self.currentMonologue.authorLast character:self.currentMonologue.character text:self.textView.text gender:self.currentMonologue.gender tone:self.currentMonologue.tone period:self.currentMonologue.period age:self.currentMonologue.age length:self.currentMonologue.length notes:self.currentMonologue.notes tags:self.currentMonologue.tags];
        int index = [self.manager getIndexOfEditedMonologueByTitle:self.currentMonologue.title];
        if (index > -1) { // if index is -1, the monologue was not found.
            self.manager.editedMonologues[index] = editedMonologue;
        } else {
            [self.manager.editedMonologues addObject: editedMonologue];
        }
    }

}




@end
