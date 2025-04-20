package com.example.yogarendersdk

import android.content.Context
import android.graphics.Color
import android.util.Log
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.TextView

/**
 * YogaRenderSDK - SDK for rendering content in native Android views
 */
class YogaRenderSDK private constructor() {
    companion object {
        private const val TAG = "YogaRenderSDK"
        
        // Singleton instance
        @Volatile
        private var instance: YogaRenderSDK? = null
        
        fun getInstance(): YogaRenderSDK {
            return instance ?: synchronized(this) {
                instance ?: YogaRenderSDK().also { instance = it }
            }
        }
    }
    
    /**
     * Renders content in the provided container view
     * @param containerView The view to render content in
     * @param backgroundColor Hexadecimal color string (e.g. "#3388FF")
     * @param content Text content to display
     * @return Boolean indicating success
     */
    fun renderContent(containerView: ViewGroup, backgroundColor: String, content: String): Boolean {
        try {
            // Set container background color
            containerView.setBackgroundColor(parseColor(backgroundColor))
            
            // Remove any existing content
            containerView.removeAllViews()
            
            // Create and configure text view
            val textView = TextView(containerView.context)
            textView.layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            )
            textView.textAlignment = TextView.TEXT_ALIGNMENT_CENTER
            textView.gravity = Gravity.CENTER
            textView.text = "Native Render: $content"
            
            // Add to container
            containerView.addView(textView)
            
            Log.d(TAG, "Android: Content rendered - backgroundColor: $backgroundColor, content: $content")
            return true
        } catch (e: Exception) {
            Log.e(TAG, "Error rendering content", e)
            return false
        }
    }
    
    /**
     * Creates a view with rendered content
     * @param context Android context
     * @param backgroundColor Hexadecimal color string (e.g. "#3388FF")
     * @param content Text content to display
     * @return View with rendered content
     */
    fun createContentView(context: Context, backgroundColor: String, content: String): View {
        val containerView = FrameLayout(context)
        containerView.layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        
        renderContent(containerView, backgroundColor, content)
        return containerView
    }
    
    /**
     * Safely parse color string
     * @param colorString Hexadecimal color string
     * @return Parsed color as integer
     */
    private fun parseColor(colorString: String): Int {
        return try {
            Color.parseColor(colorString)
        } catch (e: Exception) {
            Log.w(TAG, "Color parsing failed: $colorString, using default white")
            Color.WHITE
        }
    }
} 