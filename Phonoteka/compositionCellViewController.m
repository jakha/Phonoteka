//
//  compositionCellViewController.m
//  Phonoteka
//
//  Created by Джахангир on 12/02/14.
//  Copyright (c) 2014 Джахангир. All rights reserved.
//

#import "compositionCellViewController.h"

@implementation compositionCellViewController

@synthesize artist = _artist;
@synthesize imgPlayPause = _imgPlayPause;
@synthesize title = _title;
@synthesize duration = _duration;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
