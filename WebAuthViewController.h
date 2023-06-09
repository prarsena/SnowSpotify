//
//  WebAuthViewController.h
//  SnowSpotify
//
//  Created by Peter Arsenault on 6/9/23.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface WebAuthViewController : NSViewController <WKNavigationDelegate>

@property (assign) WKWebView *webView;

@end
