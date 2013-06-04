//
//  MasterViewController.m
//  SquareDemo
//
//  Created by Marco Abundo on 1/11/12.
//  Copyright (c) 2013 shrtlist.com. All rights reserved.
//

#import "MasterViewController.h"
#import "EmployeeViewController.h"
#import "Employee.h"

@interface MasterViewController () // Class extension
- (IBAction)refresh;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)loadData;
@end

@implementation MasterViewController

@synthesize employeeViewController = _employeeViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    self.employeeViewController = (EmployeeViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    // Load the sample data
    [self loadData];

    // Set up the Edit bar button item.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    // Set our fetchedResultsController to nil
    self.fetchedResultsController = nil;

    [super viewDidUnload];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check the segue identifier
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Employee *employee = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setEmployee:employee];
    }
}

#pragma mark - Memory management

- (void)dealloc
{
    self.fetchedResultsController.delegate = nil;
}

#pragma mark - Target-action method

- (IBAction)refresh
{
    [self loadData];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Sort by name in ascending order.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    
    // Set ourselves as delegate
    aFetchedResultsController.delegate = self;
    
    self.fetchedResultsController = aFetchedResultsController;
    
    // Perform the fetch
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    NSLog(@"Fetch error %@, %@", error, [error userInfo]);
	}
    
    return __fetchedResultsController;
}

#pragma mark - UITableViewDataSource protocol conformance

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];

    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
            NSLog(@"Save error %@, %@", error, [error userInfo]);
        }
        
        [self.employeeViewController setEmployee:nil];
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        Employee *employee = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        // Set the employee to be displayed by the employeeViewController
        self.employeeViewController.employee = employee;    
    }
}

#pragma mark - NSFetchedResultsControllerDelegate protocol conformance

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Get the employee from the fetchedResultsController
    Employee *employee = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Set the cell labels with employee info
    cell.textLabel.text = employee.name;
    cell.detailTextLabel.text = employee.jobTitle;
    
    // Create the UIImage from the employee photo data.
    UIImage *image = [UIImage imageWithData:employee.photo];

    cell.imageView.image = image;
}

#pragma mark - Data load

// For this demo, repopulate the data store by deleting and recreating all Employee managed objects.
- (void)loadData
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    // Set up a fetch request to get all Employee managed objects
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Employee" inManagedObjectContext:context]];
    
    NSArray *result = [context executeFetchRequest:fetch error:nil];
    
    // Delete all managed objects
    for (Employee *employee in result)
    {
        [context deleteObject:employee];
    }
    
    UIImage *image = [UIImage imageNamed:@"icon-default-person.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
    // Create new managed objects
    
    Employee *employee1 = (Employee *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee1.name = @"John Appleseed";
    employee1.jobTitle = @"Software Engineer - iOS";
    employee1.dateOfBirth = [dateFormat dateFromString:@"01/26/1978"];
    employee1.yearsEmployed = [NSNumber numberWithInt:1];
    employee1.photo = imageData;
    
    Employee *employee2 = (Employee *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee2.name = @"Ellen Roth";
    employee2.jobTitle = @"Software Engineer - Android";
    employee2.dateOfBirth = [dateFormat dateFromString:@"04/15/1985"];
    employee2.yearsEmployed = [NSNumber numberWithInt:3];
    employee2.photo = imageData;
    
    Employee *employee3 = (Employee *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee3.name = @"Zachary Wong";
    employee3.jobTitle = @"Product Manager";
    employee3.dateOfBirth = [dateFormat dateFromString:@"11/04/1986"];
    employee3.yearsEmployed = [NSNumber numberWithInt:2];
    employee3.photo = imageData;
    
    Employee *employee4 = (Employee *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee4.name = @"Cynthia Mala";
    employee4.jobTitle = @"Project Manager";
    employee4.dateOfBirth = [dateFormat dateFromString:@"03/14/1989"];
    employee4.yearsEmployed = [NSNumber numberWithInt:2];
    employee4.photo = imageData;

    Employee *employee5 = (Employee *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee5.name = @"John Ross";
    employee5.jobTitle = @"Software Engineer - iOS";
    employee5.dateOfBirth = [dateFormat dateFromString:@"07/14/1972"];
    employee5.yearsEmployed = [NSNumber numberWithInt:3];
    employee5.photo = imageData;
    
    Employee *employee6 = (Employee *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee6.name = @"Russ Joy";
    employee6.jobTitle = @"Software Engineer - Android";
    employee6.dateOfBirth = [dateFormat dateFromString:@"05/24/1985"];
    employee6.yearsEmployed = [NSNumber numberWithInt:3];
    employee6.photo = imageData;
    
    Employee *employee7 = (Employee *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee7.name = @"Suzy Chen";
    employee7.jobTitle = @"Manager";
    employee7.dateOfBirth = [dateFormat dateFromString:@"07/14/1972"];
    employee7.yearsEmployed = [NSNumber numberWithInt:3];
    employee7.photo = imageData;
    
    Employee *employee8 = (Employee *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee8.name = @"Vincent Dorn";
    employee8.jobTitle = @"Software Engineer - iOS";
    employee8.dateOfBirth = [dateFormat dateFromString:@"07/22/1990"];
    employee8.yearsEmployed = [NSNumber numberWithInt:1];
    employee8.photo = imageData;
    
    Employee *employee9 = (Employee *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee9.name = @"Srini Chagar";
    employee9.jobTitle = @"Product Manager";
    employee9.dateOfBirth = [dateFormat dateFromString:@"08/01/1969"];
    employee9.yearsEmployed = [NSNumber numberWithInt:3];
    employee9.photo = imageData;
    
    Employee *employee10 = (Employee *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee10.name = @"Lynn Hopi";
    employee10.jobTitle = @"Software Engineer - Android";
    employee10.dateOfBirth = [dateFormat dateFromString:@"02/22/1978"];
    employee10.yearsEmployed = [NSNumber numberWithInt:3];
    employee10.photo = imageData;
    
    Employee *employee11 = (Employee *)[NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee11.name = @"Krista Venkata";
    employee11.jobTitle = @"Product Manager";
    employee11.dateOfBirth = [dateFormat dateFromString:@"09/05/1986"];
    employee11.yearsEmployed = [NSNumber numberWithInt:2];
    employee11.photo = imageData;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Save error %@, %@", error, [error userInfo]);
    }
}

@end
