//
//  UYLTextCell.h
//  Yorick
//
//  Created by TerryTorres on 7/7/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YorickStyle.h"

@interface UYLTextCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *cellTextLabel;

@property (nonatomic, weak) IBOutlet UILabel *cellNotesLabel;

@property (nonatomic, weak) IBOutlet UILabel *cellTagsLabel;

@property (nonatomic, weak) IBOutlet UILabel *cellGenderLabel;
@property (nonatomic, weak) IBOutlet UILabel *cellPeriodLabel;
@property (nonatomic, weak) IBOutlet UILabel *cellAgeLabel;
@property (nonatomic, weak) IBOutlet UILabel *cellLengthLabel;

@property (strong, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellAuthorLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellCharacterLabel;



@end
