//
//  CLHWebViewController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/23.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHWebViewController.h"
#import <WebKit/WebKit.h>


@interface CLHWebViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;

@property (weak, nonatomic) IBOutlet UIProgressView *progressV;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property(nonatomic, weak) WKWebView *webView;

@end

@implementation CLHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *webV = [[WKWebView alloc] init];
    self.webView = webV;
    [self.contentV addSubview:webV];
    
    NSURLRequest *urlRequst = [NSURLRequest requestWithURL:self.url];
    [webV loadRequest:urlRequst];
    
    // KVO监听属性改变
    /*
     Observer:观察者
     KeyPath:观察webView哪个属性
     options:NSKeyValueObservingOptionNew:观察新值改变
     
     KVO注意点.一定要记得移除
     */
    [webV addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webV addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [webV addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    // 进度条
    [webV addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.webView.frame = self.contentV.bounds;
}

// 只要观察对象属性有新值就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    self.goBackItem.enabled = self.webView.canGoBack;
    self.goForwardItem.enabled = self.webView.canGoForward;
    self.title = self.webView.title;
    self.progressV.progress = self.webView.estimatedProgress;
    self.progressV.hidden = self.webView.estimatedProgress >= 1;
}

#pragma mark - 对象被销毁
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - 按钮点击

- (IBAction)backClick:(UIBarButtonItem *)sender {
    [self.webView goBack];
    
}

- (IBAction)forwardClick:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (IBAction)reloadClick:(UIBarButtonItem *)sender {
    
    [self.webView reload];
}

@end
