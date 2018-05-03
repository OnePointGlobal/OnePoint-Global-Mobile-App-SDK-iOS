//
//  Created by Erik Huisman
//

#import "OPG.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface OpenSettings : OPGPlugin<CBPeripheralManagerDelegate,CBCentralManagerDelegate> { }
@property (retain) CBPeripheralManager *peripheralManager;

- (void)settings:(OPGInvokedUrlCommand*)command;
- (void)bluetooth:(OPGInvokedUrlCommand*)command;
- (void)bluetoothStatus:(OPGInvokedUrlCommand*)command;

@end
