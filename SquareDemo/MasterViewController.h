//
//  MasterViewController.h
//  SquareDemo
//
//  Created by Marco Abundo on 1/11/12.
//  Copyright (c) 2013 shrtlist.com. All rights reserved.
//

@class EmployeeViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) EmployeeViewController *employeeViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
