//
//  EmployeeViewController.m
//  SquareDemo
//
//  Created by Marco Abundo on 1/11/12.
//  Copyright (c) 2012 Marco Abundo. All rights reserved.
//

#import "EmployeeViewController.h"

@interface EmployeeViewController () // Class extension
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsEmployedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;
@end

@implementation EmployeeViewController

@synthesize employee = _employee;
@synthesize nameLabel;
@synthesize jobTitleLabel;
@synthesize dateOfBirthLabel;
@synthesize yearsEmployedLabel;
@synthesize photoImageView;

@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item

- (void)setEmployee:(Employee *)employee
{
    if (_employee != employee) {
        _employee = employee;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)clearView
{
    self.nameLabel.text = nil;
    self.jobTitleLabel.text = nil;
    self.dateOfBirthLabel.text = nil;
    self.yearsEmployedLabel.text = nil;
    self.photoImageView.image = nil;
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.employee)
    {
        self.nameLabel.text = [self.employee name];
        self.jobTitleLabel.text = [self.employee jobTitle];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        NSString *dateOfBirth = [dateFormat stringFromDate:[self.employee dateOfBirth]];
        
        self.dateOfBirthLabel.text = dateOfBirth;
        self.yearsEmployedLabel.text = [[self.employee yearsEmployed] stringValue];
        self.photoImageView.image = [UIImage imageWithData:[self.employee photo]];
    }
    else
    {
        [self clearView];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        return YES;
    }
}

#pragma mark - UISplitViewControllerDelegate conformance

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Employees", @"Employees");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
