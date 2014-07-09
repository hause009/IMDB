//
//  AppDelegate.h
//  IMDB
//
//  Created by progforce on 21.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmBase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;
-(NSArray *) getAllMovieRecords;
-(void) deleteTest:(FilmBase *)film;

@end
