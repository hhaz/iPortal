//
//  AppDelegate.h
//  SlideOutSideBar
//
//  Created by Hervé AZOULAY on 04/09/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSString *trxServerURL;
@property (nonatomic) Boolean defaultSaved;

@property (nonatomic,strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;

@property (nonatomic,strong) NSNumber *minAmount;
@property (nonatomic,strong) NSNumber *maxAmount;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

