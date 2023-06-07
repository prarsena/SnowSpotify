//
//  ColorPanelWindowController.h
//  ObjectivelyCruel
//
//  Created by Peter Arsenault on 6/3/23.
//

#import <Cocoa/Cocoa.h>

@interface ColorPanelWindowController : NSWindowController


@property (assign) NSButton *button;
//@property (assign) NSTextView *pageHeader;
@property (assign) NSRect *windowFrame;
//@property (assign) NSWindow *colorPanelWindow;

- (NSWindow *)goOnMakeWindow;
- (id)initWithCustomWindow;
- (void)closeWindow:(id)sender;

@end
