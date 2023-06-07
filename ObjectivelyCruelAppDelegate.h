//
//  ObjectivelyCruelAppDelegate.h
//  ObjectivelyCruel
//
//  Created by petera on 6/3/23.
//  Copyright 2023 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface ObjectivelyCruelAppDelegate : NSObject <NSApplicationDelegate, NSURLConnectionDelegate> {
    NSWindow *window;
	NSTextField *textField;
    
    NSButton *button;
    NSButton *colorButton;
    
    NSTextView *textView;
    NSTextView *pageHeader;
	NSTextView *subheader;
    NSString *receivedDataString;
    //NSString *bearer_token;
	
	NSMenu *menu;
}

@property (assign) NSWindow *window;
@property (assign) NSTextField *textField;
@property (assign) NSButton *button;
@property (assign) NSButton *colorButton;
@property (assign) NSTextView *textView;
@property (assign) NSTextView *pageHeader;
@property (assign) NSTextView *subheader;
@property (assign) NSString *code;
@property (assign) NSString *receivedDataString;
@property (assign) NSString *bearer_token;

@property (assign) ObjectivelyCruelAppDelegate *delegate;

@property (assign) NSWindowController *colorPanelWindowController;
@property (assign) NSMenu *menu;

+ (ObjectivelyCruelAppDelegate *)sharedInstance;
//- (id) init;

- (void)sendAccessTokenRequest:(id)sender;
- (void)buttonClicked:(id)sender;
- (void)showPreferences:(id)sender;
- (void)quitApplication:(id)sender;
- (void) getCurrentSong: (id) sender;

- (NSString *) getGlobalCode: (id) sender;
- (NSString *)code; // Declare the getter method
- (void)setCode:(NSString *)code; // Declare the setter method

- (NSString *) getGlobalBearer: (id) sender;
- (NSString *)bearer_token; // Declare the getter method
- (void)setBearer_token:(NSString *)bearer_token; // Declare the setter method


@end
