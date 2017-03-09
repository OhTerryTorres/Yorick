//
//  SizeControlViewController.m
//  Yorick
//
//  Created by TerryTorres on 3/5/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "SizeControlViewController.h"

@interface SizeControlViewController ()

@end

@implementation SizeControlViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Text Size";
    
    self.tableView.tableFooterView = [UIView new];
    UITableViewHeaderFooterView *newHeader = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height * 0.20)];
    self.tableView.tableHeaderView = newHeader;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
    NSString *text;
    UIFont *font;
    switch (indexPath.row) {
        case 0:
            text = @"Normal";
            font = [YorickStyle defaultFont];
            if ( self.manager.textSize == [YorickStyle defaultFontSize] ) {
                text = [NSString stringWithFormat:@"[ %@ ]",text];
                cell.textLabel.textColor = [YorickStyle color2];
            }
            break;
        case 1:
            text = @"Large";
            font = [YorickStyle defaultFontOfSize:[YorickStyle largeFontSize]];
            if ( self.manager.textSize == [YorickStyle largeFontSize] ) {
                text = [NSString stringWithFormat:@"[ %@ ]",text];
                cell.textLabel.textColor = [YorickStyle color2];
            }
            break;
        case 2:
            text = @"Very Large";
            font = [YorickStyle defaultFontOfSize:[YorickStyle veryLargeFontSize]];
            if ( self.manager.textSize == [YorickStyle veryLargeFontSize] ) {
                text = [NSString stringWithFormat:@"[ %@ ]",text];
                cell.textLabel.textColor = [YorickStyle color2];
            }
            break;
        case 3:
            text = @"Largest";
            font = [YorickStyle defaultFontOfSize:[YorickStyle largestFontSize]];
            if ( self.manager.textSize == [YorickStyle largestFontSize] ) {
                text = [NSString stringWithFormat:@"[ %@ ]",text];
                cell.textLabel.textColor = [YorickStyle color2];
            }
            break;
        default:
            break;
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = text;
    cell.textLabel.font = font;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            self.manager.textSize = [YorickStyle defaultFontSize];
            break;
        case 1:
            self.manager.textSize = [YorickStyle largeFontSize];
            break;
        case 2:
            self.manager.textSize = [YorickStyle veryLargeFontSize];
            break;
        case 3:
            self.manager.textSize = [YorickStyle largestFontSize];
            break;
        default:
            break;
    }
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
