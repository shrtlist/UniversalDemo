### UniversalDemo
A `CoreData` MDI app which consists of a master `UITableView` for displaying a list of employees using dynamic prototype cells, and a detail `UITableView` for displaying employee properties using static cells. A `UISplitViewController` is used in the iPad version to manage the master-detail interface. The `Employee` class defines five properties: name, job title, date of birth, number of years employed and photo.

![](http://i.imgur.com/OEJqeAT.png)

### Features:
- `UIStoryboard` used to define the application's user interface.
- `CoreData` is used to define the application’s data model.
- Deletion is supported in the master `UITableView`.
- Portrait and landscape mode are supported for both iPhone and iPad.
- An `NSFetchedResultsController` is used with batched fetching.
- Employee list is sorted by first name in ascending order.

### For the purposes of this demo:
- Cell selection is disabled in the detail `UITableView`
- Sample data is recreated by tapping the Refresh button.
- Sample data is fake.
- A single default photo is used.

### Build requirements
Xcode 7, iOS 9.0 SDK, Automated Reference Counting (ARC).

### Runtime requirements
iOS 9.0 and above

### License
The source code is available under the Apache License, Version 2.0

### Contributing
Forks, patches and other feedback are always welcome.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/shrtlist/universaldemo/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

