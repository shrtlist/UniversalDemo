//
//  EmployeeViewController.h
//  SquareDemo
//
//  Created by Marco Abundo on 1/11/12.
//  Copyright (c) 2012 Marco Abundo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"

@interface EmployeeViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Employee *employee;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearsEmployedLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@end
