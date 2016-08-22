//
//  RHBaseNewWebController.h
//  TrainMate
//
//  Created by m on 16/8/15.
//  Copyright © 2016年 RockHippo. All rights reserved.
//
//重新对webView封装

#import "RHBaseViewController.h"
#import <WebKit/WebKit.h>

@protocol RHWebViewDelelgate <NSObject>

//@required
@optional
/**开始加载webView*/
- (void)RHWebViewDidStartLoad:(UIWebView *)webView;

/**加载完成*/
- (void)RHWebViewDidFinishLoad:(UIWebView *)webView;

/**加载失败*/
- (void)RHWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

/**加载协议拦截*/
- (BOOL)RHWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@optional
//WKWebView--delegate
/**准备加载页面*/
- (void)RHWebView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;

/**开始加载*/
- (void)RHWebView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;

/**加载完成*/
- (void)RHWebView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

/**加载失败*/
- (void)RHWebView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error;

/**接收到服务器跳转请求的代理*/
- (void)RHWebView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation;

/**在接收到响应后，决定是否跳转的代理*/
- (void)RHWebView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;

/**在发送请求之前，决定是否跳转的代理*/
- (void)RHWebView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

@end

@interface RHBaseNewWebController : RHBaseViewController <UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>

/**url地址*/
@property (nonatomic,strong) NSString *url;
/**webView页面*/
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *WKwebView;
/**title标题名字*/
@property (nonatomic,copy) NSString * titleName;

@property (nonatomic, weak) id <RHWebViewDelelgate> delegate;

@end


