package com.lavacahacemu.sweetpomodoro;

import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;

public class Main extends Application {

	private BorderPane rootLayout;

	@FXML
	Button btnStartStop;
	@FXML protected void handleStartStopAction(ActionEvent ae){
		isTimerOn = !isTimerOn;
		if (isTimerOn) {
			btnStartStop.setText("Stop");
			System.out.println("pressed Start");
		} else {
			btnStartStop.setText("Start");
			System.out.println("pressed Stop");
		}
	}
	
	@FXML
	Button btnReset;
	@FXML
	Label lblTime;

	boolean isTimerOn = false;

	@Override
	public void start(Stage primaryStage) {
		try {
			// Load root layout from fxml file.
			FXMLLoader loader = new FXMLLoader();
			loader.setLocation(Main.class.getResource("SweetPomodoro.fxml"));
			rootLayout = (BorderPane) loader.load();

			init(primaryStage);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void init(Stage primaryStage) {
		// Show the scene containing the root layout.

		Scene scene = new Scene(rootLayout);
		primaryStage.setScene(scene);
		primaryStage.show();
	}

	public static void main(String[] args) {
		launch(args);
	}
}
