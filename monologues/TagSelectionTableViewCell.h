//
//  TagSelectionTableViewCell.h
//  Yorick
//
//  Created by TerryTorres on 5/14/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagSelectionTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tagNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *synonymLabel;

@property (strong, nonatomic) IBOutlet UILabel *definitionLabel;

@end
