//
//  IntegerInputTableViewCell.m
//  InputTest
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IntegerInputTableViewCell.h"

@implementation IntegerInputTableViewCell

@synthesize numberValue;
@synthesize numberFormatter;
@synthesize delegate;
@synthesize lowerLimit;
@synthesize upperLimit;

@synthesize autocapitalizationType;
@synthesize autocorrectionType;
@synthesize enablesReturnKeyAutomatically;
@synthesize keyboardAppearance;
@synthesize keyboardType;
@synthesize returnKeyType;
@synthesize secureTextEntry;
@synthesize spellCheckingType;

- (void)initalizeInputView {
	// Initialization code
	self.keyboardType = UIKeyboardTypeNumberPad;
	self.lowerLimit = 0;
	self.upperLimit = UINT32_MAX;
	
	if (!self.numberFormatter) {
		self.numberFormatter = [[NSNumberFormatter alloc] init];
		self.numberFormatter.numberStyle = NSNumberFormatterNoStyle;
		self.numberFormatter.maximumFractionDigits = 0;
	}
	
	self.detailTextLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.numberValue]];
	self.detailTextLabel.textColor = [UIColor darkTextColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (UIView *)inputAccessoryView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		if (!inputAccessoryView) {
			inputAccessoryView = [[UIToolbar alloc] init];
			inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
			inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			[inputAccessoryView sizeToFit];
			CGRect frame = inputAccessoryView.frame;
			frame.size.height = 44.0f;
			inputAccessoryView.frame = frame;
			
			UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
			UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
			
			NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
			[inputAccessoryView setItems:array];
		}
		return inputAccessoryView;
	}
}

- (void)done:(id)sender {
	[self resignFirstResponder];
}

- (void)prepareForReuse {
	self.lowerLimit = 0;
	self.upperLimit = UINT32_MAX;
}

- (BOOL)resignFirstResponder {
	if (valueChanged && delegate && [delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithInteger:)]) {
		[delegate tableViewCell:self didEndEditingWithInteger:self.numberValue];
	}
	UITableView *tableView = nil;
	if ([self.superview isKindOfClass:[UITableView class]]) {
		tableView = (UITableView *)self.superview;
	} else if ([self.superview.superview isKindOfClass:[UITableView class]]) {
		tableView = (UITableView *)self.superview.superview;
	}
	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
	return [super resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	if (selected) {
		[self becomeFirstResponder];
		self.detailTextLabel.textColor = self.tintColor;
	} else {
		self.detailTextLabel.textColor = [UIColor darkTextColor];
	}
}

- (void)setNumberValue:(NSUInteger)value {
	numberValue = value;
	valueChanged = NO;
	self.detailTextLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.numberValue]];
}

#pragma mark -
#pragma mark Respond to touch and become first responder.

- (BOOL)canBecomeFirstResponder {
	return YES;
}

#pragma mark -
#pragma mark UIKeyInput Protocol Methods

- (BOOL)hasText {
	return (self.numberValue > 10);
}

- (void)insertText:(NSString *)theText {
	
	// make sure we receioved an integer (on the iPad a user chan change the keybord style)
	NSScanner *sc = [NSScanner scannerWithString:theText];
	if ([sc scanInteger:NULL]) {
		if ([sc isAtEnd]) {
			NSUInteger addedValues = [theText integerValue];
			
			self.numberValue *= (10 * theText.length);
			self.numberValue += addedValues;
			if (self.numberValue < self.lowerLimit) {
				self.numberValue = self.lowerLimit;
			} else if (self.numberValue > self.upperLimit) {
				self.numberValue = self.upperLimit;
			}
			self.detailTextLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.numberValue]];
			valueChanged = YES;
		}
	}	
}

- (void)deleteBackward {
	self.numberValue = self.numberValue / 10;	
	if (self.numberValue < self.lowerLimit) {
		self.numberValue = self.lowerLimit;
	} else if (self.numberValue > self.upperLimit) {
		self.numberValue = self.upperLimit;
	}
	self.detailTextLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.numberValue]];
	valueChanged = YES;
}

@end
