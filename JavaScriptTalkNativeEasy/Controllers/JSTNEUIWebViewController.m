//
//  ViewController.m
//  JavaScriptTalkNativeEasy
//
//  Created by Univex on 09/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import "JSTNEUIWebViewController.h"
#import "JavaScriptTalkNativeEasy.h"
@interface JSTNEUIWebViewController ()<UIWebViewDelegate,WebJSEasyProtocol>
{
    UIWebView *webView;

}
@property(nonatomic, strong)JavaScriptTalkNativeEasy *jsTNEasy;
@end

@implementation JSTNEUIWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UIWebView";
    
    webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:webView];
    
    _jsTNEasy = [JavaScriptTalkNativeEasy jsTNEasy:webView];
    _jsTNEasy.delegate = self;
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString* exampleHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:exampleHtml baseURL:baseURL];
    webView.delegate = self;

}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSDictionary *)getUserInfo:(NSString *)string{
    
    NSLog(@"%@",string);
    return @{@"name":@"Univex",@"age":@27};
}

@end
