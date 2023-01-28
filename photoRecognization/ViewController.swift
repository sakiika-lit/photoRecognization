//
//  ViewController.swift
//  photoRecognization
//
//  Created by saki shishikura on 2023/01/22.
//

import UIKit
import Vision
import VisionKit

class ViewController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    var requests = [VNRequest]()
    var resultingText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupVision()
    }

    func setupVision(){
        let textRecognitionRequest = VNRecognizeTextRequest { request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("The observations are of an unexpected type.")
                return
            }

            let maximumCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                self.resultingText += candidate.string + "\n"
            }
        }

            textRecognitionRequest.recognitionLevel = .accurate
            self.requests = [textRecognitionRequest]
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
}

extension ViewController: DataScannerViewControllerDelegate {

    func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]){

        print(allItems)
    }

    // DocumentCamera で画像の保存に成功したときに呼ばれる
    func documentCameraViewController(_ controller: DataScannerViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)

        // Dispatch queue to perform Vision requests.
        let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue",
                                                             qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
        textRecognitionWorkQueue.async {
            self.resultingText = ""
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

                    do {
                        try requestHandler.perform(self.requests)
                    } catch {
                        print(error)
                    }
                }
            }
            DispatchQueue.main.async(execute: {
                // textViewに表示する
                self.textView.text = self.resultingText
            })
        }
    }
}
