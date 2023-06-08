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
#import <Security/Security.h>
#import "JSONKit.h"
#import "NSData+Base64.h"

@implementation ObjectivelyCruelAppDelegate

@synthesize window;
@synthesize textField;
@synthesize button;
@synthesize colorButton;
@synthesize textView;
@synthesize pageHeader;
@synthesize subheader;
@synthesize menu;
@synthesize receivedDataString;
@synthesize receivedData;

@synthesize albumimageView;
@synthesize albumnameView;
@synthesize artistnameView;
@synthesize tracknameView;

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
    
    NSLog(@"Code: %@", currentCode);
    if (currentCode == nil) {
        Secrets *credentials = [[Secrets alloc] init];
        NSString *client_id = [credentials client_id];
        
        NSProcessInfo *myProcess = [NSProcessInfo processInfo];
        NSString *version = [myProcess operatingSystemVersionString];
        
        [self.subheader setString:version];
        
        NSString *authorizeString = [NSString stringWithFormat:@"https://accounts.spotify.com/authorize?response_type=code&client_id=%@&scope=user-read-private%%20user-read-email%%20user-read-currently-playing%%20user-modify-playback-state&redirect_uri=snowspotify://callback", client_id];
        
        NSURL *url = [NSURL URLWithString:authorizeString];
        
        [[NSWorkspace sharedWorkspace] openURL:url];
    } else {
        NSLog(@"Have Code: %@", currentCode);
    }

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
    NSRect windowFrame = NSMakeRect(0,NSMaxY([[NSScreen mainScreen] frame]),600,300);
    
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
                                                           //NSResizableWindowMask |
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
    NSURL *imageUrl = [NSURL URLWithString:@"https://media.pitchfork.com/photos/642250c773370f462fd423cb/2:1/w_640,c_limit/phoebe-bridgers-taylor-swift.jpg"];
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:imageUrl];
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    [self.window.contentView addSubview:imageView];
    
    
    self.artistnameView =
    [[NSTextView alloc] initWithFrame:CGRectMake(20, 20, 200, 20)];
    [self.artistnameView setBackgroundColor: [NSColor colorWithCssDefinition:@"dodgerblue"]];
    [self.window.contentView addSubview:self.artistnameView];
    
    self.albumnameView =
    [[NSTextView alloc] initWithFrame:CGRectMake(20, 50, 200, 20)];
    [self.albumnameView setBackgroundColor: [NSColor colorWithCssDefinition:@"dodgerblue"]];
    [self.window.contentView addSubview:self.albumnameView];
    
    self.tracknameView =
        [[NSTextView alloc] initWithFrame:CGRectMake(20, 80, 200, 20)];
    [self.tracknameView setBackgroundColor: [NSColor colorWithCssDefinition:@"dodgerblue"]];
    [self.window.contentView addSubview:self.tracknameView];
    
    
    NSURL *albumimageUrl = [NSURL URLWithString:@"https://i.scdn.co/image/ab67616d0000b27371c448352f13e4eea54392cc"];
    NSImage *albumimage = [[NSImage alloc] initWithContentsOfURL:albumimageUrl];
    self.albumimageView = [[NSImageView alloc] initWithFrame:NSMakeRect(20, 100, 200, 200)];
    self.albumimageView.image = albumimage;
    [self.window.contentView addSubview:self.albumimageView];
    

    // Create the close window button without declaring it. Also, don't display it. 
    NSButton *closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(400, 30, 100, 32)];
	[closeButton setTitle: @"Close"];
    closeButton.target = self;
    [closeButton setFont: [NSFont systemFontOfSize:14]];
    [closeButton setAction:@selector(quitApplication:)];
	[closeButton setKeyEquivalentModifierMask: NSCommandKeyMask];
	[closeButton setKeyEquivalent:@"w"];
    [self.window.contentView addSubview:closeButton];

	// Create the close window button without declaring it.
    NSButton *urlButton = [[NSButton alloc] initWithFrame:NSMakeRect(400, 65, 100, 32)];
    [urlButton setTitle: @"URL"];
    urlButton.target = self;
    [urlButton setFont: [NSFont systemFontOfSize:14]];
    [urlButton setAction:@selector(urlButtonClicked:)];
    [self.window.contentView addSubview:urlButton];

    // Create the close window button without declaring it.
    NSButton *tokenButton = [[NSButton alloc] initWithFrame:NSMakeRect(400, 100, 100, 32)];
    [tokenButton setTitle: @"Token req"];
    tokenButton.target = self;
    [tokenButton setFont: [NSFont systemFontOfSize:14]];
    [tokenButton setAction:@selector(sendAccessTokenRequest:)];
    [self.window.contentView addSubview:tokenButton];
    
    // Create the close window button without declaring it.
    NSButton *getSongButton = [[NSButton alloc] initWithFrame:NSMakeRect(400, 135, 100, 32)];
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
    self.artistnameView.string = @"Authenticated!";
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
    self.artistnameView.string = @"Authenticated on set!";
    //[self.artistnameView setString:[[self.textView string] stringByAppendingString: @"Authenticated!"]];
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
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {}

- (void)urlButtonClicked:(id)sender {
    NSString *currentCode = self.code;
    
     //self.bearer_token = @"init";
    NSLog(@"Code: %@", currentCode);
    if (currentCode == nil) {
        Secrets *credentials = [[Secrets alloc] init];
        NSString *client_id = [credentials client_id];
        
        NSProcessInfo *myProcess = [NSProcessInfo processInfo];
        NSString *version = [myProcess operatingSystemVersionString];
        
        [self.subheader setString:version];
        
        NSString *authorizeString = [NSString stringWithFormat:@"https://accounts.spotify.com/authorize?response_type=code&client_id=%@&scope=user-read-private%%20user-read-email%%20user-read-currently-playing%%20user-modify-playback-state&redirect_uri=snowspotify://callback", client_id];
        
        NSURL *url = [NSURL URLWithString:authorizeString];
        
        [[NSWorkspace sharedWorkspace] openURL:url];
    } else {
        NSLog(@"Have Code: %@", currentCode);
    }
}

- (void)sendAccessTokenRequest:(id)sender {
    Secrets *credentials = [[Secrets alloc] init];
    
    NSString *client_id = [credentials client_id];
    NSString *client_secret = [credentials client_secret];
    NSString *secretSauce = [NSString stringWithFormat:@"%@:%@", client_id, client_secret];
    NSData *data = [secretSauce dataUsingEncoding:NSUTF8StringEncoding];
    //NSString *base64EncodedString = [data base64EncodedStringWithOptions:0];
    NSString *base64EncodedString = [data base64Encoding_xcd];
    //NSString *base64EncodedString = secretSauce;
    
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
    //self.receivedData = data;
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", stringData);
    self.receivedDataString = stringData; // Store the received data in the instance variable
    NSData* dataUtf = [stringData dataUsingEncoding: NSUTF8StringEncoding];
    self.receivedData = dataUtf;
    
    NSString *accessToken = @"{\"access";
    
    if ([stringData hasPrefix:accessToken]){
        NSLog(@"String contains Access Token");
        [self processReceivedData]; // Call the second method
    } else {
        [self processReceivedDataAsJson]; // Call the second method
        NSLog(@"Not an Access Token string. ");
    }
}

- (void)processReceivedDataAsJson {
    
    NSString *trackName = nil;
    NSString *artistName = nil;
    NSString *albumName = nil;
    NSString *artistArtwork = nil;
    NSString *playPauseStatus = nil;
    
    NSString *receivedDataStringName = self.receivedDataString;
    //NSData *receivedDataName = self.receivedData;
    
    /* JSONkit */
    id jsonObject = [receivedDataStringName objectFromJSONString];
    //NSLog(@"RECIEVE'D JSON %@", jsonObject);
    NSError *error = nil;
    //id jsonObject = [NSJSONSerialization JSONObjectWithData:receivedDataName options:0 error:&error];
    
    if (error){
        NSLog(@"JSON: %@", error);
        return;
    }
    
    if([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *json = (NSDictionary *)jsonObject;
        //NSLog(@"RECIEVE'D JSON %@", json);
        NSDictionary *item = [json objectForKey:@"item"];
		//NSLog(@"RECIEVE'D DICT iTEM %@", item);
		
        //NSString *timestamp = (NSString *) json[@"timestamp"];
        trackName =  [item objectForKey:@"name"];
		//NSDictionary *artistsNames = (NSDictionary *)[item objectForKey:@"artists"];
        //NSLog(@"RECIEVE'D DICT ARtists %@", artistsNames);
		//artistName = [artistsNames objectForKey:@"name"];
		artistName = [[[item objectForKey:@"artists"] objectAtIndex:0] objectForKey:@"name"];
        albumName =  [[item objectForKey:@"album"] objectForKey:@"name"];
        //artistArtwork = [[[[item objectForKey:@"album"] objectForKey:[@"images"]] objectAtIndex:0] objectForKey:@"url"];
		artistArtwork = [[[[item objectForKey:@"album"] objectForKey:@"images"] objectAtIndex:0] objectForKey:@"url"];
        
		playPauseStatus = (NSString *) [json objectForKey:@"is_playing"];
        
		//NSLog(@"timestamp: %@", timestamp);
        NSLog(@"Track Name: %@", trackName);
        NSLog(@"Artist Name: %@", artistName);
        NSLog(@"Album Name: %@", albumName);
        NSLog(@"Artist Artwork: %@", artistArtwork);
        NSLog(@"Play/Pause Status: %@", playPauseStatus);        
        
    } else {
        NSLog(@"Not a dictionary");
    }
    
	
    if (playPauseStatus != nil){
        NSURL *albumimageUrl = [NSURL URLWithString:artistArtwork];
        NSImage *albumimage = [[NSImage alloc] initWithContentsOfURL:albumimageUrl];
        albumimageView.image = albumimage;
        albumnameView.string = albumName;
        artistnameView.string = artistName;
        tracknameView.string = trackName;
    } else {
    
        NSURL *albumimageUrl = [NSURL URLWithString:@"https://www.meme-arsenal.com/memes/3db0f77b4739b6ad47b6fde22eb2de0d.jpg"];
        NSImage *albumimage = [[NSImage alloc] initWithContentsOfURL:albumimageUrl];
         
        albumimageView.image = albumimage;
    
        tracknameView.string = @"Nothing playing";
        albumnameView.string = @"";
        artistnameView.string =  @"";
        tracknameView.backgroundColor = nil;
        albumnameView.backgroundColor = nil;
        artistnameView.backgroundColor = nil;
        NSLog(@"Nothing playing");
    }

}

- (void)processReceivedData {
    NSString *receivedDataFromConnection = self.receivedDataString;
    NSArray *components = [receivedDataFromConnection componentsSeparatedByString:@":"];
    if (components.count >= 2) {
        id object = [components objectAtIndex:1];
        NSArray *bearerOfGifts = [object componentsSeparatedByString:@"\""];
        
        if (bearerOfGifts.count >= 2) {
            [[ObjectivelyCruelAppDelegate sharedInstance] setBearer_token:[bearerOfGifts objectAtIndex:1]];
            [self.albumnameView setString:@"Bearer token recieved!" ];
            [self.artistnameView setString: @"Authenticated!" ];
        } else {
            NSLog(@"Invalid bearerOfGifts array: %@", bearerOfGifts);
        }
    } else {
        NSLog(@"Invalid components array: %@", components);
    }
}

- (void) getCurrentSong: (id) sender {
    NSString *currentBear = [[ObjectivelyCruelAppDelegate sharedInstance] bearer_token];
    usleep(500);
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
