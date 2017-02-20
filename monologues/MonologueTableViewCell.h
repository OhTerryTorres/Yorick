//
//  MonologueTableViewCell.h
//  Yorick
//
//  Created by TerryTorres on 3/18/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YorickStyle.h"

@interface MonologueTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *characterLabel;

@property (weak, nonatomic) IBOutlet UILabel *excerptLabel;

-(void)setExcerptLabelWithString:(NSString*)string;


@end
