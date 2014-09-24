//
//  ShootStatusInputTableViewCell.h
//  ShootStudio
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerInputTableViewCell;

@interface PickerInputTableViewCell : UITableViewCell <UIKeyInput, UIPopoverPresentationControllerDelegate> {
	// For iPad, the view controller which will contain the popover displayed
    UIViewController *popoverViewController;

    // For iPhone
    UIToolbar *inputAccessoryView;
}

@property (nonatomic, strong) CustomUIPickerView *picker;

@end
