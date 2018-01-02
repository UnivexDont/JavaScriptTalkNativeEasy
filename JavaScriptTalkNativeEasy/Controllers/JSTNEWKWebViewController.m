//
//  WKViewController.m
//  JavaScriptTalkNativeEasy
//
//  Created by JMan on 13/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import "JSTNEWKWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface JSTNEWKWebViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate,WKWebJSEasyProtocol>
@property(nonatomic, strong)WKWebView *webView;
@property(nonatomic, strong)JavaScriptTalkWKNativeEasy *jsTNEasy;
@end

@implementation JSTNEWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"WKWebView";
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [self.view addSubview:_webView];
    configuration.preferences.javaScriptEnabled = YES;
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index_wk" ofType:@"html"];
    NSString* exampleHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [_webView loadHTMLString:exampleHtml baseURL:baseURL];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    _jsTNEasy = [JavaScriptTalkWKNativeEasy jsTNEasy:_webView];
    _jsTNEasy.delegate = self;
    _jsTNEasy.smhDelegate = self;
  
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"Message from JavaScript is %@",message.body);
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSDictionary *)getUserInfo:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    return @{@"name":@"Univex",@"age":@27};
}


@end
