//
//  CustomUIPickerView.m
//  PickerCellDemo
//
//  Created by Michael on 7/30/13.
//
//

#import "CustomUIPickerView.h"

@implementation CustomUIPickerView

@synthesize currentRow = _currentRow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)didMoveToSuperview{
	[self selectRow:self.currentRow inComponent:0 animated:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
