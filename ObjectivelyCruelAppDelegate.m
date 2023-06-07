//
//  ObjectivelyCruelAppDelegate.m
//  ObjectivelyCruel
//
//  Created by petera on 6/3/23.
//  Copyright 2023 __MyCompanyName__. All rights reserved.
//

#import "ObjectivelyCruelAppDelegate.h"
#import "nscolor-colorWithCssDefinition.h"
#import "Secrets.h"
#import <Foundation/Foundation.h>

@implementation ObjectivelyCruelAppDelegate

@synthesize window;
@synthesize textField;
@synthesize button;
@synthesize colorButton;
@synthesize textView;
@synthesize pageHeader;
@synthesize subheader;
@synthesize colorPanelWindowController;
@synthesize menu;
@synthesize receivedDataString;
@synthesize bearer_token = _bearer_token;
@synthesize code = _code;

+ (ObjectivelyCruelAppDelegate *)sharedInstance {
    static ObjectivelyCruelAppDelegate *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSString *currentCode = self.code;
    //self.bearer_token = @"init";
    NSLog(@"Code: %@", currentCode);

    /* Create the menu bar */
    NSMenu *menuBar = [[NSMenu alloc] init];
    NSMenuItem *applicationMenuItem = [[NSMenuItem alloc] init];
    [menuBar addItem:applicationMenuItem];
    
    /* Add items to the menu bar */
    NSMenu *applicationMenu = [[NSMenu alloc] init];
    [applicationMenuItem setSubmenu:applicationMenu];
    
    // Add Preferences menu item
    NSMenuItem *preferencesMenuItem =
        [[NSMenuItem alloc] initWithTitle:@"Colors"
                            action:@selector(showPreferences:)
                            keyEquivalent:@"c"];
    [applicationMenu addItem:preferencesMenuItem];
    
    // Add Quit menu item
    NSMenuItem *quitMenuItem =
        [[NSMenuItem alloc] initWithTitle:@"Quit"
                            action:@selector(quitApplication:)
                            keyEquivalent:@"q"];
    [applicationMenu addItem:quitMenuItem];
    
    // Set the menu bar
    [[NSApplication sharedApplication] setMainMenu:menuBar];
    
    /* Create the window. It will be different depending on which OS X version. */
    NSRect windowFrame = NSMakeRect(0,NSMaxY([[NSScreen mainScreen] frame]),400,300);
    
    NSRect headerFrame = NSMakeRect(20,230,340,50);
	NSRect subheaderFrame = NSMakeRect(60,175,260,40);
    self.pageHeader = [[NSTextView alloc] initWithFrame:headerFrame];
    
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_6
    self.window = [[NSWindow alloc] initWithContentRect: windowFrame
                                              styleMask: NSWindowStyleMaskTitled |
                                                           NSWindowStyleMaskClosable |
                                                           NSWindowStyleMaskResizable |
                                                           NSWindowStyleMaskMiniaturizable
                                                backing: NSBackingStoreBuffered
                                                  defer: NO];
    self.window.title = @"Not Snow Leopard";
    self.pageHeader.string = @"Not Snow Leopard";

    [self.pageHeader setAlignment: NSTextAlignmentCenter];
    NSLog(@"Found greater os than snow" );
#else
    self.window = [[NSWindow alloc] initWithContentRect: windowFrame
                                              styleMask:   NSTitledWindowMask |
                                                           NSResizableWindowMask |
                                                           NSMiniaturizableWindowMask |
                                                           NSClosableWindowMask
                                                backing: NSBackingStoreBuffered
                                                  defer: NO];
    self.window.title = @"Snow Leopard";
    self.pageHeader.string = @"Whoa Leopard";
    [self.pageHeader setAlignment: NSCenterTextAlignment];
    NSLog(@"Found os x snow" );
#endif
    /* Main window color */
    NSColor *backgroundColor = [NSColor colorWithCssDefinition:@"royalblue"];
    self.window.backgroundColor = backgroundColor;
	
    /* These attributes describe the Title section of the window. */
    [self.pageHeader setFont:[NSFont systemFontOfSize:33]];
    [self.pageHeader setEditable: NO];
    [self.pageHeader setSelectable: NO];
    [self.pageHeader setBackgroundColor: [NSColor colorWithCssDefinition:@"dodgerblue"]];
    [self.pageHeader setTextColor:[NSColor colorWithCssDefinition:@"tomato"]];
    [self.window.contentView addSubview:self.pageHeader];
	
	/* Work with subheader */
	self.subheader = [[NSTextView alloc] initWithFrame:subheaderFrame];
	[self.subheader setFont:[NSFont boldSystemFontOfSize:33]];
	[self.subheader setEditable: NO];
    [self.subheader setSelectable: NO];
	[self.subheader setFont: [NSFont systemFontOfSize:14]];
    [self.subheader setBackgroundColor: [NSColor colorWithCssDefinition:@"dodgerblue"]];
    [self.subheader setTextColor:[NSColor colorWithCssDefinition:@"tomato"]];
	//[self.subheader setAlignment: NSCenterTextAlignment];
	[self.window.contentView addSubview:self.subheader];
    
    /* These attributes describe the text field, the space where a user can write. */
    self.textField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 32, 200, 30)];
    [self.textField setBackgroundColor: [NSColor colorWithCssDefinition:@"azure"]];
    [self.textField setFont: [NSFont systemFontOfSize:14]];
    [self.textField setTextColor:[NSColor colorWithCssDefinition:@"midnightblue"]];
    [self.window.contentView addSubview:self.textField];
    
    /* These attributes describe the text view, the space where the message is displayed. */
    self.textView = [[NSTextView alloc] initWithFrame:NSMakeRect(20, 67, 200, 62)];
    self.textView.backgroundColor = [NSColor colorWithCssDefinition:@"cornsilk"];
    self.textView.textColor = [NSColor colorWithCssDefinition:@"midnightblue"];
    self.textView.string = @"Hello, me!";
    [self.textView setFont:[NSFont systemFontOfSize:25]];
    [self.textView setEditable: NO];
    [self.textView setSelectable: NO];
    [self.window.contentView addSubview:self.textView];
    
    // Create the close window button without declaring it. Also, don't display it. 
    NSButton *closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(230, 30, 100, 32)];
	[closeButton setTitle: @"Close"];
    closeButton.target = self;
    [closeButton setFont: [NSFont systemFontOfSize:14]];
    [closeButton setAction:@selector(quitApplication:)];
	[closeButton setKeyEquivalentModifierMask: NSCommandKeyMask];
	[closeButton setKeyEquivalent:@"w"];
    [self.window.contentView addSubview:closeButton];
    
    // Create the button
    self.button = [[NSButton alloc] initWithFrame:NSMakeRect(230, 65, 100, 32)];
    self.button.title = @"Write Msg";
    [self.button setBordered: YES];
    [self.button setFont: [NSFont systemFontOfSize:14]];
	[self.button setKeyEquivalent:@"\r"];
    [self.button setTarget:self];
    [self.button setAction:@selector(buttonClicked:)];
    [self.window.contentView addSubview:self.button];
    
	// Create the close window button without declaring it.
    NSButton *urlButton = [[NSButton alloc] initWithFrame:NSMakeRect(230, 100, 100, 32)];
    [urlButton setTitle: @"URL"];
    urlButton.target = self;
    [urlButton setFont: [NSFont systemFontOfSize:14]];
    [urlButton setAction:@selector(urlButtonClicked:)];
    [self.window.contentView addSubview:urlButton];

    // Create the close window button without declaring it.
    NSButton *tokenButton = [[NSButton alloc] initWithFrame:NSMakeRect(230, 135, 100, 32)];
    [tokenButton setTitle: @"Token req"];
    tokenButton.target = self;
    [tokenButton setFont: [NSFont systemFontOfSize:14]];
    [tokenButton setAction:@selector(sendAccessTokenRequest:)];
    [self.window.contentView addSubview:tokenButton];
    
    // Create the close window button without declaring it.
    NSButton *getSongButton = [[NSButton alloc] initWithFrame:NSMakeRect(230, 165, 100, 32)];
    [getSongButton setTitle: @"Get song"];
    getSongButton.target = self;
    [getSongButton setFont: [NSFont systemFontOfSize:14]];
    [getSongButton setAction:@selector(getCurrentSong:)];
    [self.window.contentView addSubview:getSongButton];
    
    [self.window makeKeyAndOrderFront: NSApp];
}

- (NSString *) getGlobalCode: (id) sender {
    NSString *currentCode = [[ObjectivelyCruelAppDelegate sharedInstance] code];
    NSLog(@"%@",currentCode);
    return currentCode;
}

- (NSString *)code {
    return _code; // Implement the getter method
}

- (void)setCode:(NSString *)code {
    if (_code != code) {
        [_code release]; // Release the previous value
        _code = [code retain]; // Retain and assign the new value
    }
    NSLog(@"Got my code: %@", _code);
}

- (NSString *) getGlobalBearer: (id) sender {
    NSString *currentBearer = [[ObjectivelyCruelAppDelegate sharedInstance] bearer_token];
    NSLog(@"%@",currentBearer);
    return currentBearer;
}

- (NSString *)bearer_token {
    return _bearer_token; // Implement the getter method
}

- (void)setBearer_token:(NSString *)bearer_token {
    if (_bearer_token != bearer_token) {
        [_bearer_token release]; // Release the previous value
        _bearer_token = [bearer_token retain]; // Retain and assign the new value
    }
    NSLog(@"Got my code: %@", _code);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {}

- (void)urlButtonClicked:(id)sender {
    Secrets *credentials = [[Secrets alloc] init];
    NSString *client_id = [credentials client_id];
    
    NSProcessInfo *myProcess = [NSProcessInfo processInfo];
    NSString *version = [myProcess operatingSystemVersionString];

    [self.subheader setString:version];
    
    NSString *authorizeString = [NSString stringWithFormat:@"https://accounts.spotify.com/authorize?response_type=code&client_id=%@&scope=user-read-private%%20user-read-email%%20user-read-currently-playing%%20user-modify-playback-state&redirect_uri=snowspotify://callback", client_id];
    
    NSURL *url = [NSURL URLWithString:authorizeString];
    
    [[NSWorkspace sharedWorkspace] openURL:url];
}


- (void)sendAccessTokenRequest:(id)sender {
    Secrets *credentials = [[Secrets alloc] init];
    NSString *client_id = [credentials client_id];
    NSString *client_secret = [credentials client_secret];
    NSString *secretSauce = [NSString stringWithFormat:@"%@:%@", client_id, client_secret];
    NSData *data = [secretSauce dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedString = [data base64EncodedStringWithOptions:0];
    
    NSString *basicAuth = [NSString stringWithFormat:@"Basic %@", base64EncodedString];
    
    NSString *tokenUrl = @"https://accounts.spotify.com/api/token?grant_type=authorization_code&redirect_uri=snowspotify://callback&code=";
    
    NSString *currentCode = [self getGlobalCode:nil];
    //NSLog(@"Token Request Code: %@", currentCode);
    
    NSString *postAddress = [NSString stringWithFormat:@"%@%@", tokenUrl, currentCode];
    
    NSURL *postUrl = [NSURL URLWithString:postAddress];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:basicAuth forHTTPHeaderField:@"Authorization"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)buttonClicked:(id)sender {
    NSLog(@"Wrong story pal");
}

- (void)quitApplication:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)showPreferences:(id)sender {
    NSLog(@"Show preferences");
    /*
    if (!self.colorPanelWindowController) {
        self.colorPanelWindowController = [[ColorPanelWindowController alloc] initWithCustomWindow];
    }
    [self.colorPanelWindowController showWindow:self];
     */
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Handle the received data
    NSLog(@"Did receive data");
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", stringData);
    self.receivedDataString = stringData; // Store the received data in the instance variable
    [self processReceivedData]; // Call the second method
}

- (void)processReceivedData {
    
    NSString *receivedData = self.receivedDataString;
    NSArray *components = [receivedData componentsSeparatedByString:@":"];
    if (components.count >= 2) {
        NSArray *bearerOfGifts = [components[1] componentsSeparatedByString:@"\""];
        
        if (bearerOfGifts.count >= 2) {
            //self.bearer_token = bearerOfGifts[1];
            //NSLog(@"my bearer token: %@", self.bearer_token);
            //NSString* newBearerToken = bearerOfGifts[1];
            [[ObjectivelyCruelAppDelegate sharedInstance] setBearer_token:bearerOfGifts[1]];
        } else {
            NSLog(@"Invalid bearerOfGifts array: %@", bearerOfGifts);
        }
    } else {
        NSLog(@"Invalid components array: %@", components);
    }
}

- (void) getCurrentSong: (id) sender {
    NSString *currentBear = [[ObjectivelyCruelAppDelegate sharedInstance] bearer_token];

    NSLog(@"my bearer token: %@", currentBear);
    
    if (currentBear && currentBear.length > 0) {
       
        NSString *bearerHeader = [NSString stringWithFormat:@"Bearer %@", currentBear];
        
        NSString *nowPlayingStringURL = @"https://api.spotify.com/v1/me/player/currently-playing?additional_types=track,episode";
        
        NSURL *nowPlayingURL = [NSURL URLWithString:nowPlayingStringURL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nowPlayingURL];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:bearerHeader forHTTPHeaderField:@"Authorization"];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    } else {
        NSLog(@"i've never been so scared");
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {}

@end
