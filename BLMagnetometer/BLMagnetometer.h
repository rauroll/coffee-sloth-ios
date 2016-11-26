//
//  BLMagnetometer.h
//  BLMagnetometer
//
//  Created by Oskar Vuola on 25/11/16.
//  Copyright © 2016 blastly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BLMagnetometer : NSObject <CLLocationManagerDelegate>

- (NSArray *)latestMagnetometerData;
- (void)startMagnetometerUpdates;
- (void)stopMagnetometerUpdates;
- (void)calibrate;

@end
