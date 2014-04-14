//
//  compositionCellViewController.h
//  Phonoteka
//
//  Created by Джахангир on 12/02/14.
//  Copyright (c) 2014 Джахангир. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface compositionCellViewController : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgPlayPause;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *artist;
@property (strong, nonatomic) IBOutlet UILabel *duration;

@end
