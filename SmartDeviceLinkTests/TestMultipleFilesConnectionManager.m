//
//  TestMultipleFilesConnectionManager.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TestMultipleFilesConnectionManager.h"
#import "SDLRPCRequest.h"
#import "SDLPutFile.h"
#import "SDLPutFileResponse.h"
#import "SDLNames.h"
#import "TestResponse.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TestMultipleFilesConnectionManager

- (void)sendManagerRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    [super sendManagerRequest:request withResponseHandler:handler];

    // Send a response if the request is a putfile
    if ([[request name] isEqualToString:SDLNamePutFile]) {
        SDLPutFile *putfileRequest = (SDLPutFile *)request;
        TestResponse *response = self.responses[putfileRequest.syncFileName];

        if (response == nil || handler == nil) { return; }

        handler(request, response.testResponse, response.testError);
    }
}

@end

NS_ASSUME_NONNULL_END
