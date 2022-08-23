//
//  SafariExtensionViewController.swift
//  You Search Extension
//
//  Created by Thu Nguyen on 21/08/2022.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    @IBOutlet weak var enableExtensionCheck: NSButton!

    @IBAction func test(_ sender: Any) {
    }
    
    static let enableExtensionState = "off"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        enableExtensionCheck.state = UserDefaults.standard.bool(forKey: SafariExtensionViewController.enableExtensionState) ? .on : .off
    }

    @IBAction func enableExtensionCheckboxClicked(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state == .on, forKey: SafariExtensionViewController.enableExtensionState)
    }

    static let shared: SafariExtensionViewController = {
         let shared = SafariExtensionViewController()
         shared.preferredContentSize = NSSize(width:242, height:90)
         return shared
    }()

    @IBAction func openUserFeedBack(_ sender: Any) {
        SFSafariApplication.getActiveWindow { window in
            window?.openTab(
                with: URL(string: "https://form.asana.com/?k=tX8hVzLPkH3PG6TXv-A26g&d=1193569441872791")!,
                makeActiveIfPossible: true
            )
        }
    }
}
