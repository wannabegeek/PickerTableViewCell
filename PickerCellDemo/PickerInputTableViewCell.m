//
//  PickerInputTableViewCell.m
//  ShootStudio
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerInputTableViewCell.h"

@implementation PickerInputTableViewCell

@synthesize picker;

- (void)initalizeInputView {
	self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
	self.picker.showsSelectionIndicator = YES;
	self.picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	self.detailTextLabel.textColor = [UIColor darkTextColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UIViewController *popoverContent = [[UIViewController alloc] init];
		popoverContent.view = self.picker;
		popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
		popoverController.delegate = self;
	}
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

- (UIView *)inputView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		return self.picker;
	}
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

- (BOOL)becomeFirstResponder {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
		CGRect frame = self.picker.frame;
		frame.size = pickerSize;
		self.picker.frame = frame;
		popoverController.popoverContentSize = pickerSize;
		[popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		// resign the current first responder
		for (UIView *subview in self.superview.subviews) {
			if ([subview isFirstResponder]) {
				[subview resignFirstResponder];
			}
		}
		return NO;
	} else {
		[self.picker setNeedsLayout];
	}
	return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
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

- (void)deviceDidRotate:(NSNotification*)notification {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		// we should only get this call if the popover is visible
		[popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	} else {
		[self.picker setNeedsLayout];
	}
}

#pragma mark -
#pragma mark Respond to touch and become first responder.

- (BOOL)canBecomeFirstResponder {
	return YES;
}

#pragma mark -
#pragma mark UIKeyInput Protocol Methods

- (BOOL)hasText {
	return YES;
}

- (void)insertText:(NSString *)theText {
}

- (void)deleteBackward {
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate Protocol Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	UITableView *tableView = nil;
	if ([self.superview isKindOfClass:[UITableView class]]) {
		tableView = (UITableView *)self.superview;
	} else if ([self.superview.superview isKindOfClass:[UITableView class]]) {
		tableView = (UITableView *)self.superview.superview;
	}
	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
	[self resignFirstResponder];
}

@end
