package com.shorthub.app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        if (intent?.action == Intent.ACTION_SEND) {
            setTheme(R.style.TransparentTheme)
        }
        super.onCreate(savedInstanceState)
    }
}
