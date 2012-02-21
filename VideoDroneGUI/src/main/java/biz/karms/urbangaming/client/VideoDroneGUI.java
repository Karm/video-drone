package biz.karms.urbangaming.client;

import biz.karms.urbangaming.client.service.WebSocket;
import biz.karms.urbangaming.client.service.WebSocketCallback;
import biz.karms.urbangaming.client.widgets.VideoDronePanel;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.user.client.ui.Button;
import com.google.gwt.user.client.ui.DecoratorPanel;
import com.google.gwt.user.client.ui.FlowPanel;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.HorizontalPanel;
import com.google.gwt.user.client.ui.RootPanel;
import com.google.gwt.user.client.ui.TextBox;
import com.google.gwt.user.client.ui.VerticalPanel;

/**
 * 
 * @author Michal Karm Babacek
 * 
 */
public class VideoDroneGUI implements EntryPoint {
    private final DecoratorPanel decoratorForFlow = new DecoratorPanel();
    private final DecoratorPanel decoratorForVert = new DecoratorPanel();
    private final DecoratorPanel decoratorForHorizon = new DecoratorPanel();
    private final FlowPanel flowPanel = new FlowPanel();
    private final VerticalPanel verticalLogPanel = new VerticalPanel();
    private final VerticalPanel mainVerticalPanel = new VerticalPanel();
    private final HorizontalPanel controlPanel = new HorizontalPanel();
    private final Button startButton = new Button("Start");
    private final TextBox serverAddress = new TextBox();
    private final String server = "ws://localhost:8080/";
    private WebSocketCallback webSocketCallback = null;
    private WebSocket webSocket = null;

    public void onModuleLoad() {
        // Init the basic flow panel
        decoratorForFlow.add(flowPanel);
        decoratorForVert.add(verticalLogPanel);
        decoratorForHorizon.add(controlPanel);
        mainVerticalPanel.add(decoratorForHorizon);
        mainVerticalPanel.add(decoratorForFlow);
        mainVerticalPanel.add(decoratorForVert);
        controlPanel.add(serverAddress);
        controlPanel.add(startButton);
        serverAddress.setText(server);
        startButton.addClickHandler(new ClickHandler() {
            
            public void onClick(ClickEvent arg0) {
                startVideoDroneGUI(serverAddress.getText());
            }
        });
        RootPanel.get("videoDroneGUI").add(mainVerticalPanel);
       

    }

    private void startVideoDroneGUI(String serverAddress) {
        webSocketCallback = new WebSocketCallback() {
            public void onMessage(String message) {
                verticalLogPanel.add(new HTML("Log: Message received: " + message + "</br>"));
                if (message.startsWith("drones")) {
                    //It is crude to erase all, TODO: Remove only the necessary ones.
                    flowPanel.clear();
                    String delims = "[ ,\"\\]\\[]+";
                    //Magic "7"is "drones " :-)  Just testing, prototyping...
                    for (String token : message.substring(7).split(delims)) {
                        //Just playing. TODO: Move parsing to a separate class and make it properly :-)
                        if (token.length() > 0) {
                            verticalLogPanel.add(new HTML("Log: Token: " + token + "</br>"));
                            addNewVideoDrone(token);
                        }
                    }
                }
            }

            public void onDisconnect() {
                verticalLogPanel.add(new HTML("Log: Disconnected from the VideoDroneServer.</br>"));
            }

            public void onConnect() {
                verticalLogPanel.add(new HTML("Log: Connected to the VideoDroneServer.</br>"));
            }
        };

        webSocket = new WebSocket(webSocketCallback);
        verticalLogPanel.add(new HTML("Log: I am gonna to connect to: " + serverAddress + "</br>"));
        webSocket.connect(serverAddress);
    }
    
    private void addNewVideoDrone(String videoDroneId) {
        flowPanel.add(new VideoDronePanel(videoDroneId, webSocket, verticalLogPanel));
    }
}
