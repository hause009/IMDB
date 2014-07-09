//
//  SearchFilm.m
//  IMDB
//
//  Created by progforce on 21.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//

#import "SearchFilm.h"

#import "SearchObject.h"
#import "SearchCell.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "InfoFilm.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface SearchFilm ()

@property (nonatomic,retain) IBOutlet UISearchBar * searchBar;
@property (nonatomic,retain) NSString * SearchString;
@property (nonatomic,retain) NSIndexPath * Index;
@property (nonatomic,strong) NSArray* fetchedRecordsArray;
@property (nonatomic,retain) NSArray * resultArray;
@property SearchObject * Object;

@end
@implementation SearchFilm
@synthesize resultArray;
@synthesize searchBar;
@synthesize SearchString;
@synthesize table;

@synthesize Index;
@synthesize fetchedRecordsArray;

@synthesize Object;

//NavigationBar Hidden
-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [table reloadData];
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Searh";
    
    array = [[NSMutableArray alloc]init];
    searchBar.tintColor = [UIColor blackColor];
    searchBar.backgroundColor = [UIColor blackColor];
    
    UIColor * barCOLOR = [UIColor blackColor];
    UINavigationBar * Bar = [[self navigationController]navigationBar];
    Bar.translucent = NO;
    [Bar setTintColor:barCOLOR];
    
    Object = [SearchObject new];
    
    self.view.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:215/255.0f alpha:1.0f];
}

//processing of the search string
- (void)searchBarSearchButtonClicked:(UISearchBar *)activeSearchBar
{
    [activeSearchBar resignFirstResponder];
    SearchString = searchBar.text;
    SearchString = [Object VerifyingString:SearchString];
    
    __block BOOL Flag = [Object getFilm:SearchString categoryNamber:0];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (Flag == YES) {
            
            NSLog(@"%@",Object.ArrayID_film);
            
            for (int i = 0; i<[Object.ArrayID_film count] ;i++) {
                Flag = [Object getFilm:[NSString stringWithFormat:@"http://www.omdbapi.com/?i=%@",Object.ArrayID_film[i]] categoryNamber:1];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                array = Object.ArrayID_film;
                [table reloadData];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [array removeAllObjects];
                [table reloadData];
            });
        }
    });
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

//specified number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (array.count == 0)
    {
        [array addObject:@"nil"];
    }
    return array.count;
}

//ask autosize cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height=0;
    
    if (![array[0] isEqualToString:@"nil"])
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 289, 21)];
        label.text = [NSString stringWithFormat:@"%@",Object.ArrayPlot[indexPath.row]];
        label.numberOfLines = 0;
        [label sizeToFit];
        height = label.frame.size.height;
        NSLog(@"%f",label.frame.size.height);
    }
    
    return 240 + height;
}

//draw a cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Identifier = @"SearchCell";
    SearchCell *cell = (SearchCell *)[table dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([array[0] isEqualToString:@"nil"])
    {
        table.backgroundColor = [UIColor whiteColor];
        cell.title.hidden = YES;
        cell.country.hidden = YES;
        cell.image.hidden = YES;
        cell.Push.hidden = YES;
        cell.discription.hidden = YES;
        cell.viewCell.hidden = YES;
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(90, 100, 150, 22)];
        label.text = @"Nothing found";
        [cell.contentView addSubview:label];
    }
    else
    {
        table.backgroundColor = self.view.backgroundColor;
        cell.backgroundColor = table.backgroundColor;
        
        cell.discription.text = [NSString stringWithFormat:@"%@",Object.ArrayPlot[indexPath.row]];
        cell.discription.numberOfLines = 0;
        [cell.discription sizeToFit];
        
        cell.viewCell.frame = CGRectMake(cell.viewCell.frame.origin.x, cell.viewCell.frame.origin.y, cell.viewCell.frame.size.width, cell.discription.frame.origin.y + cell.discription.frame.size.height);
        [cell.viewCell.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [cell.viewCell.layer setBorderWidth: 1.0];
        
        cell.title.text = [Object.ArrayTitle objectAtIndex:indexPath.row];
        cell.country.text = [NSString stringWithFormat:@"%@ - %@",Object.ArrayCountry[indexPath.row],[Object.ArrayYear objectAtIndex:indexPath.row]];
        
        NSString * str = [NSString stringWithFormat:@"%@",Object.ArrayPoster[indexPath.row]];
        NSURL *url = [NSURL URLWithString:str];
        [cell.image setImageWithURL:url];
        cell.image.contentMode = UIViewContentModeScaleAspectFill;
        
        BOOL Flag = [Object VerifyingBookmarks:[Object.ArrayTitle objectAtIndex:indexPath.row]];
        
        if (Flag == YES) {
            
            UIImage * star = [UIImage imageNamed:@"star.png"];
            [cell.Push setImage:star forState:UIControlStateNormal];
        }
        else
        {
            cell.Push.hidden = YES;
        }
    }
    
    return cell;
}

//cell selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![array[0] isEqualToString:@"nil"])
    {
        [self performSegueWithIdentifier:@"SearchInfo" sender:self];
        [table deselectRowAtIndexPath:indexPath animated:YES];
    }
    return;
}

//transmit data InfoFilm
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SearchInfo"]) {
        NSIndexPath *indexPath = [self->table indexPathForSelectedRow];
        InfoFilm * vc = segue.destinationViewController;
        
        vc.Object = Object;
        vc.Index  = indexPath;
        
    }
}

@end
