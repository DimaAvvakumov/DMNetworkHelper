//
//  ViewController.m
//  DMNetworkHelper
//
//  Created by Avvakumov Dmitry on 02.12.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "ViewController.h"

#import "DMNetworkHelperManager.h"

#import "SimpleNetworkHelper.h"

#import "SettingsManager.h"

@interface ViewController ()

@property (strong, nonatomic) SimpleNetworkHelper *networkHelper;

@property (strong, nonatomic) NSOperation *operation;

// IBOutlets
@property (weak, nonatomic) IBOutlet UITextField *protTextField;
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *pathTextField;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.networkHelper = [SimpleNetworkHelper new];
    
    self.protTextField.text = [SettingsManager defaultManager].serverProtocol;
    self.hostTextField.text = [SettingsManager defaultManager].serverHost;
    self.portTextField.text = [SettingsManager defaultManager].serverPort;
    self.pathTextField.text = [SettingsManager defaultManager].serverPath;
    
    self.usernameTextField.text = [SettingsManager defaultManager].username;
    self.passwordTextField.text = [SettingsManager defaultManager].password;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(UIButton*)sender {
    [self applySettings];
    [self saveSettings];
    
    [self startOperation];
    [self startOperation];
    [self startOperation];
    
}

- (void)saveSettings {
    [SettingsManager defaultManager].serverProtocol = self.protTextField.text;
    [SettingsManager defaultManager].serverHost = self.hostTextField.text;
    [SettingsManager defaultManager].serverPort = self.portTextField.text;
    [SettingsManager defaultManager].serverPath = self.pathTextField.text;
    
    [SettingsManager defaultManager].username = self.usernameTextField.text;
    [SettingsManager defaultManager].password = self.passwordTextField.text;
    
    [[SettingsManager defaultManager] save];
}

- (void)applySettings {
    DM_NHM_SharedInstance.protocol = self.protTextField.text;
    DM_NHM_SharedInstance.host = self.hostTextField.text;
    DM_NHM_SharedInstance.port = self.portTextField.text;
    
    // AFManager
    AFHTTPRequestOperationManager *requestManager = [DM_NHM_SharedInstance operationManager];
    
    // Request serializer
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    requestManager.requestSerializer = requestSerializer;
    
    // bind auth credential
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSURLCredential *credential = [[NSURLCredential alloc] initWithUser:username password:password persistence:NSURLCredentialPersistenceForSession];
    [requestManager setCredential:credential];
    
}

- (void)startOperation {
    
    if (self.operation) {
        [self.operation cancel];
    }
    
    // weak self
    __weak typeof (self) weakSelf = self;
    
    self.operation = [self.networkHelper nh_simpleLoadWithFinishBlock:^(NSArray *items, NSError *error) {
        
        NSString *message;
        
        if (error) {
            message = [NSString stringWithFormat:@"%@", error];
        } else {
            message = [NSString stringWithFormat:@"%@", items];
        }
        
        weakSelf.textView.text = message;
        
        NSLog(@"Items downloaded: %lu", (unsigned long)[items count]);
    }];
    
}

@end
