//
//  EmployeeViewController.h
//  SquareDemo
//
//  Created by Marco Abundo on 1/11/12.
//  Copyright (c) 2013 shrtlist.com. All rights reserved.
//

#import "Employee.h"

@interface EmployeeViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Employee *employee;

@end
