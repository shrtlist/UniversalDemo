### UniversalDemo
A `CoreData` MDI app which consists of a master `UITableView` for displaying a list of employees using dynamic prototype cells, and a detail `UITableView` for displaying employee properties using static cells. A `UISplitViewController` is used in the iPad version to manage the master-detail interface. The `Employee` class defines five properties: name, job title, date of birth, number of years employed and photo.


![universaldemo](https://cloud.githubusercontent.com/assets/723122/22867453/6612d9dc-f13d-11e6-811f-8fbc015b87dd.gif)

### Features:
- `UIStoryboard` used to define the application's user interface.
- `CoreData` is used to define the application’s data model.
- Deletion is supported in the master `UITableView`.
- Portrait and landscape mode are supported for both iPhone and iPad.
- An `NSFetchedResultsController` is used with batched fetching.
- Employee list is sorted by name in ascending order.

### For the purposes of this demo:
- Sample data is recreated by tapping the Refresh button.
- Sample data is fake.
- A single default photo is used.

### Build requirements
Xcode 8, iOS 10.0 SDK, Automated Reference Counting (ARC).

### Runtime requirements
iOS 10.0 and above

### License
The source code is available under the Apache License, Version 2.0

### Contributing
Forks, patches and other feedback are always welcome.