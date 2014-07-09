//
//  SearchObject.h
//  IMDB
//
//  Created by progforce on 21.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "FilmBase.h"

@interface SearchObject : NSObject

@property (nonatomic,strong) NSArray* fetchedRecordsArray;

@property (nonatomic,strong) NSMutableArray * ArrayTitle;
@property (nonatomic,strong) NSMutableArray * ArrayYear;
@property (nonatomic,strong)  NSMutableArray * ArrayID_film;
@property (nonatomic,strong)  NSMutableArray * ArrayRuntime;
@property (nonatomic,strong)  NSMutableArray * ArrayGenre;
@property (nonatomic,strong)  NSMutableArray * ArrayReleased;
@property (nonatomic,strong)  NSMutableArray * ArrayCountry;
@property (nonatomic,strong)  NSMutableArray * ArrayimdbRating;
@property (nonatomic,strong)  NSMutableArray * ArrayDirector;
@property (nonatomic,strong)  NSMutableArray * ArrayWriter;
@property (nonatomic,strong)  NSMutableArray * ArrayType;
@property (nonatomic,strong)  NSMutableArray * ArrayPoster;
@property (nonatomic,strong)  NSMutableArray * ArrayPlot;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property  AppDelegate * appDelegate;

-(NSString*)VerifyingString:(NSString*)str;
-(void)Save:(NSIndexPath*)index;
-(BOOL)VerifyingBookmarks:(NSString*)strTitle;
- (BOOL)getFilm:(NSString *)url categoryNamber:(int)Number;

@end


