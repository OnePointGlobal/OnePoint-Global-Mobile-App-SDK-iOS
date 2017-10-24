//
//  Created by Erik Huisman
//

#import "OpenSettings.h"
#import "OPG.h"

@implementation OpenSettings


-(void) settings:(OPGInvokedUrlCommand*)command {

    OPGPluginResult* pluginResult = nil;

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

    // TODO check if is iOS8 otherwise error
    pluginResult = [OPGPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) bluetooth:(OPGInvokedUrlCommand*)command {

    OPGPluginResult* pluginResult = nil;

    [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    // TODO check if is iOS8 otherwise error
    pluginResult = [OPGPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) bluetoothStatus:(OPGInvokedUrlCommand*)command {

  OPGPluginResult* pluginResult = nil;
  NSString *stateName = [self peripherialStateAsString:_peripheralManager.state];

  NSLog(@"Current bt status: %@", stateName);
  NSDictionary *dict = @{@"status": stateName};

  pluginResult = [OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)pluginInitialize {
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral { }

- (NSString*) peripherialStateAsString: (CBPeripheralManagerState) state {
    NSDictionary *dict = @{@(CBPeripheralManagerStatePoweredOff): @"PeripheralManagerStatePoweredOff",
                           @(CBPeripheralManagerStatePoweredOn): @"PeripheralManagerStatePoweredOn",
                           @(CBPeripheralManagerStateResetting): @"PeripheralManagerStateResetting",
                           @(CBPeripheralManagerStateUnauthorized): @"PeripheralManagerStateUnauthorized",
                           @(CBPeripheralManagerStateUnknown): @"PeripheralManagerStateUnknown",
                           @(CBPeripheralManagerStateUnsupported): @"PeripheralManagerStateUnsupported"};
    return [dict objectForKey:[NSNumber numberWithInteger:state]];
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}
@end
