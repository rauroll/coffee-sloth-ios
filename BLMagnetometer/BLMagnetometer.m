//
//  BLMagnetometer.m
//  BLMagnetometer
//
//  Created by Oskar Vuola on 25/11/16.
//  Copyright © 2016 blastly. All rights reserved.
//

#import "BLMagnetometer.h"

@interface BLMagnetometer ()

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *smoothingArray;
@property (nonatomic, strong) NSArray *latestSmoothedData;
@property (nonatomic, strong) NSArray *latestData;
@property (nonatomic, strong) NSArray *calibrationData;


@end


@implementation BLMagnetometer

- (instancetype)init {
    self = [super init];
    
    // setup the location manager
    _locationManager = [[CLLocationManager alloc] init];
    
    // check if the hardware has a compass
    if ([CLLocationManager headingAvailable] == NO) {
        // No compass is available. This application cannot function without a compass,
        // so a dialog will be displayed and no magnetic data will be measured.
        return nil;
    } else {
        // heading service configuration
        self.locationManager.headingFilter = kCLHeadingFilterNone;
        
        // setup delegate callbacks
        self.locationManager.delegate = self;
    }
    
    // Latest data: X, Y, Z, Total, Direction
    _latestSmoothedData = @[@(0),@(0),@(0),@(0),@(0)];
    
    // Latest raw values from magnetometer, used for calibration
    _latestData = @[@(0),@(0),@(0)];
    
    // Calibration values
    _calibrationData = [NSArray arrayWithObjects:@(0), @(0), @(0), nil];
    
    return self;
}

- (void)initializeLatest {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        for (int j = 0; j < 3; j++) {
            [data addObject:@0];
        }
        [array addObject:data];
    }
    _smoothingArray = array;
}


- (void)startMagnetometerUpdates {
    // Initialize smoothing array
    [self initializeLatest];
    // start the compass
    [self.locationManager startUpdatingHeading];
}

- (void)stopMagnetometerUpdates {
    [self.locationManager stopUpdatingHeading];
}

// This delegate method is invoked when the location manager has heading data.
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    // Update the labels with the raw x, y, and z values.
    
    _latestData = [NSArray arrayWithObjects:@(heading.x), @(heading.y), @(heading.z), nil];
    
    [self updateSmoothedDataWithX:heading.x Y:heading.y Z:heading.z];
    
    NSArray *smoothedValues = [self smoothedData];
    
    
    float smoothed_x = [smoothedValues[0] floatValue];
    float smoothed_y = [smoothedValues[1] floatValue];
    float smoothed_z = [smoothedValues[2] floatValue];
    
    float calibration_x = [_calibrationData[0] floatValue];
    float calibration_y = [_calibrationData[1] floatValue];
    float calibration_z = [_calibrationData[2] floatValue];
    
    
    //NSLog(@"smoothed: x: %.2f, y: %.2f, z: %.2f", smoothed_x, smoothed_y, smoothed_z);
    //NSLog(@"new: x: %.2f, y: %.2f, z: %.2f", heading.x, heading.y, heading.z);
    
    int calibration_sign_x = signum(calibration_x);
    int calibration_sign_y = signum(calibration_y);
    
    
    int smooth_x_sign = signum(smoothed_x);
    int smooth_y_sign = signum(smoothed_y);
    
    int direction = 0; // Default rotation based on calibration
    
    
    if (calibration_sign_x != smooth_x_sign && calibration_sign_y == smooth_y_sign) {
        // Rotation towards ??
        direction = 1;
    } else if (calibration_sign_x == smooth_x_sign && calibration_sign_y != smooth_y_sign) {
        // Rotation towards ??
        direction = 2;
    }
    
    
    float calibrated_x = smoothed_x - calibration_x;
    float calibrated_y = smoothed_y - calibration_y;
    float calibrated_z = smoothed_z - calibration_z;
    
    double total = pow(calibrated_x, 2) + pow(calibrated_y, 2);
    total = sqrt(total);
    
    _latestSmoothedData = @[@(calibrated_x), @(calibrated_y), @(calibrated_z), @(total), @(direction)];
}

- (NSArray *)smoothedData {
    float smoothed_x = 0.0f;
    float smoothed_y = 0.0f;
    float smoothed_z = 0.0f;
    
    for (int i = 0; i < 10; i++) {
        smoothed_x += [_smoothingArray[i][0] floatValue];
        smoothed_y += [_smoothingArray[i][1] floatValue];
        smoothed_z += [_smoothingArray[i][2] floatValue];
    }
    
    
    smoothed_x = smoothed_x / 10;
    smoothed_y = smoothed_y / 10;
    smoothed_z = smoothed_z / 10;
    
    
    return [NSArray arrayWithObjects:@(smoothed_x), @(smoothed_y), @(smoothed_z), nil];
}

- (void)updateSmoothedDataWithX:(float)x Y:(float)y Z:(float)z {
    for (int i = 0; i < 9; i++) {
        _smoothingArray[i+1][0] = _smoothingArray[i][0];
        _smoothingArray[i+1][1] = _smoothingArray[i][1];
        _smoothingArray[i+1][2] = _smoothingArray[i][2];
    }
    
    _smoothingArray[0][0] = [NSNumber numberWithFloat:x];
    _smoothingArray[0][1] = [NSNumber numberWithFloat:y];
    _smoothingArray[0][2] = [NSNumber numberWithFloat:z];
    
}

#pragma mark -

// This delegate method is invoked when the location managed encounters an error condition.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        // This error indicates that the user has denied the application's request to use location services.
        [manager stopUpdatingHeading];
    } else if ([error code] == kCLErrorHeadingFailure) {
        // This error indicates that the heading could not be determined, most likely because of strong magnetic interference.
    }
}

#pragma mark -

- (NSArray *)latestMagnetometerData {
    return _latestSmoothedData;
}

- (void)calibrate {
    float calibration_x = [_latestData[0] floatValue];
    float calibration_y = [_latestData[1] floatValue];
    float calibration_z = [_latestData[2] floatValue];
    
    _calibrationData = [NSArray arrayWithObjects:@(calibration_x), @(calibration_y), @(calibration_z), nil];
}

// Sign function

int signum(float n) { return (n < 0) ? -1 : (n > 0) ? +1 : 0; }

@end
