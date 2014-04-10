/*
 * Copyright 2013 shrtlist.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "EmployeeViewController.h"

@interface EmployeeViewController () // Class extension
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsEmployedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation EmployeeViewController

#pragma mark - Managing the detail item

- (void)setEmployee:(Employee *)employee
{
    if (_employee != employee)
    {
        _employee = employee;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController)
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
        
        static NSDateFormatter *dateFormatter = nil;
        
        if (!dateFormatter)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterShortStyle;
        }

        NSString *dateOfBirth = [dateFormatter stringFromDate:[self.employee dateOfBirth]];
        
        self.dateOfBirthLabel.text = dateOfBirth;
        self.yearsEmployedLabel.text = [NSString stringWithFormat:@"%d", [self.employee yearsEmployed]];
        self.photoImageView.image = [UIImage imageWithData:[self.employee photo]];
    }
    else
    {
        [self clearView];
    }
    
    [self.tableView reloadData];
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

#pragma mark - UISplitViewControllerDelegate protocol conformance

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
