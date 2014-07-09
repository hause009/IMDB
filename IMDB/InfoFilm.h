//
//  InfoFilm.h
//  IMDB
//
//  Created by progforce on 22.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import "SearchObject.h"

@interface InfoFilm : UIViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,retain)  NSString *  ID_film;
@property (nonatomic,retain)  NSString *  ShareFilm;
@property IBOutlet UILabel * Labeltitle;
@property IBOutlet UILabel * Labelall;
@property IBOutlet UIImageView * ImagePoster;
@property IBOutlet UILabel * LabelRating;
@property IBOutlet UILabel * LabelDirector;
@property IBOutlet UILabel * LabelWriter;
@property IBOutlet UILabel * LabelType;
@property IBOutlet UILabel * LabelShortDescription;
@property IBOutlet UILabel * LabelDescription;

@property IBOutlet UIImageView * starImage;


@property IBOutlet UIScrollView * viewScrol;
@property (nonatomic,retain) NSIndexPath * Index;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
-(IBAction)Action:(id)sender;

@property SearchObject * Object;
@end
