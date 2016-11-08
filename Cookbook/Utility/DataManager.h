//
//  DataManager.h
//  Cookbook
//
//  Created by Vladimir Psyukalov on 08.11.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>


@interface DataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedManager;

- (void)saveContext;

@end
