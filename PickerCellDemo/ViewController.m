//
//  ViewController.m
//  PickerCellDemo
//
//  Created by Tom Fewster on 09/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize date1;
@synthesize date2;

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - TableView Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

	switch (indexPath.section) {
		case 1:
		{
			if (indexPath.row == 0) {
				SimplePickerInputTableViewCell *spitvc = (SimplePickerInputTableViewCell *)cell;
				NSArray *array = @[@"Value 1", @"Value 2", @"Value 3", @"Value 4", @"Value 5"];

				[spitvc setup:array selectedRow:0];
				[spitvc setValue:@"Value 2"];
			}
			else if (indexPath.row == 1) {
				SimplePickerInputTableViewCell *spitvc = (SimplePickerInputTableViewCell *)cell;
				NSArray *array = @[@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];

				[spitvc setup:array selectedRow:0];
				[spitvc setValue:@"5"];
			}
			else if (indexPath.row == 2) {
				SimplePickerInputTableViewCell *spitvc = (SimplePickerInputTableViewCell *)cell;
				NSArray *array = @[@"1", @"2", @"3", @"4", @"5"];

				[spitvc setup:array selectedRow:0];
				[spitvc setValue:@"3"];
			}

			break;
		}
	}

	return cell;
}

#pragma mark - Delegates

- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value {
	NSLog(@"%@ date changed to: %@", cell.textLabel.text, value);
}

- (void)tableViewCell:(IntegerInputTableViewCell *)cell didEndEditingWithInteger:(NSUInteger)value {
	NSLog(@"%@ number changed to: %i", cell.textLabel.text, value);
}

- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value {
	NSLog(@"%@ string changed to: '%@'", cell.textLabel.text, value);
}

- (void)tableViewCell:(SimplePickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value {
	NSLog(@"%@ changed to: %@", cell.textLabel.text, value);
}

@end
