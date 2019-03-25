//
//  SimplePingHelper.m
//  iTSC
//
//  Created by tss on 2019/3/25.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MySimplePingDelegate.h"

@implementation MySimplePingDelegate


//////////////////////////////////////////// MARK: pinger delegate callback ////////////////////////////////////////////
// 解析 HostName 拿到 ip 地址之后，发送封包
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
    NSLog(@"MySimplePingDelegate: didStartWithAddress.");
    //NSLog(@"pinging %@", displayAddressForAddress(address));
    
    // Send the first ping straight away.
    
    
    // And start a timer to send the subsequent pings.
    //assert(sendTimer == nil);
    //sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPing) userInfo: nil repeats: true];
    //NSLog(@"pinging %@", pinger.hostAddress. ];
    //NSLog(@"pinging %@", displayAddressForAddress(address));
    
    [pinger sendPingWithData:nil];
}

// ping 功能启动失败
- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
    NSLog(@"MySimplePingDelegate: didFailWithError.");
    //NSLog(@"failed: %@", shortErrorFromError(error));
    //stop();
}

// ping 成功发送封包
- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    NSLog(@"MySimplePingDelegate: didSendPacket: #%u sent", sequenceNumber);
}
// ping 发送封包失败
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error
{
    NSLog(@"MySimplePingDelegate: didFailToSendPacket: #%u sent", sequenceNumber);
    // NSLog(@"#%u send failed: %@", sequenceNumber, shortErrorFromError(error));
}

// ping 发送封包之后收到响应
- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    NSLog(@"MySimplePingDelegate: didReceivePingResponsePacket: #%u received, size=%zu", sequenceNumber, packet.length);
}
// ping 接收响应封包发生异常
-(void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
    NSLog(@"MySimplePingDelegate: didReceiveUnexpectedPacket: unexpected packet, size=%zu", packet.length);
}











//////////////////////////////////////////// MARK: utilities ////////////////////////////////////////////
/// Returns the string representation of the supplied address.
///
/// - parameter address: Contains a `(struct sockaddr)` with the address to render.
///
/// - returns: A string representation of that address.

+(NSString*) displayAddressForAddress:(NSData*) address
{
    //var hostStr = [Int8](count: Int(NI_MAXHOST), repeatedValue: 0)
    /*
     //bool success =
     getnameinfo(
     address.bytes),
     socklen_t(address.length),
     &hostStr,
     socklen_t(hostStr.count),
     nil,
     0,
     NI_NUMERICHOST
     ) ;//== 0;
     */
    NSString* result;
    /*
     if (success)
     {
     result = String.fromCString(hostStr)!
     }
     else
     {
     result = "?"
     }
     */
    return result;
}


/// Returns a short error string for the supplied error.
///
/// - parameter error: The error to render.
///
/// - returns: A short string representing that error.

+(NSString*) shortErrorFromError:(NSError*) error
{
    /*
     if (error.domain == kCFErrorDomainCFNetwork && error.code == [CFNetworkErrors.CFHostErrorUnknown.rawValue intvalue])
     {
     NSString* failureObj = error.userInfo[kCFGetAddrInfoFailureKey];
     
     NSNumber ailureNum = failureObj;// as? NSNumber
     
     if (failureNum.intValue != 0)
     {
     f = gai_strerror(failureNum.intValue)
     if f != nil {
     return String.fromCString(f)!
     }
     }
     }
     }
     }
     if let result = error.localizedFailureReason {
     return result
     }
     */
    return error.localizedDescription;
}


/*
 // MARK: table view delegate callback
 
 @IBOutlet var forceIPv4Cell: UITableViewCell!
 @IBOutlet var forceIPv6Cell: UITableViewCell!
 @IBOutlet var startStopCell: UITableViewCell!
 
 override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 let cell = self.tableView.cellForRowAtIndexPath(indexPath)!
 switch cell {
 case forceIPv4Cell, forceIPv6Cell:
 cell.accessoryType = cell.accessoryType == .None ? .Checkmark : .None
 case startStopCell:
 if self.pinger == nil {
 let forceIPv4 = self.forceIPv4Cell.accessoryType != .None
 let forceIPv6 = self.forceIPv6Cell.accessoryType != .None
 self.start(forceIPv4: forceIPv4, forceIPv6: forceIPv6)
 } else {
 self.stop()
 }
 default:
 fatalError()
 }
 self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
 }
 
 func pingerWillStart() {
 self.startStopCell.textLabel!.text = "Stop…"
 }
 
 func pingerDidStop() {
 self.startStopCell.textLabel!.text = "Start…"
 }*/




@end
