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

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsEmployedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end
