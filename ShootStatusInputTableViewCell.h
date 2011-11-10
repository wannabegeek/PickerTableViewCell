//
//  PickerTableViewCell.h
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerTableViewCell;

@protocol PickerTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(PickerTableViewCell *)cell didEndEditingWithPickerValue:(NSUInteger)value;
@end


@interface PickerTableViewCell : UITableViewCell <UIKeyInput, UIPickerViewDataSource, UIPickerViewDelegate> {
	NSUInteger pickerValue;
	UIPickerView *picker;
	id <PickerTableViewCellDelegate> delegate;
	NSArray *options;
}

@property (nonatomic, assign) NSUInteger pickerValue;
@property (nonatomic, retain) UIPickerView *picker;
@property (retain) id <PickerTableViewCellDelegate> delegate;

@end
