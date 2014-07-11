package com.lavacahacemu.sweetpomodoro;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

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
			timer.start();
		} else {
			btnStartStop.setText("Start");
			System.out.println("pressed Stop");
			timer.stop();
		}
	}
	
	@FXML
	Button btnReset;
	@FXML
	Label lblTime;

	boolean isTimerOn = false;
	protected PomodoroTimer timer = new PomodoroTimer(new ITimerFiredListener() {
		@Override
		public void timerFired() {
			// TODO Auto-generated method stub
			System.out.println("timer fired");
		}
	});
	
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

interface ITimerFiredListener{
	public void timerFired();
}

class PomodoroTimer{
	ScheduledExecutorService executor;
	ITimerFiredListener listener;
	
	public PomodoroTimer(){
		executor = Executors.newScheduledThreadPool(1);
	}
	
	public PomodoroTimer(ITimerFiredListener listener) {
		executor = Executors.newScheduledThreadPool(1);
		this.listener = listener;
	}

	public void setListener(ITimerFiredListener listener) {
		this.listener = listener;
	}

	private Runnable theRunnable = new Runnable(){
		public void run(){
//			System.out.println("timer fired");
			listener.timerFired();
		}
	};
	
	
	public void start(){
		executor.scheduleAtFixedRate(theRunnable, 0, 1, TimeUnit.SECONDS);
	}
	
	public void stop(){
		executor.shutdown();
	}
	
}
