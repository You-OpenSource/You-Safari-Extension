//
//  SafariExtensionHandler.swift
//  You Search Extension
//
//  Created by Thu Nguyen on 21/08/2022.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {

    struct SearchEngine {
        var name: String
        var prefixUrl: String
        var specialCode: String 
        var queryParam: String
    }
    
    // E.g. Google on URL pattern on safari:  https://www.google.com/search?client=safari&rls=en&q=hello&ie=UTF-8&oe=UTF-8
    let safariSearchEngines: [SearchEngine] = [
        SearchEngine(name: "Google", prefixUrl: "www.google.com/search?", specialCode: "client=safari&rls=en", queryParam: "q"),
        SearchEngine(name: "Bing", prefixUrl: "www.bing.com/search?", specialCode: "form=APMCS1&PC=APMC", queryParam: "q"),
        SearchEngine(name: "Yahoo", prefixUrl: "search.yahoo.com/search?", specialCode: "fr=aaplw", queryParam: "p"),
        SearchEngine(name: "DuckDuckGo", prefixUrl: "duckduckgo.com/", specialCode: "t=osx", queryParam: "q"),
        SearchEngine(name: "Ecosia", prefixUrl: "www.ecosia.org/search?", specialCode: "tts=st_asaf_macos", queryParam: "q"),
    ]
    
    var youSearchURLPattern = "https://you.com/search?q="

    func redirectUrl(url: URL) -> URL? {
        let urlString = url.absoluteString

        if let searchEngine = safariSearchEngines.first(where: { urlString.contains($0.prefixUrl) }),
           urlString.contains(searchEngine.specialCode), // is the search made from the address address
           let userQuery = URLComponents(string: urlString)?.percentEncodedQueryItems?.first(where: { $0.name ==  searchEngine.queryParam })?.value {
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
