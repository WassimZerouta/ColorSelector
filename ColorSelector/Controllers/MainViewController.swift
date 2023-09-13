//
//  MainViewController.swift
//  ColorSelector
//
//  Created by Wass on 08/09/2023.
//

import UIKit
import Lottie

class MainViewController: UIViewController {
    
    private var animationView: LottieAnimationView?

    let showGalleryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ajoutez une image", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    let content = UIView()
    let picture = UIImageView()
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    let colorDisplayer = UIView()
    
    
    
    var zoomBubbleView: ZoomBubbleView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        showAnimationView()
     //   showGalleryButtonView()
        contentView()
        colorDisplayerView()
        pictureView()
        rgbLabelView()
    }
    
    private func showAnimationView() {
        animationView = .init(name: "uploadPictureLottie")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        animationView!.addGestureRecognizer(tapGesture)
    }
    
    private func showGalleryButtonView() {

        showGalleryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showGalleryButton)
        showGalleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showGalleryButton.topAnchor.constraint(equalTo: animationView!.bottomAnchor, constant: 10).isActive = true
    }
    
    private func contentView() {
        self.view.addSubview(content)
        content.backgroundColor = .darkGray.withAlphaComponent(0.7)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        content.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        content.isHidden = true
        
    }
    
    private func pictureView() {
        content.addSubview(picture)
        picture.contentMode = .scaleAspectFit
        picture.translatesAutoresizingMaskIntoConstraints = false
        picture.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        picture.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        picture.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        picture.bottomAnchor.constraint(equalTo: colorDisplayer.topAnchor).isActive = true
        
        picture.isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorPicker(_:)))
        picture.addGestureRecognizer(longPressGesture)
        picture.addGestureRecognizer(tapGesture)

        
    }
    
    private func rgbLabelView() {
        content.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: colorDisplayer.safeAreaLayoutGuide.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: colorDisplayer.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    private func colorDisplayerView() {
        content.addSubview(colorDisplayer)
        colorDisplayer.translatesAutoresizingMaskIntoConstraints = false
        colorDisplayer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        colorDisplayer.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        colorDisplayer.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        colorDisplayer.bottomAnchor.constraint(equalTo: content.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
    }
    
    
    @objc func buttonTapped() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func colorPicker(_ tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: picture)
        print("Tap location: \(location)")
        
        if let color = picture.image?.getPixelColorAtPoint(point: location, sourceView: picture) {
            label.text = color.stringRepresentation
            colorDisplayer.backgroundColor = color
        }
        
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let touchPoint = gesture.location(in: picture)
        let zoomSize = CGSize(width: 150, height: 150)

        switch gesture.state {
        case .began:
            let zoomedRect = CGRect(x: touchPoint.x - zoomSize.width / 2, y: touchPoint.y - zoomSize.height / 2, width: zoomSize.width, height: zoomSize.height)
            
            if let sourceImage = picture.image,
               let cgImage = sourceImage.cgImage,
               let croppedCGImage = cgImage.cropping(to: CGRect(x: touchPoint.x / picture.bounds.width * CGFloat(cgImage.width), y: touchPoint.y / picture.bounds.height * CGFloat(cgImage.height) - zoomSize.height, width: zoomSize.width, height: zoomSize.height)) {
                
                let zoomedImage = UIImage(cgImage: croppedCGImage)
                zoomBubbleView = ZoomBubbleView(frame: zoomedRect, image: zoomedImage)
                zoomBubbleView?.colorPicker(image: zoomedImage, label: label, colorDisplayer: colorDisplayer)
                view.addSubview(zoomBubbleView!)
            }
        case .changed:
            let zoomedRect = CGRect(x: touchPoint.x - zoomSize.width / 2, y: touchPoint.y - zoomSize.height / 2, width: zoomSize.width, height: zoomSize.height)
            zoomBubbleView?.frame = zoomedRect
            
            if let sourceImage = picture.image,
               let cgImage = sourceImage.cgImage,
               let croppedCGImage = cgImage.cropping(to: CGRect(x: touchPoint.x / picture.bounds.width * CGFloat(cgImage.width), y: touchPoint.y / picture.bounds.height * CGFloat(cgImage.height) - zoomSize.height, width: zoomSize.width, height: zoomSize.height)) {
                
                let zoomedImage = UIImage(cgImage: croppedCGImage)
                zoomBubbleView?.updateImage(image: zoomedImage)
                zoomBubbleView?.colorPicker(image: zoomedImage, label: label, colorDisplayer: colorDisplayer)            }
        case .ended:
            zoomBubbleView?.removeFromSuperview()
            zoomBubbleView = nil
        default:
            break
        }
    }



}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            let compressedImage = UIImage(data: jpegData)
            picture.image = compressedImage
        }
        content.isHidden = (picture.image == nil) ? true : false

        dismiss(animated: true)
    }
    

    
}








