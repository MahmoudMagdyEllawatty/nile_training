package com.nile.training.app.nile_training;
import android.annotation.TargetApi;
import android.content.Context;
import android.hardware.display.DisplayManager;
import android.view.Display;
import android.os.Build;

public class ScreenRecordDetector {

    public interface ScreenRecordListener {
        void onScreenRecordStarted();
        void onScreenRecordStopped();
    }

    private Context context;
    private ScreenRecordListener listener;
    private DisplayManager displayManager;
    private DisplayManager.DisplayListener displayListener;

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    public ScreenRecordDetector(Context context, ScreenRecordListener listener) {
        this.context = context;
        this.listener = listener;
        this.displayManager = (DisplayManager) context.getSystemService(Context.DISPLAY_SERVICE);
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    public void startListening() {
        if (displayManager == null) return;

        displayListener = new DisplayManager.DisplayListener() {
            @Override
            public void onDisplayAdded(int displayId) {
                // قد يشير إضافة شاشة جديدة إلى بدء التسجيل
                if (isScreenCapturing(displayId)) {
                    if (listener != null) {
                        listener.onScreenRecordStarted();
                    }
                }
            }

            @Override
            public void onDisplayRemoved(int displayId) {
                // قد يشير إزالة شاشة إلى توقف التسجيل
                if (!isScreenCapturingAnyDisplay()) { // التحقق من عدم وجود أي شاشات تسجيل نشطة
                    if (listener != null) {
                        listener.onScreenRecordStopped();
                    }
                }
            }

            @Override
            public void onDisplayChanged(int displayId) {
                // يمكن استخدام هذا لمراقبة التغييرات في الشاشات الموجودة
            }
        };

        displayManager.registerDisplayListener(displayListener, null);
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    public void stopListening() {
        if (displayManager != null && displayListener != null) {
            displayManager.unregisterDisplayListener(displayListener);
        }
    }

    // التحقق مما إذا كانت أي شاشة افتراضية نشطة تشير إلى تسجيل
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    private boolean isScreenCapturingAnyDisplay() {
        if (displayManager == null) return false;
        for (Display display : displayManager.getDisplays()) {
            if (isScreenCapturing(display.getDisplayId())) {
                return true;
            }
        }
        return false;
    }

    // التحقق من شاشة معينة إذا كانت تشير إلى تسجيل
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    private boolean isScreenCapturing(int displayId) {
        if (displayManager == null) return false;
        Display display = displayManager.getDisplay(displayId);
        if (display == null) return false;

        // غالباً ما تكون شاشات التسجيل الافتراضية غير أساسية وليست شاشات عرض طبيعية
        // كما أنها قد تحمل FLAG_SECURE إذا كان النظام يحاول حماية المحتوى
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            // Display.FLAG_SECURE يشير إلى شاشة افتراضية محمية من الالتقاط،
            // لكن هنا نستخدمها كعلامة على أنها قد تكون شاشة تسجيل داخلية
            if ((display.getFlags() & Display.FLAG_SECURE) != 0) {
                // هذا قد يكون مؤشراً قوياً على تسجيل الشاشة، خاصة في الأجهزة التي تدعمها
                return true;
            }
        }

        // مؤشرات أخرى للشاشات الافتراضية التي قد تكون تسجيل شاشة
        // - نوع الشاشة (TYPE_VIRTUAL)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) { // API 30+
            // في Android 11 (R) وما فوق، يمكنك استخدام getCategory()
            // ولكن هذا لا يغطي كل حالات التسجيل (مثل Quick Settings tile)
        }
        // يمكن أيضاً التحقق من اسم الشاشة الافتراضية إذا كان معروفاً (ولكنه غير موثوق به)
        // ومقارنة العرض والارتفاع بالشاشة الأصلية

        return false;
    }
}