#import "WebAuthViewController.h"
#import "Secrets.h"
#import "ObjectivelyCruelAppDelegate.h"

@implementation WebAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the WebView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
}

- (void)urlButtonClicked:(id)sender {
    //NSString *currentCode = [ObjectivelyCruelAppDelegate ];
    NSString *currentCode = [[ObjectivelyCruelAppDelegate sharedInstance] getGlobalCode:nil];
    
    NSLog(@"Code: %@", currentCode);
    if (currentCode == nil) {
        Secrets *credentials = [[Secrets alloc] init];
        NSString *client_id = [credentials client_id];
        
        NSProcessInfo *myProcess = [NSProcessInfo processInfo];
        NSString *version = [myProcess operatingSystemVersionString];
        
        //[self.subheader setString:version];
        
        NSString *authorizeString = [NSString stringWithFormat:@"https://accounts.spotify.com/authorize?response_type=code&client_id=%@&scope=user-read-private%%20user-read-email%%20user-read-currently-playing%%20user-modify-playback-state&redirect_uri=snowspotify://callback", client_id];
        
        NSURL *url = [NSURL URLWithString:authorizeString];
        
        // Load the URL in the WebView
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    } else {
        NSLog(@"Have Code: %@", currentCode);
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    
    // Check if the callback URL is being loaded
    if ([url.absoluteString hasPrefix:@"snowspotify://callback"]) {
        // Extract the necessary information from the URL and handle it in your app
        // ...
        
        // Close the WebView window
        [self.webView removeFromSuperview];
        self.webView = nil;
        
        // Call the decisionHandler to allow the navigation
        decisionHandler(WKNavigationActionPolicyAllow);
        
        return;
    }
    
    // Allow all other navigation
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
