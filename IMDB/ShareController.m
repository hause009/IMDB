//
//  ShareController.m
//  IMDB
//
//  Created by progforce on 21.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//

#import "ShareController.h"

@interface ShareController ()

@end

@implementation ShareController
@synthesize share;
@synthesize shareUrl;
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL* url= [[NSURL alloc]init];
    self.title = share;
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    if ([share isEqual: @"Twitter"])
    {
        NSString * urlString = [NSString stringWithFormat:@"http://twitter.com/intent/tweet?source=sharethiscom&url=%@",shareUrl];
        url = [NSURL URLWithString:urlString];
    }
    else if([share isEqual:@"Facebook"])
    {
        NSString * urlString = [NSString stringWithFormat:@"https://m.facebook.com/sharer.php?u=http:%@&t=Message",shareUrl];
        url = [NSURL URLWithString:urlString];
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [webView setScalesPageToFit:YES];
    
}


@end
