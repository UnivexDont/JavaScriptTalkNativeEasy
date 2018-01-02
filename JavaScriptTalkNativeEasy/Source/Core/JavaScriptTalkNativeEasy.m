//
//  JavaScriptTalkNativeEasy.m
//  JavaScriptTalkNativeEasy
//
//  Created by Univex on 11/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import "JavaScriptTalkNativeEasy.h"
#import "JavaScriptTalkNativeMethodHandler.h"
@interface JavaScriptTalkNativeEasy()<UIWebViewDelegate>
{
    JSContext * jsContext;
    __weak id webViewSourceDelegate;
}
@property(nonatomic, weak)UIWebView *webView;
@end

@implementation JavaScriptTalkNativeEasy
-(instancetype)init{
    if(self = [super init]){
    }
    return self;
}

+(instancetype)jsTNEasy:(UIWebView *)webView{
    JavaScriptTalkNativeEasy *jsTNEasy = [[self alloc] init];
    jsTNEasy.webView = webView;
    return jsTNEasy;
}


-(void)setDelegate:(id<NSObject>)delegate{
    if (delegate && _webView) {
        _delegate = delegate;
        webViewSourceDelegate = _webView.delegate;
        _webView.delegate = self;
        [_webView addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
        [self reload];
    }
}

-(void)registerJSContext{
    
    unsigned int delegateProtocolCount;
    Protocol * __unsafe_unretained _Nonnull * _Nullable  protocolList = [JavaScriptTalkNativeMethodHandler getObjcProtocol:[_delegate class] count:&delegateProtocolCount];
    for (int indexProtocol = 0; indexProtocol < delegateProtocolCount; indexProtocol++) {
        Protocol *delegateProtocol = protocolList[indexProtocol];
        unsigned int methodCount;
        struct objc_method_description * _Nullable methodDes = protocol_copyMethodDescriptionList(delegateProtocol, YES, YES, &methodCount);
        
        __weak typeof (self)weakSelf = self;
        for (int index = 0; index<methodCount; index++) {
            struct objc_method_description method_des  = methodDes[index];
            SEL selector = method_des.name;
            NSString *selectorName = NSStringFromSelector(selector);
            selectorName = [[selectorName componentsSeparatedByString:@":"] objectAtIndex:0];
            jsContext[selectorName]=^(void){
                __strong typeof (weakSelf)strongSelf = weakSelf;
                NSArray *currentArguments = [JSContext currentArguments];
                NSMethodSignature *signature = [[strongSelf.delegate class] instanceMethodSignatureForSelector:selector];
                id returnValue;
                if (signature) {
                    Method method = class_getInstanceMethod([strongSelf.delegate class], selector);
                    unsigned int argmnetsCount = method_getNumberOfArguments(method);
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    [invocation setSelector:selector];
                    if (argmnetsCount >=3) {
                        for (int argIndex = argumentStartIndex; argIndex<argmnetsCount; argIndex++) {
                            unsigned int jsArgumentIndex  = argIndex - argumentStartIndex;
                            JSValue *jsArgument = (jsArgumentIndex<currentArguments.count)?currentArguments[jsArgumentIndex]:nil;
                            if (jsArgument) {
                                char * cType = method_copyArgumentType(method, argIndex);
                                [JavaScriptTalkNativeMethodHandler addArgument:jsArgument type:cType toInvocation:invocation atIndex:argIndex];
                                free(cType);
                            }
                            
                            
                        }
                    }
                    
                    [invocation invokeWithTarget:strongSelf.delegate];
                    returnValue = [JavaScriptTalkNativeMethodHandler getReturnValue:method invocation:invocation];
                }
                return returnValue;
            };
        }
        free(methodDes);
        
    }
    free(protocolList);
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView != _webView) { return; }
    
    if (webViewSourceDelegate && [webViewSourceDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [webViewSourceDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView != _webView) { return; }
    
    if (webViewSourceDelegate && [webViewSourceDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [webViewSourceDelegate webView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (webView != _webView) { return YES; }
    if (webViewSourceDelegate && [webViewSourceDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [webViewSourceDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (webView != _webView) { return; }
    [self reload];
    if (webViewSourceDelegate && [webViewSourceDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [webViewSourceDelegate webViewDidStartLoad:webView];
    }
}

-(void)reload{
    
    if (_delegate && _webView) {
        jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception){
        };
        [self registerJSContext];
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"delegate"]) {
        id newDelagate = change[@"new"];
        if ([newDelagate isEqual:self]) {
            return;
        }else{
            webViewSourceDelegate = change[@"new"];
            _webView.delegate = self;
        }
      
    }
}

-(void)dealloc{
    [_webView removeObserver:self forKeyPath:@"delegate"];
    _webView = nil;
    jsContext = nil;
    _delegate = nil;
    webViewSourceDelegate = nil;
}

@end
