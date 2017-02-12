/*
 * Copyright 2017 shrtlist.com
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

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext? = nil

    /// Fetched results controller
    var fetchedResultsController: NSFetchedResultsController<Employee> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }

        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController

        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return _fetchedResultsController!
    }

    private var _fetchedResultsController: NSFetchedResultsController<Employee>? = nil

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        // Load the sample data
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed

        super.viewWillAppear(animated)
    }

    // MARK: Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEmployee" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! EmployeeViewController
                _ = controller.view
                controller.employee = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: Deinitialization

    deinit {
        fetchedResultsController.delegate = nil
    }

    // MARK: Target-action method

    @IBAction func refresh() {
        loadData()
    }

    // MARK: UITableViewDataSource protocol conformance

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Get the employee from the fetchedResultsController
        let employee = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEmployee: employee)

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    /// Set cell properties with employee info
    fileprivate func configureCell(_ cell: UITableViewCell, withEmployee employee: Employee) {
        cell.textLabel?.text = employee.name
        cell.detailTextLabel?.text = employee.jobTitle

        // Create the UIImage from the employee photo data.
        guard let data = employee.photo as Data?, let image = UIImage(data: data) else { return }
        cell.imageView?.image = image
    }
}

extension MasterViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)!, withEmployee: anObject as! Employee)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)!, withEmployee: anObject as! Employee)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */
}

extension MasterViewController {
    // For this demo, repopulate the data store by deleting and recreating all Employee managed objects.
    func loadData() {
        let context = fetchedResultsController.managedObjectContext

        // Set up a fetch request to get all Employee managed objects
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()

        do {
            let result = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)

            // Delete all managed objects
            for employee in result {
                context.delete(employee as! NSManagedObject)
            }
        } catch let error as NSError {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        guard let image = UIImage(named: "icon-default-person") else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        // Create new managed objects
        let employee1 = Employee(context: context)
        employee1.name = "John Appleseed"
        employee1.jobTitle = "Software Engineer - iOS"
        employee1.dateOfBirth = dateFormatter.date(from: "01/26/1978")! as NSDate
        employee1.yearsEmployed = 1
        employee1.photo = UIImagePNGRepresentation(image) as NSData?

        let employee2 = Employee(context: context)
        employee2.name = "Ellen Roth"
        employee2.jobTitle = "Software Engineer - Android"
        employee2.dateOfBirth = dateFormatter.date(from: "04/15/1985")! as NSDate
        employee2.yearsEmployed = 3
        employee2.photo = UIImagePNGRepresentation(image) as NSData?

        let employee3 = Employee(context: context)
        employee3.name = "Zachary Wong"
        employee3.jobTitle = "Product Manager"
        employee3.dateOfBirth = dateFormatter.date(from: "11/04/1986")! as NSDate
        employee3.yearsEmployed = 2
        employee3.photo = UIImagePNGRepresentation(image) as NSData?

        let employee4 = Employee(context: context)
        employee4.name = "Cynthia Mala"
        employee4.jobTitle = "Project Manager"
        employee4.dateOfBirth = dateFormatter.date(from: "03/14/1989")! as NSDate
        employee4.yearsEmployed = 2
        employee4.photo = UIImagePNGRepresentation(image) as NSData?

        let employee5 = Employee(context: context)
        employee5.name = "John Ross"
        employee5.jobTitle = "Software Engineer - iOS"
        employee5.dateOfBirth = dateFormatter.date(from: "07/14/1972")! as NSDate
        employee5.yearsEmployed = 3
        employee5.photo = UIImagePNGRepresentation(image) as NSData?

        let employee6 = Employee(context: context)
        employee6.name = "Russ Joy"
        employee6.jobTitle = "Software Engineer - Android"
        employee6.dateOfBirth = dateFormatter.date(from: "05/24/1985")! as NSDate
        employee6.yearsEmployed = 3
        employee6.photo = UIImagePNGRepresentation(image) as NSData?

        let employee7 = Employee(context: context)
        employee7.name = "Suzy Chen"
        employee7.jobTitle = "Manager"
        employee7.dateOfBirth = dateFormatter.date(from: "07/14/1972")! as NSDate
        employee7.yearsEmployed = 3
        employee7.photo = UIImagePNGRepresentation(image) as NSData?

        let employee8 = Employee(context: context)
        employee8.name = "Vincent Dorn"
        employee8.jobTitle = "Software Engineer - iOS"
        employee8.dateOfBirth = dateFormatter.date(from: "07/22/1990")! as NSDate
        employee8.yearsEmployed = 1
        employee8.photo = UIImagePNGRepresentation(image) as NSData?

        let employee9 = Employee(context: context)
        employee9.name = "Srini Chagar"
        employee9.jobTitle = "Product Manager"
        employee9.dateOfBirth = dateFormatter.date(from: "08/01/1969")! as NSDate
        employee9.yearsEmployed = 3
        employee9.photo = UIImagePNGRepresentation(image) as NSData?

        let employee10 = Employee(context: context)
        employee10.name = "Lynn Hopi"
        employee10.jobTitle = "Software Engineer - Android"
        employee10.dateOfBirth = dateFormatter.date(from: "02/22/1978")! as NSDate
        employee10.yearsEmployed = 3
        employee10.photo = UIImagePNGRepresentation(image) as NSData?

        let employee11 = Employee(context: context)
        employee11.name = "Krista Venkata"
        employee11.jobTitle = "Product Manager"
        employee11.dateOfBirth = dateFormatter.date(from: "09/05/1986")! as NSDate
        employee11.yearsEmployed = 2
        employee11.photo = UIImagePNGRepresentation(image) as NSData?

        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

