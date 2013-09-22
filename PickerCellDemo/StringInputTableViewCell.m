//
//  StringInputTableViewCell.m
//  ShootStudio
//
//  Created by Tom Fewster on 19/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StringInputTableViewCell.h"

@implementation StringInputTableViewCell

@synthesize delegate;
@synthesize stringValue;
@synthesize textField;

- (void)initalizeInputView {
	// Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
	self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
	self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
	self.textField.textAlignment = UITextAlignmentRight;
	self.textField.textColor = [UIColor blueTextColor];
	self.textField.font = [UIFont systemFontOfSize:17.0f];
	self.textField.clearButtonMode = UITextFieldViewModeNever;
	self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self addSubview:self.textField];
	
	self.accessoryType = UITableViewCellAccessoryNone;
	
	self.textField.delegate = self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		[self initalizeInputView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self initalizeInputView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
		[self.textField becomeFirstResponder];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	if (selected) {
		[self.textField becomeFirstResponder];
	}
}

- (void)setStringValue:(NSString *)value {
	self.textField.text = value;
}

- (NSString *)stringValue {
	return self.textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (delegate && [delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithString:)]) {
		[delegate tableViewCell:self didEndEditingWithString:self.stringValue];
	}
	UITableView *tableView = [self findTableViewParent];
	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
}

-(UITableView *)findTableViewParent {
    
    UITableView *tableView = (UITableView *)self.superview;
    
    // In iOS7, the cell's superview is UITableViewWrapperView which does support indexPathForCell.
    // UITableViewWrapperView's superview is a UITableView (based on one test) currently.
    // Traverse up the UI change until we get to a UITableView or a UIWindow (root)
    while (![tableView isKindOfClass:[UITableView class]] && ![tableView isKindOfClass:[UIWindow class]]) {
        tableView = (UITableView *)tableView.superview;
    }
    
    // If we reached the root view, then there is an issue.
    if ([tableView isKindOfClass:[UIWindow class]]) {
        NSException* myException = [NSException
                                    exceptionWithName:@"UITableViewNotFoundException"
                                    reason:@"Unable to determine parent UITableView of cell. "
                                    userInfo:nil];
        @throw myException;
    }
    
    return tableView;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect editFrame = CGRectInset(self.contentView.frame, 10, 10);
	
	if (self.textLabel.text && [self.textLabel.text length] != 0) {
		CGSize textSize = [self.textLabel sizeThatFits:CGSizeZero];
		editFrame.origin.x += textSize.width + 10;
		editFrame.size.width -= textSize.width + 10;
		self.textField.textAlignment = UITextAlignmentRight;
	} else {
		self.textField.textAlignment = UITextAlignmentLeft;
	}
	
	self.textField.frame = editFrame;
}

@end
