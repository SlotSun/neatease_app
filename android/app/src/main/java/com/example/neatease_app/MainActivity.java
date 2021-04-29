package com.example.neatease_app;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.BatteryManager;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    public static MainActivity activity;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        activity = this;
        String CHANNEL = "android/service";
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (methodCall, result) -> {
                    if (methodCall.method.equals("backDesktop")) {
                        result.success(true);
                        moveTaskToBack(false);
                    }else if(methodCall.method.equals("getBattery")){
                        BatteryManager bm = (BatteryManager)getSystemService(Context.BATTERY_SERVICE);
                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                            int level =  bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
                            result.success(level);
                        }
                    }else if(methodCall.method.equals("getList")){
                        System.out.println("调用了");

                    }else if(methodCall.method.equals("openSetting")){
                        Intent intent = new Intent(android.provider.Settings.ACTION_SETTINGS);
                        startActivity(intent);

                    }else if(methodCall.method.equals("openView")){
                        Intent intent = new Intent();
                        intent.setAction(Intent.ACTION_GET_CONTENT);
                        intent.setType("image/*");
                        startActivityForResult(intent, 1);
                    }
                }
        );
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
}

