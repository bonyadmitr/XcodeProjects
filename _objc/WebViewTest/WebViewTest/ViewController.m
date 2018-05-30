//
//  ViewController.m
//  WebViewTest
//
//  Created by zdaecqze zdaecq on 11.02.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#import "ViewController.h"

@interface ViewController ()

@property(strong,nonatomic) NSString* mainUrl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.selectedItem = self.tabBar.items[1];
    
    
    //загрузка локальных файлов
    //1 способ. неправильно отображает 1.txt
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"4.pdf" ofType:nil];
    NSURL* url = [NSURL fileURLWithPath:filePath];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    //2 сопосб. А этот может правильно тоборазить 1.txt
//    NSData* fileData = [NSData dataWithContentsOfFile:filePath];
//    [self.webView loadData:fileData MIMEType:nil textEncodingName:@"UTF-8" baseURL:nil];
    //https://ru.wikipedia.org/wiki/Список_MIME-типов
    
    //загрузка сайтов
    //NSString* string = @"https://www.google.ru/?gfe_rd=cr&ei=bX9tVvD3LdSAYOT3qNAD";
//    NSString* string = @"https://vk.com/info_matfaka";
//    NSURL* url = [NSURL URLWithString:string];
//    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:urlRequest];
    
    
    //загрузка HTML кода
//    NSString *imageUrlString = @"http://www.gstatic.com/translate/intl/ru/logo.png";
//    NSString *yourText = @"Some text here";
//    NSString *htmlString = [NSString stringWithFormat:@"<img src='%@'/><br>%@", imageUrlString, yourText];
//    [self.webView loadHTMLString:htmlString baseURL:nil];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationWebViewHistoryDidChange:)
                                                 name:@"WebHistoryItemChangedNotification"
                                               object:nil];
    
    self.barButtonWebBack.enabled = [self.webView canGoBack];
    self.barButtonWebForward.enabled = [self.webView canGoForward];
    
    self.webView.scalesPageToFit = YES;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // полная очистка кэша в 4 строчки
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WebHistoryItemChangedNotification" object:nil];
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
//        int cacheSizeMemory = 4*1024*1024; // 4MB
//        int cacheSizeDisk = 32*1024*1024; // 32MB
//        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
//        [NSURLCache setSharedURLCache:sharedCache];
}


- (void)dealloc {
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[NSURLCache sharedURLCache] removeAllCachedResponses];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"WebHistoryItemChangedNotification" object:nil];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}



#pragma mark - Methods

-(void) refreshWebButtons{
    self.barButtonWebBack.enabled = [self.webView canGoBack];
    self.barButtonWebForward.enabled = [self.webView canGoForward];
}


-(void) logURLWithString:(NSString*) string{
    
    NSLog(@"-----%@", string);
    self.mainUrl = self.webView.request.mainDocumentURL.absoluteString;
    NSLog(@"%@", self.mainUrl);
    self.mainUrl = self.webView.request.URL.absoluteString;
    NSLog(@"%@", self.mainUrl);
    self.mainUrl = [self.webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
    NSLog(@"%@", self.mainUrl);
}


- (void)notificationWebViewHistoryDidChange:(NSNotification*)sender{
    
    //[self logURLWithString:@"webViewHistoryDidChange"];
    
    [self refreshWebButtons];
}



#pragma mark - Actions

- (IBAction)actionWebBack:(UIBarButtonItem *)sender {
    
    [self.webView goBack];
}


- (IBAction)actionWebForward:(UIBarButtonItem *)sender {
    
    [self.webView goForward];
}


- (IBAction)actionWebRefresh:(UIBarButtonItem *)sender {
    [self.webView reload];
}



#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //[self logURLWithString:@"shouldStartLoadWithRequest"];
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self.activityIndicator startAnimating];
    //[self logURLWithString:@"shouldStartLoadWithRequest"];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.activityIndicator stopAnimating];
    //[self logURLWithString:@"webViewDidFinishLoad"];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
    [self.activityIndicator stopAnimating];
    //[self logURLWithString:@"didFailLoadWithError"];
}



#pragma mark -  UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if ([item isEqual: self.tabBar.items[0]]) {
        
        NSString* string = @"https://vk.com/info_matfaka";
        NSURL* url = [NSURL URLWithString:string];
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:urlRequest];
        
        static NSInteger counter = 0;
        counter++;
        
        self.tabButtonCustomTest.badgeValue = [NSString stringWithFormat:@"%d", counter];
        
    } else if ([item isEqual: self.tabBar.items[2]]){
        
        NSString* string = @"https://www.google.ru/?gfe_rd=cr&ei=bX9tVvD3LdSAYOT3qNAD";
        NSURL* url = [NSURL URLWithString:string];
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:urlRequest];
    } else {
        
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"4.pdf" ofType:nil];
        NSURL* url = [NSURL fileURLWithPath:filePath];
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:urlRequest];
    }
    
}


@end

























