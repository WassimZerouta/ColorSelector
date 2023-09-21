//
//  LivePickerViewController.swift
//  ColorSelector
//
//  Created by Wass on 13/09/2023.
//

import UIKit
import AVFoundation

class LivePickerViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var screenshotTimer: Timer?
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    var hexColor: String?
    
    let colorDisplayer = UIView()
    
    let saveButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor(named: "IconColor")
        button.image = image
        return button
    }()
    
    private let crossView = UIView()
    
    var capturedImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorDisplayerView()
        addCapturedImageView()
        labelView()
        addCrossView()
        saveButtonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        screenshotTimer?.invalidate()
        screenshotTimer = nil
        captureSession?.stopRunning()
    }
    
    
    func addCapturedImageView() {
        view.addSubview(capturedImageView)
        
        
        capturedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        capturedImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        capturedImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        capturedImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        capturedImageView.bottomAnchor.constraint(equalTo: colorDisplayer.topAnchor).isActive = true
        
        capturedImageView.contentMode = .scaleAspectFill
    }
    
    private func colorDisplayerView() {
        view.addSubview(colorDisplayer)
        colorDisplayer.translatesAutoresizingMaskIntoConstraints = false
        colorDisplayer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        colorDisplayer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        colorDisplayer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        colorDisplayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func labelView() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        label.centerYAnchor.constraint(equalTo: colorDisplayer.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: colorDisplayer.centerXAnchor).isActive = true
        
        
    }
    
    private func saveButtonView() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.rightAnchor.constraint(equalTo: colorDisplayer.rightAnchor, constant: -20).isActive = true
        saveButton.centerYAnchor.constraint(equalTo: colorDisplayer.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        saveButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped))
        saveButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func saveButtonTapped() {
        guard hexColor != nil else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.saveButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.saveButton.tintColor = .green
        }) { (finished) in
            UIView.animate(withDuration: 0.1, animations: {
                self.saveButton.transform = CGAffineTransform.identity
            })
        }
        
        var savedColorsArray = UserDefaults.standard.array(forKey: "SavedColorsArray") as? [String] ?? []
        savedColorsArray.append(hexColor!)
        UserDefaults.standard.set(savedColorsArray, forKey: "SavedColorsArray")
        UserDefaults.standard.synchronize()
    }
    
    func addCrossView() {
        let crossSize: CGFloat = 20
        crossView.frame = CGRect(x: (view.frame.width - crossSize) / 2, y: (view.frame.height - crossSize) / 2, width: crossSize, height: crossSize)
        crossView.backgroundColor = .clear
        view.addSubview(crossView)
        
        let lineWidth: CGFloat = 2
        let crossPath = UIBezierPath()
        crossPath.lineWidth = lineWidth
        crossPath.move(to: CGPoint(x: crossSize / 2, y: 0))
        crossPath.addLine(to: CGPoint(x: crossSize / 2, y: crossSize))
        crossPath.move(to: CGPoint(x: 0, y: crossSize / 2))
        crossPath.addLine(to: CGPoint(x: crossSize, y: crossSize / 2))
        
        let crossLayer = CAShapeLayer()
        crossLayer.path = crossPath.cgPath
        crossLayer.strokeColor = UIColor.white.cgColor
        crossLayer.lineWidth = lineWidth
        crossView.layer.addSublayer(crossLayer)
    }
    
    func setupCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            if let captureSession = captureSession {
                captureSession.addInput(input)
                
                captureSession.sessionPreset = .high
                
                photoOutput = AVCapturePhotoOutput()
                if let photoOutput = photoOutput {
                    captureSession.addOutput(photoOutput)
                }
                
                DispatchQueue.global(qos: .background).async {
                    captureSession.startRunning()
                }
                
                screenshotTimer = Timer.scheduledTimer(timeInterval: 1.0 / 24.0, target: self, selector: #selector(captureImage), userInfo: nil, repeats: true)
            }
        } catch {
            print(error)
        }
    }
    
    func addSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession!.addInput(input)
        } catch {
            print(error)
        }
        
        captureSession!.sessionPreset = .high
        
        photoOutput = AVCapturePhotoOutput()
        if let photoOutput = photoOutput {
            captureSession!.addOutput(photoOutput)
        }
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession!.startRunning()
        }
        
        screenshotTimer = Timer.scheduledTimer(timeInterval: 1.0 / 24.0, target: self, selector: #selector(captureImage), userInfo: nil, repeats: true)
    }
    
    @objc func captureImage() {
        guard let photoOutput = photoOutput else { return }
        
        let photoSettings = AVCapturePhotoSettings()
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
}

extension LivePickerViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            
            DispatchQueue.main.async {
                self.capturedImageView.image = image
                let color = image.getPixelColorAtPoint(point: self.crossView.center, sourceView: self.capturedImageView)
                self.hexColor = image.getHexaValue(point: self.crossView.center, sourceView: self.capturedImageView)
                self.label.text = self.hexColor
                
                let luminance = color.luminance
                self.crossView.tintColor = luminance < 0.5 ? .white : .black
                self.label.textColor = luminance < 0.5 ? .white : .black
                self.saveButton.tintColor = luminance < 0.5 ? .white : .black
                self.colorDisplayer.backgroundColor = color
            }
        }
    }
}
