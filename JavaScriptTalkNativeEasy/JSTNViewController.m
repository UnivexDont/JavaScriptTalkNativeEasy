//
//  ViewController.m
//  JavaScriptTalkNativeEasy
//
//  Created by Univex on 09/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import "JSTNViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <WebKit/WebKit.h>
#import "JavaScriptTalkNativeEasy.h"
#import "WKViewController.h"
@interface JSTNViewController ()<UIWebViewDelegate,webJSEasyProtocol>
{
    UIWebView *webView;
    JSContext *jsContext;
    WKWebView *wkWebView;

}
@property(nonatomic, strong)JavaScriptTalkNativeEasy *jsTNEasy;
@end

@implementation JSTNViewController

-(void)loadView{
    
    
   
    
    webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = webView;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    double start =  CFAbsoluteTimeGetCurrent()*1000;
   
    UIButton *reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    reloadButton.backgroundColor = [UIColor blueColor];
    [reloadButton addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.center = self.view.center;
    [self.view addSubview:reloadButton];
    
    _jsTNEasy = [JavaScriptTalkNativeEasy jsTNEasy:webView];
    _jsTNEasy.delegate = self;

    
    

    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString* exampleHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:exampleHtml baseURL:baseURL];
    webView.delegate = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//        NSString* exampleHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//        NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
//        [webView loadHTMLString:exampleHtml baseURL:baseURL];
//    });
    
    
    
    
    
    
    
    
    
    
}

-(void)reloadAction{
    WKViewController *wkWebView = [[WKViewController alloc] init];
    [self presentViewController:wkWebView animated:NO completion:^{
        
    }];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSLog(@"开始加载-----%@",jsContext);
//    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    NSLog(@"%@",webView.isLoading?@"Loading":@"No Loading");
//
//    dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    dispatch_source_set_timer(timerSource, dispatch_walltime(NULL, 0), 20.0*NSEC_PER_MSEC, 0);
//    dispatch_source_set_event_handler(timerSource, ^{
//        if (webView.isLoading) {
//            jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//            NSLog(@"加载中的------%@",jsContext);
//            dispatch_source_cancel(timerSource);
//
//        }
//    });
//    dispatch_resume(timerSource);

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSLog(@"加载完成后----%@",jsContext);

}


-(void)_initJavaScripCore{
    jsContext = [[JSContext alloc]init];
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception){
        NSLog(@"JS代码执行中的异常信息%@", exception);
    };
    jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    
    unsigned int methodCount;
    Method *methods = class_copyMethodList([self class], &methodCount);
    __weak typeof (self)weakSelf = self;
    for (int index = 0; index<methodCount; index++) {
        SEL selector = method_getName(methods[index]);
        unsigned int argumentNum = method_getNumberOfArguments(methods[index]);
        if (argumentNum >= 3) {
            for (int argIndex = 0; argIndex < argumentNum; argIndex++) {
                const char* arguName = method_copyArgumentType(methods[index], argIndex);
                NSLog(@"------>%@",[NSString stringWithUTF8String:arguName]);
            }
            
        }
        NSString *selectorName = NSStringFromSelector(selector);
        selectorName = [selectorName stringByReplacingOccurrencesOfString:@":" withString:@""];
        jsContext[selectorName]=^(void){
            __strong typeof (weakSelf)strongSelf = weakSelf;
//            ((void(*)(id, SEL,NSString*))objc_msgSend)(strongSelf, selector, @"DDDD");
            
            //            if ([strongSelf respondsToSelector:selector]) {
            //                [strongSelf performSelector:selector withObject:@"XXXX"];
            //            }
            NSMethodSignature *signature = [[strongSelf class] instanceMethodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setSelector:selector];
            NSString *firstArgu = @"argument";
            [invocation setArgument:&firstArgu atIndex:2];
            [invocation invokeWithTarget:strongSelf];
            
            
        };
        NSLog(@"Method--%@",NSStringFromSelector(selector));
    }
//    __weak typeof (self)weakSelf = self;
//    jsContext[@"jsCallNative"] = ^(void){
//        __strong typeof (weakSelf)strongSelf = weakSelf;
//        [strongSelf performSelector:@selector(testMethod:) withObject:@"XXXX"];
//        JSValue *currentThis = [JSContext currentThis];
//        JSValue *currentCallee = [JSContext currentCallee];
//        NSArray *currentParamers = [JSContext currentArguments];
//        JSValue *firstParamer = [currentParamers objectAtIndex:0];
//        BOOL isString = firstParamer.isString;
//        NSLog(@"%@",(isString?@"Yes":@"No"));
//        NSLog(@"currentThis is %@",[currentThis toString]);
//        NSLog(@"currentCallee is %@",[currentCallee toString]);
//        NSLog(@"currentParamers is %@",currentParamers);
//    };
    

}


-(void)getAllProtocol{
    
    unsigned int proCount;
    Protocol * __unsafe_unretained *protocolList = class_copyProtocolList([self class], &proCount);
    for (int index = 0; index < proCount; index++) {
        Protocol *protocol_t = protocolList[index];
        const char *protocolName = protocol_getName(protocol_t);
        NSLog(@"%@",[NSString stringWithUTF8String:protocolName]);
        
        unsigned int superProtocolCount;
        Protocol * __unsafe_unretained *superProtocolList = protocol_copyProtocolList(protocol_t, &superProtocolCount);
        for (int index = 0; index < superProtocolCount; index++) {
            Protocol *protocol_t = superProtocolList[index];
            const char *protocolName = protocol_getName(protocol_t);
            NSLog(@"%@",[NSString stringWithUTF8String:protocolName]);
        }
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)jsCallNative:(NSString *)parameter{
    NSLog(@"send parameter is %@",parameter);
}
-(void)testAction:(NSString *)name{
    
}

//Protocol * __unsafe_unretained _Nonnull * _Nullable getObjcProtocol(id objc, int *count){
//    unsigned int proCount;
//    Protocol * __unsafe_unretained *protocolList = class_copyProtocolList([objc class], &proCount);
//    Protocol *__unsafe_unretained _Nonnull *returnProtocolList = (Protocol *__unsafe_unretained _Nonnull *)malloc(sizeof(Protocol*));
//
//    for (int index = 0; index < proCount; index++) {
//        Protocol *protocol_t = protocolList[index];
//        const char *protocolName = protocol_getName(protocol_t);
//        NSLog(@"%@",[NSString stringWithUTF8String:protocolName]);
//        returnProtocolList[index] = protocol_t;
//        unsigned int superProtocolCount;
//        Protocol * __unsafe_unretained *superProtocolList = protocol_copyProtocolList(protocol_t, &superProtocolCount);
//        for (int index = 0; index < superProtocolCount; index++) {
//            Protocol *protocol_t = superProtocolList[index];
//            const char *protocolName = protocol_getName(protocol_t);
//            NSLog(@"%@",[NSString stringWithUTF8String:protocolName]);
//        }
//
//    }
//    *count = 2;
//    return returnProtocolList;
//}

-(Protocol * __unsafe_unretained _Nonnull * _Nullable)getObjcProtocol:(id)objc count:(int *)count{
    
    
    unsigned int proCount;
    Protocol * __unsafe_unretained *protocolList = class_copyProtocolList([objc class], &proCount);
    Protocol *__unsafe_unretained _Nonnull *returnProtocolList = (Protocol *__unsafe_unretained _Nonnull *)malloc(sizeof(Protocol*)*3);

    for (int index = 0; index < proCount; index++) {
        Protocol *protocol_t = protocolList[index];
        const char *protocolName = protocol_getName(protocol_t);
        NSLog(@"%@",[NSString stringWithUTF8String:protocolName]);
        returnProtocolList[index] = protocol_t;
        unsigned int superProtocolCount;
        Protocol * __unsafe_unretained *superProtocolList = protocol_copyProtocolList(protocol_t, &superProtocolCount);
        for (int index = 0; index < superProtocolCount; index++) {
            Protocol *protocol_t = superProtocolList[index];
            const char *protocolName = protocol_getName(protocol_t);
            NSLog(@"%@",[NSString stringWithUTF8String:protocolName]);
        }
        
    }
    *count = 2;
    return returnProtocolList;
}


-(NSString *)testMethod:(BOOL )string{
    return string?@"Yes":@"NO";
}

@end
