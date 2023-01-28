//
//  SecondViewController.swift
//  photoRecognization
//
//  Created by saki shishikura on 2023/01/26.
//

import UIKit
import VisionKit

class SecondViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionShowDataScanner() {
        let scannerVC = DataScannerViewController(
            recognizedDataTypes: [.text(languages: ["ja"])],
                qualityLevel: .fast,
                recognizesMultipleItems: false,
                isHighFrameRateTrackingEnabled: false,
                isGuidanceEnabled: true,
                isHighlightingEnabled: true
        )
        scannerVC.delegate = self
        try? scannerVC.startScanning()
        self.present(scannerVC, animated: true)
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

extension SecondViewController: DataScannerViewControllerDelegate {
    
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            
            print(item)
            
        }
    
}
