//
//  PhonotekaViewController.h
//  Phonoteka
//
//  Created by Джахангир on 12/02/14.
//  Copyright (c) 2014 Джахангир. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhonotekaViewController : UITableViewController

@property (retain, nonatomic) NSMutableArray *items;

-(void) loadSettings;

@end
