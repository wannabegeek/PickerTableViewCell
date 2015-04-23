//
//  SimplePickerInputTableViewCell.m
//  PickerCellDemo
//
//  Created by Tom Fewster on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SimplePickerInputTableViewCell.h"

@implementation SimplePickerInputTableViewCell

@synthesize delegate;
// TODO- Recommend that this class is modified to attempt to have it not remember the state of the spinner selection.  This information should be available from self.detailTextLabel.text.
@synthesize value = _value;
@synthesize values = _values;

-(void)setValues:(NSArray *)newValues
{
    _values = [newValues copy];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeCommonElements];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeCommonElements];
    }
    return self;
}

- (void)initializeCommonElements {
    // Initialization code
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    // Default Values
    // TODO force user to pass in values in initialization method
    self.values = [NSArray arrayWithObjects:@"Value 1", @"Value 2", @"Value 3", @"Value 4", @"Value 5", nil];
    
}

- (void)setValue:(NSString *)v {
	_value = v;
	self.detailTextLabel.text = _value;
	[self.picker selectRow:[self.values indexOfObject:_value] inComponent:0 animated:YES];
    
    // Ensure the Picker can remember the last value selected even if the picker was rolling when closed
    int selectedRow = [self.values indexOfObject:_value];
    [self.picker setCurrentRow:selectedRow];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(CustomUIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(CustomUIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.values count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(CustomUIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.values objectAtIndex:row];
}

- (CGFloat)pickerView:(CustomUIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 44.0f;
}

- (CGFloat)pickerView:(CustomUIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 300.0f; //pickerView.bounds.size.width - 20.0f;
}

- (void)pickerView:(CustomUIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.value = [self.values objectAtIndex:row];

	if (delegate && [delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithValue:)]) {
		[delegate tableViewCell:self didEndEditingWithValue:self.value];
	}
}

@end
