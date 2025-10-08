package com.shawn.flutter

import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class CustomFlutterActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "flutter_to_android"

        fun withCachedEngineAndRoute(
            cachedEngineId: String, route: String = "/"
        ): CachedEngineIntentBuilder {
            var builder = MyCachedEngineIntentBuilder(
                CustomFlutterActivity::class.java,
                cachedEngineId
            )
            builder.destroyEngineWithActivity(false);
            builder.putIntentExtras(mapOf("route" to route))
            return builder
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 获取路由参数
        val route = intent.getStringExtra("route") ?: "/"

        // 设置 MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "goBack" -> {
                        finish()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

            // 主动发送初始路由给 Flutter
            invokeMethod("setInitialRoute", route)
        }
    }
}

// 扩展 CachedEngineIntentBuilder 以支持额外数据
class MyCachedEngineIntentBuilder(
    activityClass: Class<out FlutterActivity>, cachedEngineId: String
) : FlutterActivity.CachedEngineIntentBuilder(activityClass, cachedEngineId) {

    private var intentExtras: Map<String, String>? = null

    fun putIntentExtras(params: Map<String, String>?): MyCachedEngineIntentBuilder {
        this.intentExtras = params
        return this
    }

    override fun build(context: Context): Intent {
        val intent = super.build(context)
        intentExtras?.forEach { (key, value) ->
            intent.putExtra(key, value)
        }
        return intent
    }
}
