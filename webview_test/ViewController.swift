//
//  ViewController.swift
//  webview_test
//
//  Created by 강동욱 on 2021/09/25.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    

        loadHelpPage()
   
    
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard Reachability.networkConnected() else {
                    let alert = UIAlertController(title: "NetworkError", message: "네트워크가 연결되어있지 않습니다.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "종료", style: .default) { (action) in
                        exit(0)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
    }

    @IBAction func backAction(_ sender: Any) {
        
        if (webView.canGoBack) {
            webView.goBack()
        } else {
            print("no back page")
        }
    }
    
    
    
    @IBAction func forwordBtn(_ sender: Any) {
        
        if (webView.canGoForward) {
            webView.goForward()
        } else {
            print("no forward Page")
        }
    }
    func loadHelpPage() {
        if #available(iOS 14.0, *) {
            webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            // Fallback on earlier versions
            webView.configuration.preferences.javaScriptEnabled = true
        }
        
        // 자바스크립트 -> 네이티브 앱 연결
        // 브리지 등록
        webView.configuration.userContentController.add(self, name: "receiveFromJS")
        
        // 웹 파일 로딩
//        webView.uiDelegate = self
//        webView.navigationDelegate = self
        
        let pageName = "index"
//        guard let url = Bundle.main.url(forResource: pageName, withExtension: "html", subdirectory: "webpage") else {
//            return
//        }
        let urlString = "http://localhost:3000"
        let naverUrl = URL(string: urlString)
        let request = URLRequest(url: naverUrl!)
        
        webView.load(request)
//        webView.loadFileURL(url, allowingReadAccessTo: url)

    }
}

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        switch message.name {
            case "receiveFromJS":
                let alert = UIAlertController(title: "자바스크립트로부터 받은 메시지", message: message.body as? String, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(alertAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            case "logHandler":
                print("console log:", message.body)
            default:
                print("default")
                break
            }
    }
    
}
