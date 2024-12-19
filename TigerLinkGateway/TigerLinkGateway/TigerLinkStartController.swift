//
//  TigerLinkStartController.swift
//  TigerLink Gateway
//
//  Created by jin fu on 2024/12/19.
//

import UIKit

class TigerLinkStartController: UIViewController {

    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            print("横屏")
            configUI(isH: true)
        } else {
            print("竖屏")
            configUI(isH: false)
        }
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if size.width > size.height {
            print("横屏")
            configUI(isH: true)
        } else {
            print("竖屏")
            configUI(isH: false)
        }
    }
    
    private func configUI(isH: Bool) {
        if isH {
            self.stackView.axis = .horizontal
        } else {
            self.stackView.axis = .vertical
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
