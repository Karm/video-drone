package biz.karms.urbangaming.client;

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
	
	public void onModuleLoad() {
		
		ResizeLayoutPanel resizePanel = new ResizeLayoutPanel();
		resizePanel.setPixelSize(600, 400);
		resizePanel.setWidget(new HTML("meh..."));
		
		decorator.add(resizePanel);
		RootPanel.get("videoDroneGUI").add(decorator);

	}
	
}
