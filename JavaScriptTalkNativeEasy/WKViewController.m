//
//  WKViewController.m
//  JavaScriptTalkNativeEasy
//
//  Created by JMan on 13/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import "WKViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface WKViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate,wkWebJSEasyProtocol>
@property(nonatomic, strong)WKWebView *webView;
@property(nonatomic, strong)JavaScriptTalkWKNativeEasy *jsTNEasy;
@end

@implementation WKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
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
    
//    WKUserContentController *userCC = configuration.userContentController;
//    [userCC addScriptMessageHandler:self name:@"showName"];

    UIButton *reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    reloadButton.backgroundColor = [UIColor blueColor];
    [reloadButton addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.center = self.view.center;
    [self.view addSubview:reloadButton];
  
}

-(void)reloadAction{
    [_webView reload];
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"%@",NSStringFromClass([message.body class]));
    
//    NSString *callBack = message.body[@"callBack"];
//    [_webView evaluateJavaScript:callBack completionHandler:^(id _Nullable data, NSError * _Nullable error) {
//
//    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString*)showName:(BOOL)isTrue arg2:(NSNumber*)arg2{
    NSLog(@"Bool from js is %@",isTrue?@"True":@"false");
    return @"Hello JS";
}

@end
