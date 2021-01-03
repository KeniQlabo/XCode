//
//  ViewController.swift
//  Movie2
//
//  Created by Obikane Kenichi on 2021/01/03.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class ViewController: UIViewController {

    
    @IBOutlet weak var playerView: PlayerView!
    var player = AVPlayer()
    var itemURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         let audioSession = AVAudioSession.sharedInstance()
         do {
             try audioSession.setCategory(.playback, mode: .moviePlayback)
         } catch {
             print("Setting category to AVAudioSessionCategoryPlayback failed.")
         }
         do {
             try audioSession.setActive(true)
             print("audio session set active !!")
         } catch {
             
         }
         
         setupPlayer()
         
         addLifeCycleObserver()
         
         addRemoteCommandEvent()
    }

    private func setupPlayer() {
           let fileName = "test"
           let fileExtension = "mp4"
           guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
               print("Url is nil")
               return
           }
           
           itemURL = url
           let item = AVPlayerItem(url: url)
           player = AVPlayer(playerItem: item)
           
           playerView.player = player
           
       }

       /// Playボタンが押された
       @IBAction func playBtnTapped(_ sender: Any) {
           player.play()
           if let url = itemURL {
               setupNowPlaying(url: url)
           }
       }
    
       @IBAction func pauseBtnTapped(_ sender: Any) {
            // test
            player.pause()
            //   playerView.player = nil
       }
    
       // MARK: Life Cycle
       func addLifeCycleObserver() {
           let center = NotificationCenter.default
           center.addObserver(self, selector: #selector(willEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
           center.addObserver(self, selector: #selector(didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
       }
       
       // フォアグラウンド移行時に呼び出されます
       @objc func willEnterForeground(_ notification: Notification) {
           /// (動画再生中であったときにそのままオーディオ再生を続ける場合は、このあとのコメントアウトをとりのぞいてください)
           /// (バックグラウンド移行時に、playerLayerからplayerがはずされているので、再度つなげます。)
           //playerView.player = player
       }
            
       // バックグラウンド移行時に呼び出されます
       @objc func didEnterBackground(_ notification: Notification) {
           /// (動画再生中であったときにそのままオーディオ再生を続ける場合は、このあとのコメントアウトをとりのぞいてください)
           //playerView.player = nil
       }
       
       // MARK: Now Playing Info
       func setupNowPlaying(url: URL) {
           // Define Now Playing Info
           var nowPlayingInfo = [String : Any]()
           
           // ここでは、urlのlastPathComponentを表示しています。
           nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = url
           nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = MPNowPlayingInfoMediaType.video.rawValue
           nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = false
           nowPlayingInfo[MPMediaItemPropertyTitle] = url.lastPathComponent
           nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = ""
           
           // Set the metadata
           MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
       }
       
       // MARK: Remote Command Event
       func addRemoteCommandEvent() {
           
           let commandCenter = MPRemoteCommandCenter.shared()
           commandCenter.togglePlayPauseCommand.addTarget{ [unowned self] commandEvent -> MPRemoteCommandHandlerStatus in
               self.remoteTogglePlayPause(commandEvent)
               return MPRemoteCommandHandlerStatus.success
           }
           commandCenter.playCommand.addTarget{ [unowned self] commandEvent -> MPRemoteCommandHandlerStatus in
               self.remotePlay(commandEvent)
               return MPRemoteCommandHandlerStatus.success
           }
           commandCenter.pauseCommand.addTarget{ [unowned self] commandEvent -> MPRemoteCommandHandlerStatus in
               self.remotePause(commandEvent)
               return MPRemoteCommandHandlerStatus.success
           }
           commandCenter.nextTrackCommand.addTarget{ [unowned self] commandEvent -> MPRemoteCommandHandlerStatus in
               self.remoteNextTrack(commandEvent)
               return MPRemoteCommandHandlerStatus.success
           }
           commandCenter.previousTrackCommand.addTarget{ [unowned self] commandEvent -> MPRemoteCommandHandlerStatus in
               self.remotePrevTrack(commandEvent)
               return MPRemoteCommandHandlerStatus.success
           }
       }
       
       func remoteTogglePlayPause(_ event: MPRemoteCommandEvent) {
           // イヤホンのセンターボタンを押した時の処理
           // (略)
       }
       
       func remotePlay(_ event: MPRemoteCommandEvent) {
           player.play()
       }
       
       func remotePause(_ event: MPRemoteCommandEvent) {
           player.pause()
       }

       func remoteNextTrack(_ event: MPRemoteCommandEvent) {
           // 「次へ」ボタンが押された時の処理
           // （略）
       }
       
       func remotePrevTrack(_ event: MPRemoteCommandEvent) {
           // 「前へ」ボタンが押された時の処理
           // （略）
           
       }
   
}

