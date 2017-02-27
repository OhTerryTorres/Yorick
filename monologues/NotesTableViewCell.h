//
//  NotesTableViewCell.h
//  Yorick
//
//  Created by TerryTorres on 2/20/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YorickStyle.h"

@interface NotesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *characterLabel;

@property (weak, nonatomic) IBOutlet UILabel *notesLabel;

@end
