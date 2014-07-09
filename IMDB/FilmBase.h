//
//  FilmBase.h
//  IMDB
//
//  Created by progforce on 22.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FilmBase : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * directors;
@property (nonatomic, retain) NSString * discription;
@property (nonatomic, retain) NSString * genres;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * poster;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) NSString * runtime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * writers;
@property (nonatomic, retain) NSString * year;

@end
