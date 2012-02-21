/**
 * Copyright 2010 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package biz.karms.urbangaming.client.service;

import com.google.gwt.core.client.JavaScriptObject;

public class WebSocket {
    private final static class WebSocketImpl extends JavaScriptObject {
        public static native WebSocketImpl create(WebSocket client,
                String server)
        /*-{
         // Michal Karm Babacek: An important hack that makes it run in FireFox 8,9
         //var ws = new WebSocket(server);
         var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
         var ws = new Socket(server);
         ws.onopen = $entry(function() {
            client.@biz.karms.urbangaming.client.service.WebSocket::onOpen()();
         });
         ws.onmessage = $entry(function(response) {
            client.@biz.karms.urbangaming.client.service.WebSocket::onMessage(Ljava/lang/String;)(response.data);
         });
         ws.onclose = $entry(function() {
            client.@biz.karms.urbangaming.client.service.WebSocket::onClose()();
         });
         return ws;
        }-*/;

        public static native boolean isSupported() /*-{
         return (!!window.WebSocket || !!window.MozWebSocket);
        }-*/;

        protected WebSocketImpl() {
        }

        public native void close() /*-{
         this.close();
        }-*/;

        public native void send(String data) /*-{
         this.send(data);
        }-*/;
    }

    private final WebSocketCallback callback;
    private WebSocketImpl webSocket;

    public WebSocket(WebSocketCallback callback) {
        this.callback = callback;
    }

    public void close() {
        if (webSocket == null) {
            throw new IllegalStateException("Not connected");
        }
        webSocket.close();
        webSocket = null;
    }

    public void connect(String server) {
        if (!WebSocketImpl.isSupported()) {
            throw new RuntimeException("No WebSocket support");
        }
        webSocket = WebSocketImpl.create(this, server);
    }

    public void send(String data) {
        if (webSocket == null) {
            throw new IllegalStateException("Not connected");
        }
        webSocket.send(data);
    }

    @SuppressWarnings("unused")
    private void onClose() {
        callback.onDisconnect();
    }

    @SuppressWarnings("unused")
    private void onMessage(String message) {
        callback.onMessage(message);
    }

    @SuppressWarnings("unused")
    private void onOpen() {
        callback.onConnect();
    }
}
