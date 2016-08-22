//
//  RHBaseNewWebController.m
//  TrainMate
//
//  Created by m on 16/8/15.
//  Copyright © 2016年 RockHippo. All rights reserved.
//

#import "RHBaseNewWebController.h"
#import "RHNotNeworkingLoadingView.h"
#import "RHLoadDingAnimation.h"

@interface RHBaseNewWebController ()<WKScriptMessageHandler>
@end

@implementation RHBaseNewWebController

//- (WKWebView *)WKwebView
//{
//    if (!_WKwebView) {
//        //创建配置
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        
//        //是否将数据加载到内存再渲染，默认为NO
//        //config.suppressesIncrementalRendering = YES;
//        //是否支持js,默认YES
//        config.preferences.javaScriptEnabled = YES;
//        //创建提供javaScript向webView发送消息的方法
//        WKUserContentController *userContent = [[WKUserContentController alloc] init];
//        //添加消息处理,注意:self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
//        [userContent addScriptMessageHandler:self name:@"NativeMethod"];
//        NSString *appIdentification = [[APPIdentificationManager sharedAPPIdentificationManager] readUDID];
//        
//        NSString *js = [NSString stringWithFormat:@"function getAppIdentification(){ return '%@'; }", appIdentification];
//        
//      NSString * js1 = [NSString stringWithFormat:@"function getIP(){ return '%@'; }",[RHSetting getIPAdress]];
//    
//        
//       NSString *js2 = [NSString stringWithFormat:@"function getVersion(){ return '%@'; }",@"1.2.1"];
//
//        
//       NSString *js3 = [NSString stringWithFormat:@"function modelType(){ return '%@'; }",[RHSetting getDeviceInfo]];
//        
//        NSString *newJS = [NSString stringWithFormat:@"%@%@%@%@",js,js1,js2,js3];
//        
//        //注入JS代码
//        WKUserScript *jsuser = [[WKUserScript alloc] initWithSource:newJS injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//        [userContent addUserScript:jsuser];
//        
//        //将userConttentController配置到文件
//        config.userContentController = userContent;
//        _WKwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) configuration:config];
//
//        _WKwebView.UIDelegate = self;
//        _WKwebView.navigationDelegate = self;
//        
//    }
//    return _WKwebView;
//}
//

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.alwaysBounceVertical = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        //是否将数据加载到内存再渲染，默认为NO
//        _webView.suppressesIncrementalRendering = YES;
        for (UIView *view in _webView.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]){
                [(UIScrollView *)view setShowsVerticalScrollIndicator:NO];
                //右侧的滚动条
                [(UIScrollView *)view setShowsHorizontalScrollIndicator:NO];
                //下侧的滚动条
            }
        }

    }
    return _webView;
}



//统计相关

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSString *appIdentification = [[APPIdentificationManager sharedAPPIdentificationManager] readUDID];
    NSString *js = [NSString stringWithFormat:@"function getAppIdentification(){ return '%@'; }", appIdentification];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    js = [NSString stringWithFormat:@"function getIP(){ return '%@'; }",[RHSetting getIPAdress]];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    js = [NSString stringWithFormat:@"function getVersion(){ return '%@'; }",@"1.2.1"];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    js = [NSString stringWithFormat:@"function modelType(){ return '%@'; }",[RHSetting getDeviceInfo]];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initalizationLoading];
    
}

//初始化加载
- (void)initalizationLoading
{
    
    [self.view addSubview:self.webView];
    
    self.title = self.titleName;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(RHWebViewDidStartLoad:)]) {
        
        [[RHLoadDingAnimation shareInitalzationType] showAnimationWith:self.view showInfo:nil];
        
        [self.delegate RHWebViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(RHWebViewDidFinishLoad:)]) {
        
        [[RHLoadDingAnimation shareInitalzationType] disremoveSupperViw:self.view];
        
        [self.delegate RHWebViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(RHWebView:didFailLoadWithError:)]) {
        
        [[RHLoadDingAnimation shareInitalzationType] disremoveSupperViw:self.view];
        
        [self.delegate RHWebView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([self.delegate respondsToSelector:@selector(RHWebView:shouldStartLoadWithRequest:navigationType:)]) {
     
        [self.delegate RHWebView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

//
////页面开始加载时调用
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
//{
//    if ([self.delegate respondsToSelector:@selector(RHWebView:shouldStartLoadWithRequest:navigationType:)]) {
//        [[RHLoadDingAnimation shareInitalzationType] showAnimationWith:webView showInfo:nil];
//        
//        [self.delegate RHWebView:webView didStartProvisionalNavigation:navigation];
//    }
//}
//
////当内容开始返回时调用
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
//{
//    if ([self.delegate respondsToSelector:@selector(RHWebView:didCommitNavigation:)]) {
//
//        [self.delegate RHWebView:webView didCommitNavigation:navigation];
//    }
//}
//
////页面加载完成之后调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
//{
//    if ([self.delegate respondsToSelector:@selector(RHWebView:didFinishNavigation:)]) {
//        
//        [[RHLoadDingAnimation shareInitalzationType] disremoveSupperViw:webView];
//        
//        [self.delegate RHWebView:webView didFinishNavigation:navigation];
//    }
//}
//
////页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
//{
//    if ([self.delegate respondsToSelector:@selector(RHWebView:didFailNavigation:withError:)]) {
//        
//        [[RHLoadDingAnimation shareInitalzationType] disremoveSupperViw:webView];
//        
//        [self.delegate RHWebView:webView didFailNavigation:navigation withError:error];
//    }
//}
//
////页面跳转的代理
////接收到服务器跳转请求的代理
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
//{
//    if ([self.delegate respondsToSelector:@selector(RHWebView:decidePolicyForNavigationResponse:decisionHandler:)]) {
//        [self.delegate RHWebView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
//    }
//}
//
////在接收到响应后，决定是否跳转的代理,此代理方法实现后会导致程序崩溃:原因是因为条件不成立，没有被调用
////- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
////{
////    if ([self.delegate respondsToSelector:@selector(RHWebView:decidePolicyForNavigationResponse:decisionHandler:)]) {
////        [self.delegate RHWebView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
////    }
////}
//
////在发送请求之前，决定是否跳转的代理
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//    if ([self.delegate respondsToSelector:@selector(RHWebView:decidePolicyForNavigationAction:decisionHandler:)]) {
//        [self.delegate RHWebView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
//    }
//}
//
//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
//{
//    // 判断是否是调用原生的
//    if ([@"NativeMethod" isEqualToString:message.name]) {
//        // 判断message的内容，然后做相应的操作
//        if ([@"close" isEqualToString:message.body]) {
//            
//        }
//    }
//}
//
//- (void)dealloc
//{
//    [self.WKwebView.configuration.userContentController removeScriptMessageHandlerForName:@"NativeMethod"];
//}

@end
