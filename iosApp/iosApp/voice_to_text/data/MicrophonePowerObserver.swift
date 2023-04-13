//
//  MicrophonePowerObserver.swift
//  iosApp
//
//  Created by Tal cohen harari on 13/04/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import shared
import Speech
import Combine


// private(set) = like in kotlin: var name:String? = null private set
// do{} catch{} = like in kotlin try{}catch{}
// [String: Any] = mapOf<String,Any>
class MicrophonePowerObserver: ObservableObject{
    private var cancellable: AnyCancellable? = nil
    private var audioRevorder: AVAudioRecorder? = nil
    
    @Published private(set) var micPowerRatio = 0.0
    
    private let poweRatioEmissionsPerSecond = 20.0
    
    func startObserving(){
        do{
            let recordSettings:[String : Any] = [
                AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
                AVNumberOfChannelsKey: 1
            ]
            
            // because we don't care about saving the record audio we specify the 'fileURLWithPath' to "/dev/null" (like void)
            let recorder = try AVAudioRecorder(url: URL(fileURLWithPath: "/dev/null", isDirectory: true), settings: recordSettings)
            //To get the ratio we need:
            recorder.isMeteringEnabled = true
            
            recorder.record()
            self.audioRevorder = recorder
            
            self.cancellable = Timer.publish(
                every: 1.0 / poweRatioEmissionsPerSecond,
                tolerance:  1.0 / poweRatioEmissionsPerSecond,
                on: .main, // Like Dispatchers in kotlin
                in: .common // in our common tunLoop pool
            )
            .autoconnect()
            //Like flow.collect in kotlin
            // [weak self]  = let us to set this to null
            .sink { [weak self] _ in
                //Keep the powerRatioValue upToDate
                recorder.updateMeters()
                // Get the power of ratio from channel 0 (this is the only channel we have for this feature)
                let powerOffset = recorder.averagePower(forChannel: 0)
                
                if powerOffset < -50 {
                    self?.micPowerRatio = 0.0
                }else{
                    // Convert to float with 'CGFloat'
                    let normalizedOffset = CGFloat(50 + powerOffset) / 50
                    self?.micPowerRatio = normalizedOffset
                }
            }
        }catch{
            print("An error accurred when observing microphone power: \(error.localizedDescription)")
        }
    }
    
    //Because 'sink' do not cancel himself and this class 'MicrophonePowerObserver' can distroy and sink cancel still collect values,
    // it can makes memory leak, so we should make cancalable to nil
    func release(){
        cancellable = nil
        audioRevorder?.stop()
        audioRevorder = nil
        micPowerRatio = 0.0
    }
}
