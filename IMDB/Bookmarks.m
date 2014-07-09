//
//  Bookmarks.m
//  IMDB
//
//  Created by progforce on 22.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//

#import "Bookmarks.h"
#import "SearchObject.h"

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "FilmBase.h"
#import "SearchCell.h"
#import <QuartzCore/QuartzCore.h>
#import "InfoFilm.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface Bookmarks ()
@property (nonatomic,retain) NSDictionary * SaveFilms;
@property (nonatomic,strong)NSArray* fetchedRecordsArray;
@property (retain,nonatomic) UIButton * ButtonClick;
@property AppDelegate * appDelegate;
@end

@implementation Bookmarks
@synthesize table;
@synthesize Index;
@synthesize managedObjectContext;
@synthesize fetchedRecordsArray, appDelegate;
@synthesize SaveFilms;
@synthesize ButtonClick;

-(void) viewDidAppear:(BOOL)animated
{
    [self UpdateTable];
}

//table update
-(void) UpdateTable
{
    appDelegate = [UIApplication sharedApplication].delegate;
    self.fetchedRecordsArray = [appDelegate getAllMovieRecords];
    self.managedObjectContext = appDelegate.managedObjectContext;
    [table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Bookmarks";
    array = [[NSMutableArray alloc]init];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:215/255.0f alpha:1.0f];
}

//specified number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedRecordsArray count];
}

//ask autosize cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilmBase * record = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 291, 21)];
    label.text = [NSString stringWithFormat:@"%@",record.discription];
    label.numberOfLines = 0;
    [label sizeToFit];
    NSLog(@"%@",label.text);
    NSLog(@"%f",label.frame.size.height);
    
    return  240+label.frame.size.height;
}

//draw a cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SearchCell";
    SearchCell *cell = (SearchCell *)[table dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    table.backgroundColor = self.view.backgroundColor;
    cell.backgroundColor = table.backgroundColor;
    
    FilmBase * record = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
    
    cell.discription.text = [NSString stringWithFormat:@"%@",record.discription];
    cell.discription.numberOfLines = 0;
    [cell.discription sizeToFit];
    
    cell.viewCell.frame = CGRectMake(cell.viewCell.frame.origin.x, cell.viewCell.frame.origin.y, cell.viewCell.frame.size.width, cell.discription.frame.origin.y + cell.discription.frame.size.height);
    [cell.viewCell.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [cell.viewCell.layer setBorderWidth: 1.0];
    
    cell.title.text = record.title;
    cell.country.text = [NSString stringWithFormat:@"%@",record.year];
    
    cell.title.text = record.title;
    cell.country.text = [NSString stringWithFormat:@"%@ - %@",record.country,record.year];
    NSString * str = [NSString stringWithFormat:@"%@",record.poster];
    NSURL *url = [NSURL URLWithString:str];
    [cell.image setImageWithURL:url];
    cell.image.contentMode = UIViewContentModeScaleAspectFill;
    
    [ButtonClick addTarget:self action:@selector(DeleteFilm:)forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

//cell selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"SearchInfo2" sender:self];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    return;
}

//transmit data InfoFilm
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SearchInfo2"]) {
        
        NSIndexPath *indexPath = [self->table indexPathForSelectedRow];
        InfoFilm * destViewController = segue.destinationViewController;
        destViewController.Index = indexPath;
        destViewController.ID_film = @"YES";
    }
}



@end
