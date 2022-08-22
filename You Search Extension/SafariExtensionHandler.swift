//
//  SafariExtensionHandler.swift
//  You Search Extension
//
//  Created by Thu Nguyen on 21/08/2022.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    // Google on URL pattern on safari:  https://www.google.com/search?client=safari&rls=en&q=hello&ie=UTF-8&oe=UTF-8
    var googleSafariURLPattern = "google.com/search?client"
    var googleQueryParam = "q"
    var youSearchURLPattern = "https://you.com/search?q="

    func redirectUrl(url: URL) -> URL? {
       let urlString = url.absoluteString

        if (urlString.contains(googleSafariURLPattern)),
            let userQuery = URLComponents(string: urlString)?.percentEncodedQueryItems?.first(where: { $0.name ==  googleQueryParam })?.value {
               return URL(string: youSearchURLPattern + userQuery)!
           }
        return nil
    }
    
    override func page(_ page: SFSafariPage, willNavigateTo url: URL?) {
        guard UserDefaults.standard.bool(forKey: SafariExtensionViewController.enableExtensionState),
              let url = url,
              let YouSearchUrl = self.redirectUrl(url: url) else {
            return
        }
        page.getContainingTab { tab in
            tab.navigate(to: YouSearchUrl)
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
}
