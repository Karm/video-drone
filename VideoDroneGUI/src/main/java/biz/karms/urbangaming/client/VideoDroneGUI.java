package biz.karms.urbangaming.client;

import biz.karms.urbangaming.client.service.WebSocket;
import biz.karms.urbangaming.client.service.WebSocketCallback;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.user.client.ui.DecoratorPanel;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.ResizeLayoutPanel;
import com.google.gwt.user.client.ui.RootPanel;

/**
 * 
 * @author Michal Karm Babacek
 * 
 */
public class VideoDroneGUI implements EntryPoint {
    private final DecoratorPanel decorator = new DecoratorPanel();
    private final ResizeLayoutPanel resizePanel = new ResizeLayoutPanel();
    private final String server = "ws://localhost:8080/";
    
    public void onModuleLoad() {
        resizePanel.setPixelSize(600, 400);
        resizePanel.setWidget(new HTML("meh..."));
        decorator.add(resizePanel);
        RootPanel.get("videoDroneGUI").add(decorator);
        WebSocketCallback webSocketCallback = new WebSocketCallback() {
            
            public void onMessage(String message) {
                resizePanel.setWidget(new HTML("Message received: "+message));
            }
            
            public void onDisconnect() {
                resizePanel.setWidget(new HTML("Disconnected."));
            }
            
            public void onConnect() {
                resizePanel.setWidget(new HTML("Connected."));
            }
        };
        
        WebSocket webSocket = new WebSocket(webSocketCallback);
        webSocket.connect(server);
    }

}
