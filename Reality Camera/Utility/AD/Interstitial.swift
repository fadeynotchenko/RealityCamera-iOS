//
//  I.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 25.10.2023.


import YandexMobileAds
import SwiftUI

struct AdView: UIViewControllerRepresentable {
    
    @ObservedObject var model: USDZ3DModel
    @Binding var isAdViewShow: Bool
    
    func makeUIViewController(context: Context) -> InterstitialAdViewController {
        let view = InterstitialAdViewController(model: model, isAdViewShow: $isAdViewShow)
        view.loadAd()
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: InterstitialAdViewController, context: Context) {
    }
}

final class InterstitialAdViewController: UIViewController {
    
    private var model: USDZ3DModel
    private var isAdViewShowBinding: Binding<Bool>
    
    private var interstitialAd: YMAInterstitialAd?
    
    private lazy var interstitialAdLoader: YMAInterstitialAdLoader = {
        let loader = YMAInterstitialAdLoader()
        loader.delegate = self
        
        return loader
    }()
    
    init(model: USDZ3DModel, isAdViewShow: Binding<Bool>) {
        self.model = model
        self.isAdViewShowBinding = isAdViewShow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAd() {
        let configuration = YMAAdRequestConfiguration(adUnitID: "demo-interstitial-yandex")
        self.interstitialAdLoader.loadAd(with: configuration)
    }
    
}

extension InterstitialAdViewController: YMAInterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: YMAInterstitialAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        
    }
    
    func interstitialAdLoader(_ adLoader: YMAInterstitialAdLoader, didLoad interstitialAd: YMAInterstitialAd) {
        self.interstitialAd = interstitialAd
        self.interstitialAd!.delegate = self
        
        self.interstitialAd!.show(from: self)
    }
}

extension InterstitialAdViewController: YMAInterstitialAdDelegate {
    func interstitialAdDidDismiss(_ interstitialAd: YMAInterstitialAd) {
        self.model.isAdViewed = true
        
        self.isAdViewShowBinding.wrappedValue.toggle()
    }
}
