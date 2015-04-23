//
//  PickerInputTableViewCell.m
//  ShootStudio
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerInputTableViewCell.h"

@implementation PickerInputTableViewCell

static const float kAccessoryViewHeight = 44.0;

@synthesize picker;

- (void)initalizeInputView {
	self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
	self.picker.showsSelectionIndicator = YES;
	self.picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	self.detailTextLabel.textColor = [UIColor darkTextColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
        // Setup the popover's view controller
        popoverViewController = [[UIViewController alloc] init];
		popoverViewController.view = self.picker;
        popoverViewController.modalPresentationStyle = UIModalPresentationPopover;

        // Setup the delegate for UIPopoverPresentationControllerDelegate to ensure the following method
        //   to be called which will ensure that the popover is always displayed halfway across the width
        //   of the table view cell:
        //   - (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController
        //             willRepositionPopoverToRect:(inout CGRect *)rect
        //                                  inView:(inout UIView **)view
        popoverViewController.popoverPresentationController.delegate = self;
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
			frame.size.height = kAccessoryViewHeight;
			inputAccessoryView.frame = frame;
			
			UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
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
        [self displayPopover];
            
        // Resign the current first responder
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // To handle duplicate calls to this method which appear to happen when selecting a table view cell on iPad.
    //   https://stackoverflow.com/questions/5401226/uitableviewcell-selector-setselectedanimated-gets-called-many-times
    //
    // The resulting two calls to [self becomeFirstResponder] cause an app crash as the code attempts to draw two popovers
    if (self.selected == selected) {
        return;
    }
    
    [super setSelected:selected animated:animated];
	
    if (selected) {
		[self becomeFirstResponder];
		self.detailTextLabel.textColor = self.tintColor;
	} else {
		self.detailTextLabel.textColor = [UIColor darkTextColor];
	}
}

- (void)deviceDidRotate:(NSNotification *)notification {
	

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // No additional logic needed as UIKit will redraw popover and the following method is used to ensure proper location
        //   - (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController
        //             willRepositionPopoverToRect:(inout CGRect *)rect
        //                                  inView:(inout UIView **)view
    } else {
		[self.picker setNeedsLayout];
	}
}

- (void)displayPopover {
    CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
    
    popoverViewController.preferredContentSize = pickerSize;
    
    UITableView *tableView = [self findTableViewParent];
    
    UITableViewController *tableViewController = (UITableViewController *)tableView.dataSource;
    
    [tableViewController presentViewController:popoverViewController animated:YES completion:nil];
    
    // Get the popover presentation controller and configure it.
    UIPopoverPresentationController *presentationController = [popoverViewController popoverPresentationController];
    presentationController.sourceView = self;
    
    // Position the popover to be halfway across the table view cell
    presentationController.sourceRect  = CGRectMake(self.frame.size.width / 2, self.frame.size.height, 0, 0);
}

#pragma mark -
#pragma  mark UIPopoverPresentationControllerDelegate Protocol Methods

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController
          willRepositionPopoverToRect:(inout CGRect *)rect
                               inView:(inout UIView **)view {
    
    // Reposition the popover to be halfway across the table view cell
    *rect = CGRectMake(self.frame.size.width / 2, self.frame.size.height, 0, 0);
}

// Not sure why this is needed.  App appears to works correctly w/o it
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    // Code that the GitHub Repository did not use my solution in the below find and used the commented out code
    UITableView *tableView = [self findTableViewParent];
    /*
     UITableView *tableView = nil;
     if ([self.superview isKindOfClass:[UITableView class]]) {
     tableView = (UITableView *)self.superview;
     } else if ([self.superview.superview isKindOfClass:[UITableView class]]) {
     tableView = (UITableView *)self.superview.superview;
     }
     */
    [tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
    [self resignFirstResponder];
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

@end
