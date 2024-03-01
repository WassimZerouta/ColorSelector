//
//  LivePickerViewController.swift
//  ColorSelector
//
//  Created by Wass on 13/09/2023.
//

import UIKit
import AVFoundation

class LivePickerViewController: UIViewController {
    
    var hexColor: String?
    
    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var screenshotTimer: Timer?
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let colorDisplayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let saveButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor(named: "IconColor")
        button.image = image
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let crossView: CrossView = {
        let view = CrossView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var capturedImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        
        let tapSaveButtonGesture = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped))
        saveButton.addGestureRecognizer(tapSaveButtonGesture)
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
    
    private func setupConstraints() {
        view.addSubview(capturedImageView)
        view.addSubview(colorDisplayer)
        view.addSubview(label)
        view.addSubview(saveButton)
        view.addSubview(crossView)
        
        NSLayoutConstraint.activate([
            capturedImageView.topAnchor.constraint(equalTo: view.topAnchor),
            capturedImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            capturedImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            capturedImageView.bottomAnchor.constraint(equalTo: colorDisplayer.topAnchor),
            
            colorDisplayer.heightAnchor.constraint(equalToConstant: 100),
            colorDisplayer.rightAnchor.constraint(equalTo: view.rightAnchor),
            colorDisplayer.leftAnchor.constraint(equalTo: view.leftAnchor),
            colorDisplayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            label.heightAnchor.constraint(equalToConstant: 100),
            label.centerYAnchor.constraint(equalTo: colorDisplayer.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: colorDisplayer.centerXAnchor),
            
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            saveButton.rightAnchor.constraint(equalTo: colorDisplayer.rightAnchor, constant: -20),
            saveButton.centerYAnchor.constraint(equalTo: colorDisplayer.safeAreaLayoutGuide.centerYAnchor),
            
            crossView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            crossView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            crossView.widthAnchor.constraint(equalToConstant: crossView.crossSize),
            crossView.heightAnchor.constraint(equalToConstant: crossView.crossSize)
        ])
        
    }
    
    @objc private func saveButtonTapped() {
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
    
    
    
    private func setupCaptureSession() {
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
                
                screenshotTimer = Timer.scheduledTimer(timeInterval: 1.0 / 30, target: self, selector: #selector(captureImage), userInfo: nil, repeats: true)
            }
        } catch {
            print(error)
        }
    }
    
    private func addSession() {
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
        
        screenshotTimer = Timer.scheduledTimer(timeInterval: 1.0 / 20, target: self, selector: #selector(captureImage), userInfo: nil, repeats: true)
    }
    
    @objc private func captureImage() {
        
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
