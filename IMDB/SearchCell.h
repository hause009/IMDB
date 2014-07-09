//
//  SearchCell.h
//  IMDB
//
//  Created by progforce on 21.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel * title;
@property (nonatomic,retain) IBOutlet UILabel * country;
@property (nonatomic,retain) IBOutlet UIButton * Push;

@property (nonatomic,retain) IBOutlet UILabel * discription;
@property (nonatomic,retain) IBOutlet UIImageView * image;
@property (nonatomic,retain) IBOutlet UIView * viewCell;
@end
