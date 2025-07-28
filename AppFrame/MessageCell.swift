//
//  MessageCell.swift
//  BarbaraAI
//
//  Created by Vasisht Muduganti on 1/25/25.
//

import UIKit


class MessageCell: UITableViewCell {
    
    private let messageView = UIView() // The view that will hold the label
    private let messageLabel = UILabel()
  var viewStack:ImageStackView?
  // The label inside the view
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var maxWidthConstraint: NSLayoutConstraint!
    private var minHeightConstraint: NSLayoutConstraint!  // Minimum height constraint
    
    private var minWidthConstraint: NSLayoutConstraint!   // Minimum width constraint
    private var type: Chatter = .AI // Default type
    
    private let padding: CGFloat = 12  // Padding inside the label and view
    private let cellSpacing: CGFloat = 8  // Space between cells
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Configure messageLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        messageLabel.font = UIFont.systemFont(ofSize: 25)  // Larger font size
        messageLabel.translatesAutoresizingMaskIntoConstraints = false


        // Configure messageView
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.layer.cornerRadius = 16  // Rounded corners
        messageView.clipsToBounds = true
        messageView.backgroundColor = UIColor.systemGray5  // Default color for the view
        
        // Add messageLabel to messageView




        // Add messageView to contentView
        contentView.addSubview(messageView)
        
        // Add leading and trailing constraints for the messageView
        leadingConstraint = messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        // Max width constraint for messageView (2/3 of contentView width)
        maxWidthConstraint = messageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.77)
        
        // Minimum height constraint
        minHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)  // Set minimum height (60 points for example)
        
        // Minimum width constraint for messageView
        minWidthConstraint = messageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)  // Set minimum width (50 points)
        
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            maxWidthConstraint, // Activate the max width constraint for messageView
            minHeightConstraint,  // Activate minimum height constraint for contentView
            minWidthConstraint,    // Activate minimum width constraint for messageView
            leadingConstraint,    // Activate leading constraint for messageView
            trailingConstraint,   // Activate trailing constraint for messageView
            
        ])
        
        // Set the cell's layout margins to create space between cells
        contentView.layoutMargins = UIEdgeInsets(top: cellSpacing, left: 0, bottom: 0, right: 0)
    }

    func configure(with message: Message, type: Chatter) {
      self.type = type
      if type == .user || type == .AIMessage{
        for i in messageView.subviews{
          i.removeFromSuperview()
        }
        messageView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
          messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: padding),
          messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -padding),
          messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: padding),
          messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -padding)
        ])
        messageLabel.text = message.text
      }
      else{
        viewStack = ImageStackView()
        for i in messageView.subviews{
          i.removeFromSuperview()
        }
        messageView.addSubview(viewStack!)
        viewStack?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          viewStack!.topAnchor.constraint(equalTo: self.messageView.topAnchor),
          viewStack!.bottomAnchor.constraint(equalTo: self.messageView.bottomAnchor),
          viewStack!.leadingAnchor.constraint(equalTo: self.messageView.leadingAnchor),
          viewStack!.trailingAnchor.constraint(equalTo: self.messageView.trailingAnchor)
        ])
      }



        // Adjust appearance based on sender type
        if type == .user {
            messageView.backgroundColor = #colorLiteral(red: 0.9434879422, green: 0.9520342946, blue: 0.9740492702, alpha: 1)
            messageLabel.textAlignment = .left
            messageLabel.textColor = .black

         // messageLabel.layer.opacity = 1.0
            // Align message to the right
            trailingConstraint.isActive = true
            leadingConstraint.isActive = false
        } else if type == .AI{
            messageView.backgroundColor = #colorLiteral(red: 0.9006846547, green: 0.1294605434, blue: 0.1589042544, alpha: 1)
            messageLabel.textAlignment = .left
            messageLabel.textColor = .black
         // viewStack.layer.opacity = 1.0


            // Align message to the left
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
        }
      else if type == .AIMessage{
        messageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageLabel.textAlignment = .left
        messageLabel.textColor = .white
        leadingConstraint.isActive = true
        trailingConstraint.isActive = false
      }

        // Ensure the label is wrapped properly within the bubble with padding
        //messageLabel.layer.cornerRadius = 16
        messageLabel.layer.masksToBounds = true
        
        // Set the line break mode for wrapping text
        messageLabel.lineBreakMode = .byWordWrapping
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Optional: Redraw the label with padding (if required)
    }
    
}

struct Message:Codable {
    let sender: String
    let text: String
    let timestamp: Date
  var webURL:String
  var imageURL:String
}
struct Yield:Codable {
  var webURL = ""
  var imageURL = ""
  var gptResponse = ""
}
extension UIImageView {
    func startVibrationEffect() {
        let vibrationDuration = 1.0
        let vibrationIntensity: CGFloat = 30.0 // Maximum shake intensity

        UIView.animateKeyframes(withDuration: vibrationDuration, delay: 0, options: [.repeat, .autoreverse]) {
            // Keyframe 1: Slight left movement
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                self.transform = CGAffineTransform(translationX: -vibrationIntensity / 2, y: 0)
            }
            // Keyframe 2: Slight right movement
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.transform = CGAffineTransform(translationX: vibrationIntensity, y: 0)
            }
            // Keyframe 3: Back to the center
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.1) {
                self.transform = CGAffineTransform(translationX: -vibrationIntensity, y: 0)
            }
            // Keyframe 4: Settle to the original position
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                self.transform = .identity
            }
        }
    }

    func stopVibrationEffect() {
        // Stops all ongoing animations on the image view
        self.layer.removeAllAnimations()
        self.transform = .identity
    }
}
