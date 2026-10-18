package com.dat3m.ui.components;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.swing.*;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.function.DoubleConsumer;

/*
    Pinch-to-zoom on the trackpads of macOS. Swing has no public API for gestures, so this uses the internal
    gesture support of the JDK on macOS, which the manifest of the jar exports (Add-Exports: java.desktop/com.apple.eawt.event).
    Elsewhere, or if the API is not accessible, nothing happens: pinching on Windows arrives as Ctrl + mouse wheel anyway.
 */
public final class PinchZoom {

    private static final Logger logger = LoggerFactory.getLogger(PinchZoom.class);

    private PinchZoom() {
    }

    // The listener receives the factor by which to scale, e.g. 1.05 when the fingers move apart a little.
    public static void install(JComponent target, DoubleConsumer zoomBy) {
        if (!System.getProperty("os.name", "").toLowerCase().contains("mac")) {
            return;
        }
        try {
            final Class<?> gestureListener = Class.forName("com.apple.eawt.event.GestureListener");
            final Class<?> magnificationListener = Class.forName("com.apple.eawt.event.MagnificationListener");
            final Method getMagnification = Class.forName("com.apple.eawt.event.MagnificationEvent").getMethod("getMagnification");
            final Object listener = Proxy.newProxyInstance(PinchZoom.class.getClassLoader(), new Class<?>[]{magnificationListener},
                    (proxy, method, arguments) -> {
                        if (method.getName().equals("magnify")) {
                            zoomBy.accept(1 + (double) getMagnification.invoke(arguments[0]));
                            return null;
                        }
                        return switch (method.getName()) {
                            case "hashCode" -> System.identityHashCode(proxy);
                            case "equals" -> proxy == arguments[0];
                            case "toString" -> "PinchZoom listener";
                            default -> null;
                        };
                    });
            Class.forName("com.apple.eawt.event.GestureUtilities")
                    .getMethod("addGestureListenerTo", JComponent.class, gestureListener)
                    .invoke(null, target, listener);
        } catch (ReflectiveOperationException | RuntimeException e) {
            logger.debug("Pinch-to-zoom is not available.", e);
        }
    }
}
