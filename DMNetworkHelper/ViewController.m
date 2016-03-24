//
//  ViewController.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 02.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "ViewController.h"

// network helper
#import "DMNetworkHelper.h"

#import "SimpleNetworkHelper.h"

#import "SettingsManager.h"

@interface ViewController () <SimpleNetworkHelper>

@property (strong, nonatomic) NSOperation *operation;

// IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *protTextField;
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *pathTextField;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *fileTextField;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.protTextField.text = [SettingsManager defaultManager].serverProtocol;
    self.hostTextField.text = [SettingsManager defaultManager].serverHost;
    self.portTextField.text = [SettingsManager defaultManager].serverPort;
    self.pathTextField.text = [SettingsManager defaultManager].serverPath;
    
    self.usernameTextField.text = [SettingsManager defaultManager].username;
    self.passwordTextField.text = [SettingsManager defaultManager].password;
    
    self.fileTextField.text = [SettingsManager defaultManager].fileURL;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network helper

- (NSArray *)nh_listOfHelpers {
    return @[ [SimpleNetworkHelper new] ];
}

- (IBAction)sendAction:(UIButton*)sender {
    [self applySettings];
    [self saveSettings];
    
    [self startOperation];
    [self startOperation];
    [self startOperation];
    
}

- (IBAction)downloadAction:(UIButton*)sender {
    [self applySettings];
    [self saveSettings];

    [self startDownload];
}

- (void)saveSettings {
    [SettingsManager defaultManager].serverProtocol = self.protTextField.text;
    [SettingsManager defaultManager].serverHost = self.hostTextField.text;
    [SettingsManager defaultManager].serverPort = self.portTextField.text;
    [SettingsManager defaultManager].serverPath = self.pathTextField.text;
    
    [SettingsManager defaultManager].username = self.usernameTextField.text;
    [SettingsManager defaultManager].password = self.passwordTextField.text;

    [SettingsManager defaultManager].fileURL = self.fileTextField.text;
    
    [[SettingsManager defaultManager] save];
}

- (void)applySettings {
    NSString *url = [NSString stringWithFormat:@"%@://%@:%@", self.protTextField.text, self.hostTextField.text, self.portTextField.text];
    DM_NHM_SharedInstance.url = url;
    
    // AFManager
    AFHTTPSessionManager *requestManager = [DM_NHM_SharedInstance sessionManager];
    
    // Request serializer
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // bind auth credential
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

    [requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    
    requestManager.requestSerializer = requestSerializer;
    
    
}

- (void)startOperation {
    
    if (self.operation) {
        [self.operation cancel];
    }
    
    // weak self
    __weak typeof (self) weakSelf = self;
    
    self.operation = [self nh_simpleLoadWithFinishBlock:^(id result, NSError *error) {
        
        NSString *message;
        NSArray *items = result;
        
        if (error) {
            message = [NSString stringWithFormat:@"%@", error];
        } else {
            message = [NSString stringWithFormat:@"%@", items];
        }
        
        weakSelf.textView.text = message;
        
        NSLog(@"Items downloaded: %lu", (unsigned long)[items count]);
    }];
    
}

- (void)startDownload {
    // weak self
    __weak typeof (self) weakSelf = self;
    
    NSString *fileURL = self.fileTextField.text;
    
    self.operation = [self nh_loadFileAtURL:fileURL progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        NSLog(@"progress: %f", (float) totalBytesRead / totalBytesExpectedToRead);
    } withFinishBlock:^(NSString *filePath, NSError *error, NSInteger statusCode) {
        
        NSString *message;
        
        if (error) {
            message = [NSString stringWithFormat:@"%@", error];
        } else {
            message = [NSString stringWithFormat:@"File downloaded at path %@", filePath];
        }
        
        weakSelf.textView.text = message;
        
        NSLog(@"Status code: %d", (int) statusCode);
    }];
}

@end
