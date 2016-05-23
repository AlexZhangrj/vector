#import "BonjourClientAppDelegate.h"
#import "GCDAsyncSocket.h"





// Log levels: off, error, warn, info, verbose

@interface BonjourClientAppDelegate (Private)
- (void)connectToNextAddress;
@end

#pragma mark -

@implementation BonjourClientAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Configure logging framework

	// Start browsing for bonjour services
	
	netServiceBrowser = [[NSNetServiceBrowser alloc] init];
	
	[netServiceBrowser setDelegate:self];
	[netServiceBrowser searchForServicesOfType:@"_YourServiceName._tcp." inDomain:@"local."];
    [self connectToAddress];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didNotSearch:(NSDictionary *)errorInfo
{
	NSLog(@"DidNotSearch: %@", errorInfo);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
           didFindService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing
{
	NSLog(@"DidFindService: %@", [netService name]);
	
	// Connect to the first service we find
	
	if (serverService == nil)
	{
		NSLog(@"Resolving...");
		
		serverService = netService;
		
		[serverService setDelegate:self];
		[serverService resolveWithTimeout:5.0];
	}
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
         didRemoveService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing
{
	NSLog(@"DidRemoveService: %@", [netService name]);
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)sender
{
	NSLog(@"DidStopSearch");
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
	NSLog(@"DidNotResolve");
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	NSLog(@"DidResolve: %@", [sender addresses]);
	
	if (serverAddresses == nil)
	{
		serverAddresses = [[sender addresses] mutableCopy];
	}
	
	if (asyncSocket == nil)
	{
		asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		
		[self connectToNextAddress];
	}
}

- (void)connectToNextAddress
{
	BOOL done = NO;
	
	while (!done && ([serverAddresses count] > 0))
	{
		NSData *addr;
		
		// Note: The serverAddresses array probably contains both IPv4 and IPv6 addresses.
		// 
		// If your server is also using GCDAsyncSocket then you don't have to worry about it,
		// as the socket automatically handles both protocols for you transparently.
		
		if (YES) // Iterate forwards
		{
			addr = [serverAddresses objectAtIndex:0];
			[serverAddresses removeObjectAtIndex:0];
		}
		else // Iterate backwards
		{
			addr = [serverAddresses lastObject];
			[serverAddresses removeLastObject];
		}
		
		NSLog(@"Attempting connection to %@", addr);
		
		NSError *err = nil;
		if ([asyncSocket connectToAddress:addr error:&err])
		{
			done = YES;
		}
		else
		{
			NSLog(@"Unable to connect: %@", err);
		}
		
	}
	
	if (!done)
	{
		NSLog(@"Unable to connect to any resolved address");
	}
}

- (void)connectToAddress
{
 
    NSError * error;
    static GCDAsyncSocket * socket = NULL;
    socket = [[GCDAsyncSocket  alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    BOOL result = [socket connectToHost:@"192.168.1.5" onPort:8000 error:&error];
    
    NSLog(@"result: %ld", result);
    return;
    BOOL done = NO;
    
    while (!done && ([serverAddresses count] > 0))
    {
//        NSData *addr;
        
        // Note: The serverAddresses array probably contains both IPv4 and IPv6 addresses.
        //
        // If your server is also using GCDAsyncSocket then you don't have to worry about it,
        // as the socket automatically handles both protocols for you transparently.
        
//        if (YES) // Iterate forwards
//        {
//            addr = [serverAddresses objectAtIndex:0];
//            [serverAddresses removeObjectAtIndex:0];
//        }
//        else // Iterate backwards
//        {
//            addr = [serverAddresses lastObject];
//            [serverAddresses removeLastObject];
//        }
        
//        NSLog(@"Attempting connection to %@", addr);
//        
//        NSError *err = nil;
//        if ([asyncSocket connectToAddress:addr error:&err])
//        {
//            done = YES;
//        }
//        else
//        {
//            NSLog(@"Unable to connect: %@", err);
//        }
        
    }
    
    if (!done)
    {
        NSLog(@"Unable to connect to any resolved address");
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"Socket:DidConnectToHost: %@ Port: %hu", host, port);
	
	connected = YES;
    
    NSString *str = @"Socket:DidConnectToHost:";
    [sock writeData:[str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:15 tag:10];
    [sock readDataWithTimeout:-1 tag:100];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"SocketDidDisconnect:WithError: %@", err);
	
	if (!connected)
	{
		[self connectToNextAddress];
	}
}

@end
