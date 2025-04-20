import UIKit

public class YogaRenderSDK {
    // Singleton instance
    public static let shared = YogaRenderSDK()
    
    private init() {}
    
    /**
     * Renders content in the provided container view
     * - Parameters:
     *   - containerView: The UIView to render content in
     *   - backgroundColor: Hexadecimal color string (e.g. "#3388FF")
     *   - content: Text content to display
     * - Returns: Boolean indicating success
     */
    public func renderContent(in containerView: UIView, backgroundColor: String, content: String) -> Bool {
        // Configure container view
        containerView.backgroundColor = hexStringToUIColor(hex: backgroundColor)
        
        // Remove any existing content
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        // Create and configure text label
        let textLabel = UILabel(frame: containerView.bounds)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textLabel.text = "Native SDK Render: \(content)"
        
        // Add label to container
        containerView.addSubview(textLabel)
        
        print("YogaRenderSDK iOS: Content rendered - backgroundColor: \(backgroundColor), content: \(content)")
        return true
    }
    
    /**
     * Creates a UIView with rendered content
     * - Parameters:
     *   - frame: Frame for the view
     *   - backgroundColor: Hexadecimal color string (e.g. "#3388FF")
     *   - content: Text content to display
     * - Returns: UIView with rendered content
     */
    public func createContentView(frame: CGRect, backgroundColor: String, content: String) -> UIView {
        let containerView = UIView(frame: frame)
        _ = renderContent(in: containerView, backgroundColor: backgroundColor, content: content)
        return containerView
    }
    
    // Helper: Convert hex string to UIColor
    private func hexStringToUIColor(hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        // Default to white
        if hexSanitized.isEmpty {
            return UIColor.white
        }
        
        var rgb: UInt64 = 0
        
        if !Scanner(string: hexSanitized).scanHexInt64(&rgb) {
            return UIColor.white
        }
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
} 