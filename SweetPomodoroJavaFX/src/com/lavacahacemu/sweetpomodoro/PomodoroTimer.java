package com.lavacahacemu.sweetpomodoro;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

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