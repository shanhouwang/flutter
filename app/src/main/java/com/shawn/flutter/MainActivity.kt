package com.shawn.flutter

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.shawn.flutter.ui.theme.MyFlutterApplicationTheme
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MainActivity : ComponentActivity() {
    
    private val FLUTTER_ENGINE_ID = "flutter_engine_id"
    private val CHANNEL = "flutter_to_android"
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // 预热 Flutter 引擎
        warmUpFlutterEngine()
        
        enableEdgeToEdge()
        setContent {
            MyFlutterApplicationTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    MainContent(
                        onNavigateToFlutterHome = { navigateToFlutterHome() },
                        onNavigateToFlutterProfile = { navigateToFlutterProfile() },
                        onNavigateToFlutterSettings = { navigateToFlutterSettings() },
                        onNavigateToFlutterProducts = { navigateToFlutterProducts() },
                        modifier = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }
    
    private fun warmUpFlutterEngine() {
        // 创建并缓存 Flutter 引擎
        val flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        
        // 设置 MethodChannel 用于 Flutter 回调
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "goBack" -> {
                    finish()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        
        FlutterEngineCache.getInstance().put(FLUTTER_ENGINE_ID, flutterEngine)
    }
    
    private fun navigateToFlutter(route: String = "/") {
        startActivity(
            CustomFlutterActivity
                .withCachedEngineAndRoute(FLUTTER_ENGINE_ID, route)
                .build(this)
        )
    }
    
    // 跳转到不同的 Flutter 页面
    private fun navigateToFlutterHome() = navigateToFlutter("/")
    private fun navigateToFlutterProfile() = navigateToFlutter("/profile")
    private fun navigateToFlutterSettings() = navigateToFlutter("/settings")
    private fun navigateToFlutterProducts() = navigateToFlutter("/products")
    
    override fun onDestroy() {
        super.onDestroy()
        // 清理 Flutter 引擎缓存
        FlutterEngineCache.getInstance().remove(FLUTTER_ENGINE_ID)
    }
}

@Composable
fun MainContent(
    onNavigateToFlutterHome: () -> Unit,
    onNavigateToFlutterProfile: () -> Unit,
    onNavigateToFlutterSettings: () -> Unit,
    onNavigateToFlutterProducts: () -> Unit,
    modifier: Modifier = Modifier
) {
    var clickCount by remember { mutableStateOf(0) }
    
    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        // 标题
        Text(
            text = "Android 主页面",
            fontSize = 28.sp,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.primary,
            textAlign = TextAlign.Center
        )
        
        Spacer(modifier = Modifier.height(16.dp))
        
        Text(
            text = "这是一个混合开发的应用\n选择要跳转的 Flutter 页面",
            fontSize = 16.sp,
            textAlign = TextAlign.Center,
            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.7f)
        )
        
        Spacer(modifier = Modifier.height(32.dp))
        
        // 计数卡片
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp),
            elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
            shape = RoundedCornerShape(12.dp)
        ) {
            Column(
                modifier = Modifier.padding(24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = "按钮点击次数",
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Medium
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = "$clickCount",
                    fontSize = 48.sp,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.primary
                )
            }
        }
        
        Spacer(modifier = Modifier.height(32.dp))
        
        // Flutter 页面导航按钮
        Text(
            text = "Flutter 页面导航",
            fontSize = 20.sp,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.primary
        )
        
        Spacer(modifier = Modifier.height(16.dp))
        
        // 第一行按钮
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Button(
                onClick = {
                    clickCount++
                    onNavigateToFlutterHome()
                },
                modifier = Modifier
                    .weight(1f)
                    .height(48.dp),
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.primary)
            ) {
                Text("首页", fontSize = 14.sp)
            }
            
            Button(
                onClick = {
                    clickCount++
                    onNavigateToFlutterProfile()
                },
                modifier = Modifier
                    .weight(1f)
                    .height(48.dp),
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.secondary)
            ) {
                Text("个人资料", fontSize = 14.sp)
            }
        }
        
        Spacer(modifier = Modifier.height(8.dp))
        
        // 第二行按钮
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Button(
                onClick = {
                    clickCount++
                    onNavigateToFlutterSettings()
                },
                modifier = Modifier
                    .weight(1f)
                    .height(48.dp),
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.tertiary)
            ) {
                Text("设置", fontSize = 14.sp)
            }
            
            Button(
                onClick = {
                    clickCount++
                    onNavigateToFlutterProducts()
                },
                modifier = Modifier
                    .weight(1f)
                    .height(48.dp),
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.error)
            ) {
                Text("商品列表", fontSize = 14.sp)
            }
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // 重置按钮
        OutlinedButton(
            onClick = { clickCount = 0 },
            modifier = Modifier
                .fillMaxWidth()
                .height(48.dp)
                .padding(horizontal = 16.dp),
            shape = RoundedCornerShape(12.dp)
        ) {
            Text(
                text = "重置计数",
                fontSize = 16.sp
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun MainContentPreview() {
    MyFlutterApplicationTheme {
        MainContent(
            onNavigateToFlutterHome = {},
            onNavigateToFlutterProfile = {},
            onNavigateToFlutterSettings = {},
            onNavigateToFlutterProducts = {}
        )
    }
}