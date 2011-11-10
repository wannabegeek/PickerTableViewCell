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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

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
