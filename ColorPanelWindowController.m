//
//  ColorPanelWindowController.m
//  ObjectivelyCruel
//
//  Created by Peter Arsenault on 6/3/23.
//

#import "ColorPanelWindowController.h"
#import "nscolor-colorWithCssDefinition.h"
#include <AvailabilityMacros.h>
#include <Availability.h>

@implementation ColorPanelWindowController

@synthesize button;
@synthesize windowFrame;

- (id)initWithCustomWindow {
	NSWindow *window = [self goOnMakeWindow];
	self = [super initWithWindow:window];
	if (self) { 
		NSLog(@"self");
	}
	return self;
}

- (NSWindow *)goOnMakeWindow {
    
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_6
	NSRect windowFrame = NSMakeRect(200,200,1020,600);
	NSWindow *colorPanelWindow = [[NSWindow alloc] initWithContentRect: windowFrame
															 styleMask: NSWindowStyleMaskTitled    |
								  NSWindowStyleMaskResizable |
								  NSWindowStyleMaskClosable  |
								  NSWindowStyleMaskMiniaturizable
															   backing: NSBackingStoreBuffered
																 defer: NO];
    NSLog(@"Found greater os than snow in the PANEL" );
#else
	NSWindow *colorPanelWindow = [[NSWindow alloc] initWithContentRect: NSMakeRect(200,200,1020,600)
															 styleMask:   NSTitledWindowMask |
								  NSResizableWindowMask |
								  NSMiniaturizableWindowMask |
								  NSClosableWindowMask
															   backing: NSBackingStoreBuffered
																 defer: NO];
    NSLog(@"Found os x snow in the PANEL" );
#endif 
	
	colorPanelWindow.title = @"Color Panel";
	
	NSArray *keys = [NSColor allKeysFromDictionary];
	
	CGFloat yOffset = 5.0;
	CGFloat xOffset = 5.0;
	NSInteger i = 0;
	
	for (id object in keys) {
		
		NSTextView *textView =
		[[NSTextView alloc] initWithFrame:CGRectMake(xOffset, yOffset, 120, 20)];
		textView.string = object;
		
		NSColor *cssColorRepresentation = [NSColor colorWithCssDefinition:object];
		textView.backgroundColor = cssColorRepresentation;
		
		yOffset += textView.frame.size.height + 10;
		if ((i + 1) % 20 == 0) {
			xOffset += 130.0;
			yOffset = 5.0;
		}
		i++;
		
		[colorPanelWindow.contentView addSubview:textView];
	}
	
	// Create the button	
	button = [[NSButton alloc] initWithFrame:NSMakeRect(920, 100, 80, 32)];
	[button setTitle: @"Close"];
	[button setBordered: YES];
	[button setFont: [NSFont systemFontOfSize:14]];
	[button setTarget:self];	
	[button setKeyEquivalentModifierMask: NSCommandKeyMask];
	[button setKeyEquivalent:@"w"];
	[button setAction:@selector(closeWindow:)];
	[colorPanelWindow.contentView addSubview:self.button];
    
	
    return colorPanelWindow;
}

- (void) closeWindow:(id)sender {
    NSLog(@"Close");
    [self close];
}

@end
