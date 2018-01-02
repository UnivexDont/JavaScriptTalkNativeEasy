<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

[![Travis](https://img.shields.io/travis/rust-lang/rust.svg)]()
[![pod](https://img.shields.io/badge/pod-1.0.0-blue.svg)]() [![platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)]() [![Email](https://img.shields.io/badge/email-winerdt@163.com-orange.svg?style=social)]()

 JavaScriptTalkNativeEasy 是一个iOS平台用于Obj-C和JavaScript交互的库，此库是基于 Apple 的JavaScriptCore 、 WebKit 、 runtime进行封装的。

# 通过pod进行安装

```ruby
  pod 'JavaScriptTalkNativeEasy'
```


# 在UIWebView中使用

JavaScript 中对应相关的代码。
```javascript
   <script>
        function test() {
            var userInfo = getUserInfo('Hello Native!!!');
            document.write('Name:'+userInfo.name);
            document.write('<br>');
            document.write('Age:'+userInfo.age);

        }
   </script>
```

```objc
#import <UIKit/UIKit.h>
#import "JavaScriptTalkNativeEasyProtocol.h"

@protocol WebJSEasyProtocol<JavaScriptTalkNativeEasyProtocol>
-(NSDictionary *)getUserInfo:(NSString *)string;//和javaScript中对应的函数名一致。
@end

@interface JSTNEUIWebViewController : UIViewController


@end
// WebJSEasyProtocol 协议必须继承JavaScriptTalkNativeEasyProtocol,此协议名称可以替换成您自己想要的，协议中的方法名必须和JavaScript端对应的要掉的函数名称一致。
```

```objc
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
-(NSDictionary *)getUserInfo:(NSString *)string{
    
    NSLog(@"%@",string);
    return @{@"name":@"Univex",@"age":@27};
}

@end
```

# 在WKWebView中使用
JavaScript 中对应相关的代码。
```javascript
   <script>
        function test() {
            window.webkit.messageHandlers.getUserInfo.postMessage({'message':'Hello Native!!!','callBackFromNative':'userInfo'});

        }
    
        function userInfo(user){
            document.write(user.name)
            document.write('<br>')
            document.write(user.age)
            
        }
   </script>
```
```objc
@protocol WKWebJSEasyProtocol<JavaScriptTalkNativeEasyProtocol>
-(NSDictionary *)getUserInfo:(NSDictionary *)dic;   //和javaScript中对应的函数名一致。
@end

@interface JSTNEWKWebViewController : UIViewController
@end
// WKWebJSEasyProtocol 协议必须继承JavaScriptTalkNativeEasyProtocol,此协议名称可以替换成您自己想要的，协议中的方法名必须和JavaScript端对应的要掉的函数名称一致。
```
```objc
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
}
-(NSDictionary *)getUserInfo:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    return @{@"name":@"Univex",@"age":@27};
}
@end
```

# 邮箱: [winerdt@163.com](winerdt@163.com)