package biz.karms.urbangaming.client.widgets;

import biz.karms.urbangaming.client.service.WebSocket;

import com.google.gwt.event.dom.client.ChangeEvent;
import com.google.gwt.event.dom.client.ChangeHandler;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.HorizontalPanel;
import com.google.gwt.user.client.ui.ListBox;
import com.google.gwt.user.client.ui.VerticalPanel;

/**
 * 
 * @author Michal Karm Babacek
 * 
 */
public class VideoDronePanel extends HorizontalPanel {

    // TODO: To be used further...
    private String videoDroneId = null;
    private final ListBox dropBox = new ListBox(false);

    public VideoDronePanel(final String videoDroneId, final WebSocket webSocket, final VerticalPanel verticalLogPanel) {
        this.videoDroneId = videoDroneId;
        dropBox.addItem("./media/test/1.mov");
        dropBox.addItem("./media/test/2.mov");
        dropBox.addItem("./media/test/3.mov");
        dropBox.addItem("./media/test/4.mov");
        dropBox.addItem("./media/test/5.mov");
        dropBox.addChangeHandler(new ChangeHandler() {
            public void onChange(ChangeEvent arg0) {
                String message = "play " + videoDroneId + " " + dropBox.getItemText(dropBox.getSelectedIndex());
                webSocket.send(message);
                verticalLogPanel.add(new HTML("Log: "+message+"</br>"));
            }
        });
        this.setHorizontalAlignment(ALIGN_JUSTIFY);
        this.add(new HTML("VideoDrone ID:" + videoDroneId));
        this.setStyleName(".video-drone-panel");
        this.add(dropBox);
    }
}
