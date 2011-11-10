//
//  ViewController.h
//  PickerCellDemo
//
//  Created by Tom Fewster on 09/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateInputTableViewCell.h"
#import "StringInputTableViewCell.h"
#import "IntegerInputTableViewCell.h"
#import "SimplePickerInputTableViewCell.h"

@interface ViewController : UITableViewController <DateInputTableViewCellDelegate, StringInputTableViewCellDelegate, IntegerInputTableViewCellDelegate, SimplePickerInputTableViewCellDelegate>

@property (weak) IBOutlet DateInputTableViewCell *date1;
@property (weak) IBOutlet DateInputTableViewCell *date2;

@end
