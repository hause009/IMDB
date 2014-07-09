//
//  SearchObject.m
//  IMDB
//
//  Created by progforce on 21.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//

#import "SearchObject.h"
#import "SearchCell.h"
#import "AppDelegate.h"

#import "SBJson.h"

@interface SearchObject ()
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;


@end

@implementation SearchObject
{
    NSDictionary *ServiceResponse;
}

@synthesize fetchedRecordsArray;
@synthesize ArrayTitle, ArrayYear, ArrayID_film, ArrayRuntime, ArrayGenre, ArrayReleased, ArrayCountry, ArrayimdbRating, ArrayDirector, ArrayWriter, ArrayType,ArrayPoster, ArrayPlot;
@synthesize appDelegate;
@synthesize managedObjectContext;

- (id)init
{
    self = [super init];
    ServiceResponse = @{};
    
    return self;
}

//send request to the server
- (BOOL)getFilm:(NSString *)url categoryNamber:(int)Number
{
    BOOL flag;
    NSURL *urlRequest = [NSURL URLWithString:url];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:urlRequest cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    theRequest.HTTPMethod = @"GET";
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse* response;
    NSError* error;
    
    NSData * Data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    NSString *result = [[NSString alloc]initWithData:Data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",result);
    
    if (Number == 0) {
        flag = [self parseServiceResponseID:Data];
    }
    else {
        [self parseServiceResponseFilms:Data];
        flag = YES;
    }
    return flag;
}

//replace spaces
-(NSString*)VerifyingString:(NSString *)str
{
    NSString * firstString = @" ";
    NSRange range = [str rangeOfString:firstString];
    NSLog(@"%d, %d", range.location, range.length);
    
    if (range.length != 0)
    {
        NSArray * array1 = [str componentsSeparatedByString:@" "];
        str = [array1 componentsJoinedByString:@"%20"];
    }
    str = [NSString stringWithFormat:@"http://www.omdbapi.com/?s=%@",str];
    return str;
}

//parse id movies
-(BOOL)parseServiceResponseID:(NSData*)data
{
    BOOL flag;
    NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",result);
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
    ServiceResponse = [jsonParser objectWithString:result error:NULL];
    
    ArrayTitle = [NSMutableArray new];
    ArrayYear = [NSMutableArray new];
    ArrayID_film = [NSMutableArray new];
    ArrayRuntime = [NSMutableArray new];
    ArrayGenre = [NSMutableArray new];
    ArrayReleased = [NSMutableArray new];
    ArrayCountry = [NSMutableArray new];
    ArrayimdbRating = [NSMutableArray new];
    ArrayDirector = [NSMutableArray new];
    ArrayWriter = [NSMutableArray new];
    ArrayType = [NSMutableArray new];
    ArrayPoster = [NSMutableArray new];
    ArrayPlot = [NSMutableArray new];
    
    NSArray * arr = ServiceResponse[@"Search"];
    if (arr)
    {
        for (int i = 0; i<[arr count]; i++) {
            NSDictionary * dic = arr[i];
            
            [ArrayID_film addObject:dic[@"imdbID"]];
        }
        flag = YES;
    }
    else
    {
        flag = NO;
        NSLog(@"%@", arr);
    }
    
    return flag;
}

//parse information about movies
-(void)parseServiceResponseFilms:(NSData*)data
{
    NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",result);
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
    ServiceResponse = [jsonParser objectWithString:result error:NULL];
    
    NSDictionary * arr = ServiceResponse;
    
    [ArrayTitle addObject:arr[@"Title"]];
    [ArrayYear addObject:arr[@"Year"]];
    [ArrayRuntime addObject:arr[@"Runtime"]];
    [ArrayGenre addObject:arr[@"Genre"]];
    [ArrayReleased addObject:arr[@"Released"]];
    [ArrayCountry addObject:arr[@"Country"]];
    [ArrayimdbRating addObject:arr[@"imdbRating"]];
    [ArrayDirector addObject:arr[@"Director"]];
    [ArrayWriter addObject:arr[@"Writer"]];
    [ArrayType addObject:arr[@"Type"]];
    [ArrayPoster addObject:arr[@"Poster"]];
    [ArrayPlot addObject:arr[@"Plot"]];
    
    NSLog(@"%@", ArrayPlot);
    NSLog(@"%@", ArrayTitle);
    NSLog(@"%@", ArrayYear);
    NSLog(@"%@", ArrayID_film);
    NSLog(@"%@", ArrayDirector);
}

//check the availability of the film in the database
-(BOOL)VerifyingBookmarks:(NSString *)strTitle
{
    BOOL Flag;
    appDelegate = [UIApplication sharedApplication].delegate;
    fetchedRecordsArray = [appDelegate getAllMovieRecords];
    
    NSMutableArray * ArrayTitle2 = [NSMutableArray new];
    for (int i=0; i<[fetchedRecordsArray count]; i++)
    {
        FilmBase * record = [fetchedRecordsArray objectAtIndex:i];
        NSLog(@"%@",record.title);
        [ArrayTitle2 addObject:record.title];
    }
    NSLog(@"%@",ArrayTitle2);
    
    if([ArrayTitle2 containsObject:strTitle])
    {
        NSLog(@"Yes");
        Flag = YES;
    }
    else
    {
        Flag = NO;
    }
    
    return Flag;
}

//save film
-(void)Save:(NSIndexPath *)index
{
    appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchedRecordsArray = [appDelegate getAllMovieRecords];
    
    //verification the names in the database
    NSMutableArray * ArrayTitleBase = [NSMutableArray new];
    for (int i=0; i<[fetchedRecordsArray count]; i++)
    {
        FilmBase * record = [self.fetchedRecordsArray objectAtIndex:i];
        NSLog(@"%@",record.title);
        [ArrayTitleBase addObject:record.title];
    }
    
    if([ArrayTitleBase containsObject:[ArrayTitle objectAtIndex:index.row]])
    {
        NSLog(@"Yes");
    }
    else
    {
        NSLog(@"N0");
        FilmBase * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"FilmBase"
                                                            inManagedObjectContext:self.managedObjectContext];
        
        newEntry.year = ArrayReleased[index.row];
        newEntry.title = [ArrayTitle objectAtIndex:index.row];
        newEntry.runtime = ArrayRuntime[index.row];
        newEntry.directors = ArrayDirector[index.row];
        newEntry.discription = ArrayPlot[index.row];
        newEntry.country = ArrayCountry[index.row];
        newEntry.rating = ArrayimdbRating[index.row];
        newEntry.type = ArrayType[index.row];
        newEntry.poster = ArrayPoster[index.row];
        newEntry.writers = ArrayWriter[index.row];
        
        
        NSError *error;
        
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"couldn't save: %@", [error localizedDescription]);
        }
    }
}


@end
