//
//  InfoFilm.m
//  IMDB
//
//  Created by progforce on 22.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//

#import "InfoFilm.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "Bookmarks.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface InfoFilm ()
@property (nonatomic,strong)NSArray* fetchedRecordsArray;
@property (nonatomic,strong) UIActionSheet * actSheet;
@property AppDelegate* appDelegate;
@property int saveFilm;
@end

@implementation InfoFilm
@synthesize actSheet;

@synthesize ID_film;
@synthesize Labeltitle;
@synthesize Labelall;

@synthesize ImagePoster;
@synthesize Index;
@synthesize fetchedRecordsArray;
@synthesize ShareFilm;
@synthesize managedObjectContext;
@synthesize viewScrol;
@synthesize appDelegate;
@synthesize saveFilm;
@synthesize LabelRating,LabelDescription,LabelDirector,LabelShortDescription,LabelType,LabelWriter,starImage;
@synthesize Object;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    UINavigationBar * Bar = [[self navigationController]navigationBar];
    Bar.translucent = NO;
    
    appDelegate = [UIApplication sharedApplication].delegate;
    self.fetchedRecordsArray = [appDelegate getAllMovieRecords];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.title = [Object.ArrayTitle objectAtIndex:Index.row];
    
    //Printing data from a database
    if (ID_film != NULL)
    {
        FilmBase * record = [self.fetchedRecordsArray objectAtIndex:Index.row];
        self.title = record.title;
        Labeltitle.text = self.title;
        Labelall.text = [NSString stringWithFormat:@"%@ - %@ - %@ - (%@)",record.runtime,record.writers,record.year,record.country];
        LabelRating.text = [NSString stringWithFormat:@"Rating: %@",record.rating];
        LabelDirector.text = [NSString stringWithFormat:@"Director: %@",record.directors];
        LabelWriter.text = [NSString stringWithFormat:@"Writers: %@",record.writers];
        LabelType.text = [NSString stringWithFormat:@"Type: %@",record.type];
        LabelDescription.text = record.discription;
        NSString * str = [NSString stringWithFormat:@"%@",record.poster];
        NSURL *url = [NSURL URLWithString:str];
        [ImagePoster setImageWithURL:url];
        
        NSLog(@"%@",ShareFilm);
        NSLog(@"%@",Labeltitle.text);
        
        [self setBookmarks];
    }
    else {
        //outputs data during the transition from search
        Labeltitle.text = self.title;
        
        Labelall.text = [NSString stringWithFormat:@"%@ - %@ - %@ - (%@)",Object.ArrayRuntime[Index.row],Object.ArrayWriter[Index.row],Object.ArrayReleased[Index.row],Object.ArrayCountry[Index.row]];
        LabelRating.text = [NSString stringWithFormat:@"Rating: %@",Object.ArrayimdbRating[Index.row]];
        LabelDirector.text = [NSString stringWithFormat:@"Director: %@",Object.ArrayDirector[Index.row]];
        LabelWriter.text = [NSString stringWithFormat:@"Writers: %@",Object.ArrayWriter[Index.row]];
        LabelType.text = [NSString stringWithFormat:@"Type: %@",Object.ArrayType[Index.row]];
        LabelDescription.text = Object.ArrayPlot[Index.row];
        NSString * str = [NSString stringWithFormat:@"%@",Object.ArrayPoster[Index.row]];
        NSURL *url = [NSURL URLWithString:str];
        [ImagePoster setImageWithURL:url];
        
        BOOL Flag = [Object VerifyingBookmarks:Labeltitle.text];
        
        if (Flag == YES) {
            
            [self setBookmarks];
        }
        else
        {
            [self setBookmarksHidden];
        }
    }
    
    ShareFilm = self.title;
    
    Labeltitle.numberOfLines = 0;
    [Labeltitle sizeToFit];
    
    Labelall.frame = CGRectMake(Labelall.frame.origin.x, Labeltitle.frame.origin.y+Labeltitle.frame.size.height+5, Labelall.frame.size.width, Labelall.frame.size.height) ;
    Labelall.numberOfLines = 0;
    [Labelall sizeToFit];
    
    LabelRating.frame= CGRectMake(LabelRating.frame.origin.x, Labelall.frame.origin.y+Labelall.frame.size.height+5, LabelRating.frame.size.width, LabelRating.frame.size.height);
    
    LabelDirector.frame= CGRectMake(LabelDirector.frame.origin.x, LabelRating.frame.origin.y+LabelRating.frame.size.height, LabelDirector.frame.size.width, LabelDirector.frame.size.height);
    
    LabelWriter.frame= CGRectMake(LabelWriter.frame.origin.x, LabelDirector.frame.origin.y+LabelDirector.frame.size.height, LabelWriter.frame.size.width, LabelWriter.frame.size.height);
    
    LabelType.frame= CGRectMake(LabelType.frame.origin.x, LabelWriter.frame.origin.y+LabelWriter.frame.size.height, LabelType.frame.size.width, LabelType.frame.size.height);
    
    LabelShortDescription.frame= CGRectMake(LabelShortDescription.frame.origin.x, LabelType.frame.origin.y+LabelType.frame.size.height+5, LabelShortDescription.frame.size.width, LabelShortDescription.frame.size.height);
    
    LabelDescription.frame = CGRectMake(LabelDescription.frame.origin.x, LabelShortDescription.frame.origin.y+LabelShortDescription.frame.size.height, LabelDescription.frame.size.width, LabelDescription.frame.size.height);
    LabelDescription.numberOfLines = 0;
    [LabelDescription sizeToFit];
    
    ImagePoster.frame = CGRectMake(ImagePoster.frame.origin.x, LabelDescription.frame.origin.y+LabelDescription.frame.size.height+5, ImagePoster.frame.size.width, ImagePoster.frame.size.height);
    
    [viewScrol setContentSize:CGSizeMake(320, ImagePoster.frame.size.height+ImagePoster.frame.origin.y+20)];
}

//Bookmarks icon set
-(void)setBookmarks
{
    saveFilm=1;
    starImage.hidden = NO;
    UIImage * star = [UIImage imageNamed:@"star.png"];
    starImage.image = star;
}

//hide icon Bookmarks
-(void)setBookmarksHidden
{
    starImage.hidden = YES;
    saveFilm = 0;
}

-(IBAction)Action:(id)sender
{
    
    if (saveFilm == 1)
    {
        actSheet = [[UIActionSheet alloc] initWithTitle:nil
                                               delegate:self
                                      cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:@"Twitter share",@"Facebook share",@"Email share",@"Remove Bookmark",nil];
    }
    else
    {
        actSheet = [[UIActionSheet alloc] initWithTitle:nil
                                               delegate:self
                                      cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:@"Twitter share",@"Facebook share",@"Email share",@"Add to Bookmarks",nil];
    }
    actSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actSheet showFromTabBar:[[self tabBarController] tabBar]];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {//Twitter share
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Twitter share"];
        [tweetSheet addURL:[NSURL URLWithString:ShareFilm]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {//Facebook share
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"Facebook share"];
        [controller addURL:[NSURL URLWithString:ShareFilm]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else if (buttonIndex == 2)
    {//Email share
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Subject"];
        [controller setMessageBody:ShareFilm isHTML:NO];
        if (controller) [self presentViewController:controller animated:YES completion:NULL];
    }
    else if (buttonIndex == 3)
    {
        //remove bookmark
        if (saveFilm == 1)
        {
            int index=0;
            if (Object.ArrayID_film.count != 0) {
                
                fetchedRecordsArray = [appDelegate getAllMovieRecords];
                
                NSMutableArray * ArrayTitle = [NSMutableArray new];
                for (int i=0; i<[fetchedRecordsArray count]; i++)
                {
                    FilmBase * record = [fetchedRecordsArray objectAtIndex:i];
                    NSLog(@"%@",record.title);
                    [ArrayTitle addObject:record.title];
                }
                NSLog(@"%@",ArrayTitle);
                
                
                if ([ArrayTitle containsObject:[Object.ArrayTitle objectAtIndex:Index.row]])
                {
                    NSLog(@"Found");
                    index = [ArrayTitle indexOfObject:[Object.ArrayTitle objectAtIndex:Index.row]];
                    
                }
            }
            else
            {
                index = Index.row;
            }
            
            FilmBase * record = [self.fetchedRecordsArray objectAtIndex:index];
            [appDelegate deleteTest:record];
            [self setBookmarksHidden];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            //verification the names in the database and Save Movie
            [Object Save:Index];
            [self setBookmarks];
            
        }
    }
}

///email
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
