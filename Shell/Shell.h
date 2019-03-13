//
//  Shell.h
//  Shell
//
//  Created by vin on 13.03.19.
//

#import <Foundation/Foundation.h>
#import "ShellProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface Shell : NSObject <ShellProtocol>
@end
