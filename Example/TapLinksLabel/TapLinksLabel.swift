//
//  LinksLabel.swift
//  91-vcLinks
//
//  Created by Cosmin Potocean on 11/13/16.
//  Copyright © 2016 Cosmin Potocean. All rights reserved.
//

import UIKit

protocol TapLinksLabelDelegate: class {
    // when a link is tapped in the LinksLabel
    func linkWasTapped(url:URL)
}

class TapLinksLabel: UILabel {
    
    weak var delegate :TapLinksLabelDelegate?
    
    @IBInspectable
    var linksColor :UIColor = UIColor.blue {
        didSet {
            self.commonInit()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit(){
        if self.text != nil {
            self.attributedText = textToAttributtedTextWithLinks(newTextContent: self.text!)
        }
        self.isUserInteractionEnabled = true
        // adding tap to label
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap)) // ############
        self.addGestureRecognizer(tap)
    }
    
    // converts text to attributed text with colored links and metadata
    func textToAttributtedTextWithLinks(newTextContent :String)->NSAttributedString {
        
        let attributedTextWithLinks = NSMutableAttributedString(string: newTextContent)
        // looking for url's
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: newTextContent, options: [], range: NSRange(location: 0, length: newTextContent.utf16.count))
        // same font size needed for layoutmanager and range in handle tap func
        attributedTextWithLinks.addAttribute(NSFontAttributeName, value: self.font, range: NSRange(location: 0,length: newTextContent.utf16.count))
        
        for link in matches {
            if let url = link.url {
                attributedTextWithLinks.addAttribute(NSForegroundColorAttributeName, value: linksColor, range: link.range)
                // adding url value as metadata on the link range
                attributedTextWithLinks.addAttribute("URL", value: url, range: link.range)
            }
        }
        return attributedTextWithLinks
    }
    // handles the tap on a link in the attributed text of the label
    func handleTap(sender: UITapGestureRecognizer) { 
        if sender.state == .ended {

            // current size of label
            let thisLabelSize = self.bounds.size
            
            // text container
            let textContainer = NSTextContainer(size: thisLabelSize)
            textContainer.lineFragmentPadding = 0.0
            textContainer.lineBreakMode = self.lineBreakMode
            textContainer.maximumNumberOfLines = self.numberOfLines
            
            // layout manager
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(textContainer)
            
            // text storage
            let textStorage = NSTextStorage(attributedString: self.attributedText!)
            textStorage.addLayoutManager(layoutManager)
            
            // calculate location of touch on text
            let touchLocation = sender.location(in: self)
            let textBoundingRect = layoutManager.usedRect(for: textContainer)
            let textContainerOffset = CGPoint(x: (thisLabelSize.width - textBoundingRect.size.width) * 0.5 - textBoundingRect.origin.x,
                                              y: (thisLabelSize.height - textBoundingRect.size.height) * 0.5 - textBoundingRect.origin.y)
            let touchLocationInTextContainer = CGPoint(x: touchLocation.x - textContainerOffset.x, y: touchLocation.y - textContainerOffset.y)
            
            // find charater index at the touch location
            let characterIndex = layoutManager.characterIndex(for: touchLocationInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            
            if let tappedUrl = self.attributedText?.attributes(at: characterIndex, effectiveRange: nil)["URL"] as? URL {
                // a link was tapped
                delegate?.linkWasTapped(url: tappedUrl)
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
