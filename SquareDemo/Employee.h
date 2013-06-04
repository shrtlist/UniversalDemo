//
//  Employee.h
//  SquareDemo
//
//  Created by Marco Abundo on 1/11/12.
//  Copyright (c) 2013 shrtlist.com. All rights reserved.
//

#import <CoreData/CoreData.h>

/*
 * Employee managed object class which defines five properties:
 * name, job title, date of birth, number of years employed, and photo. 
 */
@interface Employee : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSDate *dateOfBirth;
@property (nonatomic, strong) NSNumber *yearsEmployed;
@property (nonatomic, strong) NSData *photo;

@end
