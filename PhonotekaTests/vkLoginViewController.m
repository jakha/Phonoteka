//
//  vkLoginViewController.m
//  Phonoteka
//
//  Created by Джахангир on 12/02/14.
//  Copyright (c) 2014 Джахангир. All rights reserved.
//

#import "vkLoginViewController.h"


@implementation vkLoginViewController

@synthesize authWebView = _authWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(!_authWebView)
    {
        _authWebView  = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _authWebView.delegate = self;
        [self.view addSubview:_authWebView];
    }
    [_authWebView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oauth.vk.com/authorize?client_id=4076396&scope=audio,offline&redirect_uri=oauth.vk.com/blank.html&display=touch&response_type=token"]]];
}

- (BOOL)webView:(UIWebView *)aWbView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    // Пользователь нажал Отмена в веб-форме
    if ([[URL absoluteString] isEqualToString:@"https://login.vk.com/oauth.vk.com/blank.html#error=access_denied&error_reason=user_denied&error_description=User%20denied%20your%20request"])
    {
        [self.navigationController  removeFromParentViewController];
        return NO;
    }
    NSLog(@"Request: %@", [URL absoluteString]); 
	return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([_authWebView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound)
    {
        NSString *accessToken = [self stringBetweenString:@"access_token="
                                                andString:@"&"
                                              innerString:[[[webView request] URL] absoluteString]];
        
        NSArray *userAr = [[[[webView request] URL] absoluteString] componentsSeparatedByString:@"&user_id="];
        NSString *user_id = [userAr lastObject];
        if(user_id)
            [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"VKAccessUserId"];
        
        if(accessToken)
        {
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"VKAccessToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self  dismissViewControllerAnimated:NO completion:NULL];
    }else
        if ([_authWebView.request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
            NSLog(@"Error: %@", _authWebView.request.URL.absoluteString);
            [self  dismissViewControllerAnimated:NO completion:NULL];

        }
}
- (NSString*)stringBetweenString:(NSString*)start
                       andString:(NSString*)end
                     innerString:(NSString*)str
{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    
    if ([scanner scanString:start intoString:NULL])
    {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result])
            return result;
    }
    return nil;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:NO completion:NULL];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
