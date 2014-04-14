//
//  PhonotekaViewController.m
//  Phonoteka
//
//  Created by Джахангир on 12/02/14.
//  Copyright (c) 2014 Джахангир. All rights reserved.
//

#import "PhonotekaViewController.h"
#import "vkLoginViewController.h"
#import "compositionCellViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "JSONKit.h"

@interface PhonotekaViewController ()

@end

@implementation PhonotekaViewController
{
    NSMutableArray *URLOfSounds;
    NSString *accessToken, *user_id;
}
@synthesize items = _items;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadSettings];
    [self updateTableView:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadSettings
{
    NSUserDefaults *resultDef = [NSUserDefaults standardUserDefaults];
    if ( [resultDef objectForKey:@"VKAccessUserId"] != nil &&
                   [ resultDef objectForKey:@"VKAccessToken"] != nil)
    {
        accessToken = [resultDef objectForKey:@"VKAccessToken"];
        user_id = [resultDef objectForKey:@"VKAccessUserId"];
    }
    else
    {
        vkLoginViewController *vkBrowser = [[vkLoginViewController alloc] init];
        [self presentViewController:vkBrowser animated:NO completion:NULL];
    }
}

- (IBAction)updateTableView:(id)sender
{
    _items =  [NSMutableArray arrayWithArray:[[self sendRequestPlaylist:[NSString stringWithFormat:@"https://api.vkontakte.ru/method/audio.get?owner_id=%@&count=6000&v=5.5&access_token=%@", user_id, accessToken ]] objectForKey:@"items"]];
    if (_items.count == 0)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessUserId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessToken"];
        
        [self loadSettings];
        
    }
    
    URLOfSounds = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _items.count; i++)
        [URLOfSounds addObject:[NSURL URLWithString:[_items[i] objectForKey:@"url"]]];
    [[self tableView] reloadData];
    
}
- (NSDictionary *) sendRequestPlaylist:(NSString *)reqURl
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    
    // Для простоты используется обычный запрос NSURLConnection, ответ сервера сохраняем в NSData переделать под POST запрос
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // Если ответ получен успешно, можем его посмотреть и заодно с помощью JSONKit получить NSDictionary
    NSDictionary *dict;
    dict = [[[JSONDecoder decoder] parseJSONData:responseData]objectForKey:@"response"];
    return dict;
}

-(NSInteger) tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)  tableView: (UITableView *) tableView
           cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableString *(^block) (int) = ^(int num){
        
        NSMutableString * bufStr = [NSMutableString stringWithFormat:@"0%d", num];
        if (bufStr.length == 3)
        {
            [bufStr deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        return bufStr;
    };
    static NSString *cellIdentifier = @"compositionCell";
    compositionCellViewController *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.imgPlayPause.image = [UIImage imageNamed:@"Divx S.png"];
    cell.artist.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"artist"] ;
    cell.title.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.duration.text = [NSString stringWithFormat:@"%d:%@", [[[_items objectAtIndex:indexPath.row] objectForKey:@"duration"] integerValue] / 60,
                          block ([[[_items objectAtIndex:indexPath.row] objectForKey:@"duration"] integerValue] % 60)];
    
    return cell;
}

-      (void) tableView:(UITableView *) tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        MPMoviePlayerViewController *theMoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:URLOfSounds[indexPath.row]];
    [self presentMoviePlayerViewControllerAnimated:theMoviePlayer];
    [theMoviePlayer.moviePlayer play];
   
}

@end
