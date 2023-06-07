//
//  main.m
//  ObjectivelyCruel
//
//  Created by petera on 6/3/23.
//  Copyright 2023 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "ObjectivelyCruelAppDelegate.h"

NSString *globalCode = nil;

void HandleOpenURL(const AppleEvent *event, AppleEvent *reply, SRefCon refCon) {
    NSString *urlString = nil;
    NSString *code = nil;
    NSURL *url = nil;
    
    if (AEGetParamDesc(event, keyDirectObject, typeChar, (AEDesc *)&urlString) == noErr) {
        DescType actualType;
        Size actualSize;
        AEGetParamPtr(event, keyDirectObject, typeChar, &actualType, NULL, NULL, &actualSize);
        
        char *cString = malloc(actualSize + 1);
        AEGetParamPtr(event, keyDirectObject, typeChar, NULL, cString, actualSize, NULL);
        cString[actualSize] = '\0';
        
        urlString = [NSString stringWithUTF8String:cString];
        free(cString);
        
        url = [NSURL URLWithString:urlString];
        AEDisposeDesc((AEDesc *)&urlString);
    }
    NSArray *components = [url.query componentsSeparatedByString:@"="];
    code = (NSString *) components[1];
    //NSLog(@"Code from URL: %@", code);
    globalCode = code; // Store the code in the global variable

    NSString *newCode = globalCode; // Assign the value from globalCode to a local variable
    
    [[ObjectivelyCruelAppDelegate sharedInstance] setCode:newCode];
}

int main(int argc, char *argv[])
{
    ObjectivelyCruelAppDelegate *delegate = [[ObjectivelyCruelAppDelegate alloc] init];
    
    NSApplication *application = [NSApplication sharedApplication];
    [application setDelegate:delegate];
    
    // Install the AppleEvent handler
    OSErr err = AEInstallEventHandler(kInternetEventClass, kAEGetURL, NewAEEventHandlerUPP(HandleOpenURL), 0, false);
    
    if (err != noErr) {
        NSLog(@"Failed to install AppleEvent handler: %d", err);
        return -1;
    }
    
	[application run];
    return 0;
}
